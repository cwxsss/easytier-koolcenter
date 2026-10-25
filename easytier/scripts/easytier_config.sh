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
LOCK_FILE="/var/lock/easytier.lock"
LOG_FILE="/tmp/upload/easytier_log.txt"
RUNTIME_LOG="/tmp/upload/easytier_runtime.log"
PEER_FILE="/tmp/upload/easytier_peer_info.txt"
NODE_FILE="/tmp/upload/easytier_node_info.txt"
ROUTE_FILE="/tmp/upload/easytier_route_info.txt"
CRON_ID="easytier_watchdog"

mkdir -p /tmp/upload
mkdir -p "$KSROOT/configs"

# 解析参数
OPERATION=""
WEB_SUBMIT=""
for arg in "$@"; do
    case "$arg" in
        start|stop|restart|status|save_config|get_peers|get_nodes|get_routes|clear_runtime_log|watchdog)
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
    local ROUTE_MODE="${easytier_route_mode:-all}"
    [ -z "$easytier_route_mode" ] && [ "$easytier_accept_routes" = "0" ] && ROUTE_MODE="none"
    
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

    # 路由接收控制: all (全部接收) / whitelist (仅接收白名单) / none (全部拒收)
    if [ "$ROUTE_MODE" = "none" ]; then
        cat >> "$CONFIG_FILE" <<-EOF

# 禁用接收对端动态子网路由 (防上级光猫/父网段冲突)
routes = []
EOF
    elif [ "$ROUTE_MODE" = "whitelist" ]; then
        local WL_RAW=""
        if [ -n "$easytier_route_whitelist_encoded" ]; then
            WL_RAW=$(echo "$easytier_route_whitelist_encoded" | base64 -d 2>/dev/null)
        else
            WL_RAW="$easytier_route_whitelist"
        fi

        cat >> "$CONFIG_FILE" <<-EOF

# 对端子网白名单路由 (仅接收指定子网，排除其他冲突网段)
routes = [
EOF
        if [ -n "$WL_RAW" ]; then
            echo "$WL_RAW" | tr ',;' '\n' | while read -r r_line || [ -n "$r_line" ]; do
                r_line=$(echo "$r_line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                [ -z "$r_line" ] && continue
                echo "$r_line" | grep -q '^#' && continue
                cat >> "$CONFIG_FILE" <<-EOF
    "$r_line",
EOF
            done
        fi
        cat >> "$CONFIG_FILE" <<-EOF
]
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
        # 预警检测: 检查子网代理是否与 WAN 口物理网段重合 (会导致网关被劫持、网络断开)
        local WAN_IP=$(nvram get wan0_ipaddr 2>/dev/null)
        [ -z "$WAN_IP" ] && WAN_IP=$(nvram get wan_ipaddr 2>/dev/null)
        if [ -n "$WAN_IP" ]; then
            local WAN_SUBNET=$(echo "$WAN_IP" | awk -F. '{printf "%d.%d.%d.0/24", $1, $2, $3}')
            if [ "$PROXY_NET" = "$WAN_SUBNET" ]; then
                echo_date "⚠️ [严重警告] 子网代理网段 ($PROXY_NET) 与路由器 WAN 口网段 ($WAN_SUBNET) 冲突！" >> $LOG_FILE
                echo_date "⚠️ [严重警告] 这极可能导致光猫默认网关被劫持、网络断开并引发系统终止服务！" >> $LOG_FILE
            fi
        fi

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
    
    # 开启 Linux 内核 IP 转发并放宽反向路径过滤 (确保跨网段数据包正常转发)
    echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
    for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
        echo 2 > "$f" 2>/dev/null || echo 0 > "$f" 2>/dev/null
    done

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

# 5. 策略路由与子网黑名单保护 (隔离上级光猫网段与黑名单网段，避免劫持 WAN 网关)
get_wan_subnet() {
    local ip=$(nvram get wan0_ipaddr 2>/dev/null)
    [ -z "$ip" ] && ip=$(nvram get wan_ipaddr 2>/dev/null)
    if [ -n "$ip" ]; then
        echo "$ip" | awk -F. '{printf "%d.%d.%d.0/24", $1, $2, $3}'
    fi
}

get_wan_if() {
    local ifname=$(nvram get wan0_ifname 2>/dev/null)
    [ -z "$ifname" ] && ifname=$(nvram get wan_ifname 2>/dev/null)
    [ -z "$ifname" ] && ifname=$(ip route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')
    echo "$ifname"
}

apply_route_blacklist() {
    local ROUTE_MODE="${easytier_route_mode:-all}"
    local WAN_SUBNET=$(get_wan_subnet)
    local WAN_IF=$(get_wan_if)

    # 1. 始终硬核锁死物理 WAN 口网段，确保默认网关和光猫绝不被 tun 劫持
    if [ -n "$WAN_SUBNET" ] && [ -n "$WAN_IF" ]; then
        ip route replace "$WAN_SUBNET" dev "$WAN_IF" table 188 2>/dev/null
        while ip rule list | grep -q "100:"; do
            ip rule del pref 100 2>/dev/null || break
        done
        ip rule add to "$WAN_SUBNET" table 188 pref 100 2>/dev/null
        ip route del "$WAN_SUBNET" dev tun0 2>/dev/null
        echo_date "🛡️ [策略路由] 已硬核锁定物理 WAN 网段 ($WAN_SUBNET -> $WAN_IF)，免疫任何路由劫持" >> $LOG_FILE
    fi

    # 2. 如果开启了黑名单模式，额外屏蔽用户指定的其他黑名单网段
    if [ "$ROUTE_MODE" = "blacklist" ]; then
        local BL_RAW=""
        if [ -n "$easytier_route_blacklist_encoded" ]; then
            BL_RAW=$(echo "$easytier_route_blacklist_encoded" | base64 -d 2>/dev/null)
        else
            BL_RAW="$easytier_route_blacklist"
        fi

        # 默认黑名单兜底
        [ -z "$BL_RAW" ] && [ -n "$WAN_SUBNET" ] && BL_RAW="$WAN_SUBNET"

        if [ -n "$BL_RAW" ]; then
            echo "$BL_RAW" | tr ',;' '\n' | while read -r cidr || [ -n "$cidr" ]; do
                cidr=$(echo "$cidr" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                [ -z "$cidr" ] && continue
                echo "$cidr" | grep -q '^#' && continue
                [ "$cidr" = "$WAN_SUBNET" ] && continue

                ip rule del to "$cidr" blackhole pref 101 2>/dev/null
                ip rule add to "$cidr" blackhole pref 101 2>/dev/null || ip rule add to "$cidr" unreachable pref 101 2>/dev/null
                ip route del "$cidr" dev tun0 2>/dev/null
                echo_date "🚫 [黑名单拦截] 已将黑名单子网 $cidr 设为不可达黑洞" >> $LOG_FILE
            done
        fi
    fi
}

clean_route_blacklist() {
    ip route flush table 188 2>/dev/null
    while ip rule list | grep -q "100:"; do
        ip rule del pref 100 2>/dev/null || break
    done
    while ip rule list | grep -q "101:"; do
        ip rule del pref 101 2>/dev/null || break
    done
}

# 6. 清理防火墙规则
clean_firewall() {
    local PORT="${easytier_port:-11010}"
    echo_date "🧹 正在清理防火墙规则..." >> $LOG_FILE

    clean_route_blacklist

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
        apply_route_blacklist
        echo_date "✅ EasyTier 启动成功！进程 PID: $NEW_PID" >> $LOG_FILE
        dbus set easytier_enable="1"
        setup_watchdog
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

    remove_watchdog
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

# 8. 看门狗守护与自动故障重启
setup_watchdog() {
    local WD_ENABLE="${easytier_watchdog:-1}"
    local WD_VAL="${easytier_watchdog_val:-5}"
    local WD_UNIT="${easytier_watchdog_unit:-min}"

    # 兼容老版 interval 变量
    if [ -z "$easytier_watchdog_val" ] && [ -n "$easytier_watchdog_interval" ]; then
        WD_VAL="$easytier_watchdog_interval"
        WD_UNIT="min"
    fi

    # 合法性校验
    case "$WD_VAL" in
        ''|*[!0-9]*) WD_VAL=5 ;;
    esac
    [ "$WD_VAL" -le 0 ] && WD_VAL=5

    local CRON_EXPR=""
    local LOG_UNIT=""
    if [ "$WD_UNIT" = "hour" ]; then
        [ "$WD_VAL" -gt 23 ] && WD_VAL=23
        CRON_EXPR="0 */$WD_VAL * * *"
        LOG_UNIT="${WD_VAL} 小时"
    else
        [ "$WD_VAL" -gt 59 ] && WD_VAL=59
        CRON_EXPR="*/$WD_VAL * * * *"
        LOG_UNIT="${WD_VAL} 分钟"
    fi

    cru d "$CRON_ID" >/dev/null 2>&1
    if [ "$WD_ENABLE" = "1" ]; then
        cru a "$CRON_ID" "$CRON_EXPR $KSROOT/scripts/easytier_config.sh watchdog"
        echo_date "🛡️ [Watchdog 守护] 已激活进程看门狗 (检查周期: 每 ${LOG_UNIT})" >> $LOG_FILE
    fi
}

remove_watchdog() {
    cru d "$CRON_ID" >/dev/null 2>&1
}

check_watchdog() {
    eval $(dbus export easytier_) 2>/dev/null || true
    [ "$easytier_enable" != "1" ] && exit 0
    [ "${easytier_watchdog:-1}" = "0" ] && exit 0

    local IS_RUNNING=0
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null; then
        IS_RUNNING=1
    elif pidof easytier-core >/dev/null 2>&1; then
        IS_RUNNING=1
    fi

    if [ "$IS_RUNNING" = "0" ]; then
        echo_date "⚠️ [Watchdog 守护] 检测到 EasyTier 进程异常退出，正在自动拉起重启..." >> $LOG_FILE
        echo_date "⚠️ [Watchdog 守护] 检测到 EasyTier 进程异常退出，正在自动拉起重启..." >> $RUNTIME_LOG
        start_easytier
    else
        # 巡检黑名单策略与路由清理
        apply_route_blacklist
    fi
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

# 3. Watchdog 守护检测快速拦截
if [ "$OPERATION" = "watchdog" ]; then
    check_watchdog
    exit 0
fi

# 4. 前端 Web 表单提交处理 (采用非阻塞异步应答机制 + 排他互斥锁)
if [ "$WEB_SUBMIT" = "web_submit" ]; then
    # 立即响应前端 HTTP 请求，防止 httpd 出现 504 Gateway Timeout 或假死
    http_response "success"

    # 将耗时操作交由后台子 Shell 执行
    (
        if command -v flock >/dev/null 2>&1; then
            exec 200>"$LOCK_FILE"
            flock -x -w 10 200 || {
                echo_date "⚠️ 另一个配置任务正在执行中，本次操作取消以防冲突" >> $LOG_FILE
                echo "XU6J03M6" >> $LOG_FILE
                exit 1
            }
        fi

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

# 5. 命令行直接执行逻辑 (如 SSH 下手动启动 / 停止)
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
    watchdog)
        check_watchdog
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|watchdog|get_peers|get_nodes|get_routes}"
        exit 1
        ;;
esac
