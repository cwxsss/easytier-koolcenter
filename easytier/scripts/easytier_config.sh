#!/bin/sh

# =======================================================
# EasyTier 服务控制与配置管理脚本 (ASUS ROG / KoolCenter 专用)
# 适配 Asuswrt 3.0.0.6 (3006) 官改固件平台 (MTK MT7988 / ARM64)
# =======================================================

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +"%Y年%m月%d日 %H:%M:%S")】'

# 批量导出所有 easytier 相关 dbus 配置变量
eval $(dbus export easytier_) 2>/dev/null || true

CONFIG_FILE="$KSROOT/configs/easytier.conf"
EASYTIER_BIN="$KSROOT/bin/easytier-core"
EASYTIER_CLI="$KSROOT/bin/easytier-cli"
PID_FILE="/var/run/easytier.pid"
LOG_FILE="/tmp/upload/easytier_log.txt"
RUNTIME_LOG="/tmp/upload/easytier_runtime.log"
PEER_FILE="/tmp/upload/easytier_peer_info.txt"
NODE_FILE="/tmp/upload/easytier_node_info.txt"
ROUTE_FILE="/tmp/upload/easytier_route_info.txt"

mkdir -p /tmp/upload
mkdir -p "$KSROOT/configs"

# 解析参数
OPERATION=""
WEB_SUBMIT=""
for arg in "$@"; do
    case "$arg" in
        start|stop|restart|status|save_config|get_peers|get_nodes|get_routes|clear_runtime_log)
            OPERATION="$arg"
            ;;
        web_submit)
            WEB_SUBMIT="web_submit"
            ;;
    esac
done

[ -z "$OPERATION" ] && OPERATION="$1"

# 1. 快速状态检测 (无耗时无日志，专供前端高频轮询)
check_status() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null; then
        local PID=$(cat "$PID_FILE" 2>/dev/null)
        http_response "运行中 (PID: $PID)"
    else
        http_response "停止"
    fi
}

# 2. 检查并创建 TUN 虚拟网卡设备
check_tun() {
    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200 >/dev/null 2>&1
        chmod 666 /dev/net/tun >/dev/null 2>&1
    fi
    modprobe tun >/dev/null 2>&1
}

# 3. 配置文件生成逻辑
generate_config() {
    # 模式选择: custom (高级自定义TOML) 或 simple (简易向导模式)
    local MODE="${easytier_mode:-simple}"

    if [ "$MODE" = "custom" ]; then
        local content=""
        if [ -n "$easytier_config_content_encoded" ]; then
            content=$(echo "$easytier_config_content_encoded" | base64 -d 2>/dev/null)
        elif [ -n "$easytier_config_content" ]; then
            content="$easytier_config_content"
        fi

        if [ -z "$content" ]; then
            echo_date "❌ 错误: 高级模式下配置文件内容为空，请在 Web 页面填写！" >> $LOG_FILE
            return 1
        fi

        echo "$content" > "$CONFIG_FILE"
        chmod 600 "$CONFIG_FILE"
        echo_date "✅ 高级 TOML 配置文件已写入: $CONFIG_FILE" >> $LOG_FILE
        return 0
    fi

    # 简易模式生成 TOML 配置
    local NODE_NAME="${easytier_node_name}"
    if [ -z "$NODE_NAME" ]; then
        local MODEL=$(nvram get odmpid)
        [ -z "$MODEL" ] && MODEL=$(nvram get productid)
        [ -z "$MODEL" ] && MODEL="ROG-GS7"
        NODE_NAME="$MODEL"
    fi

    local NET_NAME="${easytier_network_name:-default_net}"
    local NET_SECRET="${easytier_network_secret:-}"
    local PORT="${easytier_port:-11010}"
    local DHCP_FLAG="${easytier_dhcp:-0}"
    local IPV4_ADDR="${easytier_ipv4:-}"
    local PROXY_NET="${easytier_proxy_network:-}"
    
    # 自动获取路由器局域网网段 (例如 192.168.50.0/24)
    if [ -z "$PROXY_NET" ]; then
        local LAN_IP=$(nvram get lan_ipaddr)
        if [ -n "$LAN_IP" ]; then
            local SUBNET=$(echo "$LAN_IP" | awk -F. '{printf "%d.%d.%d.0/24", $1, $2, $3}')
            PROXY_NET="$SUBNET"
        fi
    fi

    echo_date "正在生成 EasyTier 配置文件 (简易模式)..." >> $LOG_FILE
    cat > "$CONFIG_FILE" <<-EOF
# ==========================================
# EasyTier 配置文件 (由 KoolCenter 插件自动生成)
# ==========================================
instance_name = "$NODE_NAME"
hostname = "$NODE_NAME"

EOF

    if [ "$DHCP_FLAG" = "1" ] || [ -z "$IPV4_ADDR" ]; then
        cat >> "$CONFIG_FILE" <<-EOF
dhcp = true
EOF
    else
        cat >> "$CONFIG_FILE" <<-EOF
dhcp = false
ipv4 = "$IPV4_ADDR"
EOF
    fi

    cat >> "$CONFIG_FILE" <<-EOF

[network_identity]
network_name = "$NET_NAME"
network_secret = "$NET_SECRET"

listeners = [
    "tcp://0.0.0.0:$PORT",
    "udp://0.0.0.0:$PORT"
]

EOF

    # 处理对端节点列表
    local PEERS_RAW=""
    if [ -n "$easytier_peers_encoded" ]; then
        PEERS_RAW=$(echo "$easytier_peers_encoded" | base64 -d 2>/dev/null)
    else
        PEERS_RAW="$easytier_peers"
    fi

    if [ -n "$PEERS_RAW" ]; then
        echo "$PEERS_RAW" | while read -r line || [ -n "$line" ]; do
            # 过滤注释与空白行
            line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
            [ -z "$line" ] && continue
            echo "$line" | grep -q '^#' && continue
            
            cat >> "$CONFIG_FILE" <<-EOF
[[peer]]
uri = "$line"

EOF
        done
    fi

    # 处理子网代理 (局域网转发)
    if [ -n "$PROXY_NET" ]; then
        cat >> "$CONFIG_FILE" <<-EOF
# 路由器局域网子网代理 (允许异地节点访问家中的内网设备)
[[proxy_network]]
cidr = "$PROXY_NET"

EOF
    fi

    chmod 600 "$CONFIG_FILE"
    echo_date "✅ 简易向导配置文件生成完毕！" >> $LOG_FILE
    return 0
}

# 4. 防火墙与 NAT 转发规则设置
setup_firewall() {
    local PORT="${easytier_port:-11010}"
    echo_date "🛡️ 正在配置防火墙规则..." >> $LOG_FILE
    
    # 开启 Linux 内核 IP 转发
    echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1

    # 1. 允许 EasyTier 虚拟网卡入站流量 (ping 与访问路由网关)
    iptables -C INPUT -i tun+ -j ACCEPT 2>/dev/null || iptables -I INPUT -i tun+ -j ACCEPT 2>/dev/null
    
    # 2. 允许虚拟网卡与路由器局域网 (br0) 双向互通
    iptables -C FORWARD -i br0 -o tun+ -j ACCEPT 2>/dev/null || iptables -I FORWARD -i br0 -o tun+ -j ACCEPT 2>/dev/null
    iptables -C FORWARD -i tun+ -o br0 -j ACCEPT 2>/dev/null || iptables -I FORWARD -i tun+ -o br0 -j ACCEPT 2>/dev/null
    iptables -C FORWARD -i tun+ -j ACCEPT 2>/dev/null || iptables -I FORWARD -i tun+ -j ACCEPT 2>/dev/null
    iptables -C FORWARD -o tun+ -j ACCEPT 2>/dev/null || iptables -I FORWARD -o tun+ -j ACCEPT 2>/dev/null

    # 3. 启用 NAT 伪装，确保对端跨网段访问家庭内网设备时正常回包
    iptables -t nat -C POSTROUTING -o tun+ -j MASQUERADE 2>/dev/null || iptables -t nat -I POSTROUTING -o tun+ -j MASQUERADE 2>/dev/null
    iptables -t nat -C POSTROUTING -o br0 -j MASQUERADE 2>/dev/null || iptables -t nat -I POSTROUTING -o br0 -j MASQUERADE 2>/dev/null

    # 4. 开放 EasyTier 外部监听端口 (TCP / UDP)
    if [ -n "$PORT" ]; then
        iptables -C INPUT -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null || iptables -I INPUT -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null
        iptables -C INPUT -p udp --dport "$PORT" -j ACCEPT 2>/dev/null || iptables -I INPUT -p udp --dport "$PORT" -j ACCEPT 2>/dev/null
    fi

    echo_date "✅ 防火墙与 NAT 转发规则配置完成" >> $LOG_FILE
}

# 5. 清理防火墙规则
clean_firewall() {
    local PORT="${easytier_port:-11010}"
    echo_date "🧹 正在清理防火墙规则..." >> $LOG_FILE

    iptables -D INPUT -i tun+ -j ACCEPT 2>/dev/null
    iptables -D FORWARD -i br0 -o tun+ -j ACCEPT 2>/dev/null
    iptables -D FORWARD -i tun+ -o br0 -j ACCEPT 2>/dev/null
    iptables -D FORWARD -i tun+ -j ACCEPT 2>/dev/null
    iptables -D FORWARD -o tun+ -j ACCEPT 2>/dev/null
    iptables -t nat -D POSTROUTING -o tun+ -j MASQUERADE 2>/dev/null
    iptables -t nat -D POSTROUTING -o br0 -j MASQUERADE 2>/dev/null

    if [ -n "$PORT" ]; then
        iptables -D INPUT -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null
        iptables -D INPUT -p udp --dport "$PORT" -j ACCEPT 2>/dev/null
    fi
}

# 6. 启动 EasyTier 核心进程
start_easytier() {
    echo_date "🚀 正在启动 EasyTier 核心服务..." >> $LOG_FILE

    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null; then
        echo_date "⚠️ EasyTier 已经在运行中 (PID: $(cat $PID_FILE))，请勿重复启动" >> $LOG_FILE
        return 0
    fi

    if [ ! -f "$EASYTIER_BIN" ]; then
        echo_date "❌ 启动失败：未找到二进制文件 $EASYTIER_BIN" >> $LOG_FILE
        return 1
    fi
    chmod 755 "$EASYTIER_BIN" 2>/dev/null

    # 检查生成配置文件
    generate_config
    if [ "$?" != "0" ] || [ ! -s "$CONFIG_FILE" ]; then
        echo_date "❌ 启动失败：配置文件缺失或内容为空！" >> $LOG_FILE
        return 1
    fi

    # 准备 TUN 设备
    check_tun

    # 启动进程 (彻底断开标准输入输出，避免 Web 接口阻塞死锁)
    cd /tmp
    nohup "$EASYTIER_BIN" -c "$CONFIG_FILE" >> "$RUNTIME_LOG" 2>&1 </dev/null &
    local NEW_PID=$!
    echo $NEW_PID > "$PID_FILE"

    sleep 2

    if kill -0 $NEW_PID 2>/dev/null; then
        setup_firewall
        echo_date "✅ EasyTier 启动成功！进程 PID: $NEW_PID" >> $LOG_FILE
        dbus set easytier_enable="1"
        return 0
    else
        echo_date "❌ EasyTier 启动失败，进程意外退出！请检查配置文件或查看运行日志" >> $LOG_FILE
        rm -f "$PID_FILE"
        return 1
    fi
}

# 7. 停止 EasyTier 进程
stop_easytier() {
    echo_date "⏹️ 正在停止 EasyTier 服务..." >> $LOG_FILE

    clean_firewall

    if [ -f "$PID_FILE" ]; then
        local PID=$(cat "$PID_FILE" 2>/dev/null)
        if [ -n "$PID" ]; then
            kill "$PID" 2>/dev/null
            sleep 1
            kill -9 "$PID" 2>/dev/null
        fi
        rm -f "$PID_FILE"
    fi

    killall easytier-core >/dev/null 2>&1
    sleep 1

    echo_date "✅ EasyTier 服务已停止" >> $LOG_FILE
    dbus set easytier_enable="0"
    return 0
}

# 8. 查询 CLI 状态并写入文件 (供 Web 界面直接读取展示)
query_cli() {
    local TYPE="$1"
    if [ ! -x "$EASYTIER_CLI" ]; then
        echo "未找到 easytier-cli 工具" > "/tmp/upload/easytier_${TYPE}_info.txt"
        return 1
    fi

    if [ ! -f "$PID_FILE" ] || ! kill -0 $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null; then
        echo "EasyTier 服务当前未运行" > "/tmp/upload/easytier_${TYPE}_info.txt"
        return 1
    fi

    case "$TYPE" in
        peer)
            $EASYTIER_CLI peer > "$PEER_FILE" 2>&1
            ;;
        node)
            $EASYTIER_CLI node > "$NODE_FILE" 2>&1
            ;;
        route)
            $EASYTIER_CLI route > "$ROUTE_FILE" 2>&1
            ;;
    esac
}

# ==================== 请求路由中枢 ====================

# 1. 状态查询拦截 (高频，必须极速返回)
if [ "$OPERATION" = "status" ]; then
    check_status
    exit 0
fi

# 2. CLI 节点/对端/路由快速查询
if [ "$OPERATION" = "get_peers" ]; then
    query_cli peer
    http_response "success"
    exit 0
fi

if [ "$OPERATION" = "get_nodes" ]; then
    query_cli node
    http_response "success"
    exit 0
fi

if [ "$OPERATION" = "get_routes" ]; then
    query_cli route
    http_response "success"
    exit 0
fi

# 3. 前端 Web 表单提交处理 (采用非阻塞异步应答机制)
if [ "$WEB_SUBMIT" = "web_submit" ]; then
    # 立即响应前端 HTTP 请求，防止 httpd 出现 504 Gateway Timeout 或假死
    http_response "success"

    # 将耗时操作交由后台子 Shell 执行
    (
        true > "$LOG_FILE" 2>/dev/null
        echo_date "=======================================================" >> $LOG_FILE
        echo_date "收到 Web 操作指令: $OPERATION" >> $LOG_FILE
        echo_date "=======================================================" >> $LOG_FILE

        case "$OPERATION" in
            save_config)
                generate_config
                ;;
            start)
                start_easytier
                ;;
            stop)
                stop_easytier
                ;;
            restart)
                stop_easytier
                start_easytier
                ;;
            clear_runtime_log)
                true > "$RUNTIME_LOG" 2>/dev/null
                echo_date "✅ EasyTier 运行日志已清空" >> $LOG_FILE
                ;;
            *)
                echo_date "❌ 未知操作: $OPERATION" >> $LOG_FILE
                ;;
        esac

        echo_date "=======================================================" >> $LOG_FILE
        echo_date "✅ 所有指令执行完毕！" >> $LOG_FILE
        
        # 写入前端轮询结束标识符
        echo "XU6J03M6" >> $LOG_FILE
    ) >/dev/null 2>&1 &

    exit 0
fi

# 4. 命令行直接执行逻辑 (如 SSH 下手动启动 / 停止)
case "$OPERATION" in
    start)
        start_easytier
        ;;
    stop)
        stop_easytier
        ;;
    restart)
        stop_easytier
        start_easytier
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|get_peers|get_nodes|get_routes}"
        exit 1
        ;;
esac
