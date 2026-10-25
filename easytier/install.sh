#!/bin/sh

# =======================================================
# EasyTier KoolCenter 软件中心插件安装脚本
# 适用平台: Asuswrt 3.0.0.6 (3006) 官改固件 - ROG 魔盒 (GS7) / MTK / HND
# =======================================================

MODULE="easytier"
PLUGIN_VERSION="1.2.1"
CORE_VERSION="2.6.4"
VERSION="$PLUGIN_VERSION"
KS_DIR="/koolshare"

source $KS_DIR/scripts/base.sh
alias echo_date='echo 【$(date +"%Y年%m月%d日 %H:%M:%S")】'

BIN_DIR="$KS_DIR/bin"
SCRIPT_DIR="$KS_DIR/scripts"
WEB_DIR="$KS_DIR/webs"
RES_DIR="$KS_DIR/res"
INIT_DIR="$KS_DIR/init.d"
CONFIG_DIR="$KS_DIR/configs"

# 自动检测安装源目录 (支持离线安装包解压到 /tmp 的任意路径)
detect_source_dir() {
    local script_dir="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
    if [ -f "$script_dir/install.sh" ] && [ -f "$script_dir/config.json.js" ]; then
        echo "$script_dir"
    elif [ -d "/tmp/easytier" ] && [ -f "/tmp/easytier/install.sh" ]; then
        echo "/tmp/easytier"
    elif [ -d "/tmp/$MODULE" ] && [ -f "/tmp/$MODULE/install.sh" ]; then
        echo "/tmp/$MODULE"
    else
        echo "$script_dir"
    fi
}
SOURCE_DIR="$(detect_source_dir)"

check_arch() {
    ARCH=$(uname -m)
    case "$ARCH" in
        aarch64|arm64)
            echo_date "✅ 检测到支持的硬件架构: $ARCH (ARM64)"
            ;;
        *)
            echo_date "⚠️ 当前系统架构: $ARCH (优先推荐 aarch64 / ARM64 设备)"
            ;;
    esac
}

check_space() {
    local available=$(df $KS_DIR | tail -1 | awk '{print $4}')
    local required=6000
    if [ -n "$available" ] && [ "$available" -lt "$required" ] 2>/dev/null; then
        echo_date "⚠️ 警告: JFFS 分区剩余可用空间较小 (${available}KB)，请留意磁盘占用！"
    else
        echo_date "✅ JFFS 分区空间充足 (${available}KB 可用)"
    fi
}

install_files() {
    echo_date "正在复制 EasyTier 核心文件..."
    
    mkdir -p $BIN_DIR
    mkdir -p $SCRIPT_DIR
    mkdir -p $WEB_DIR
    mkdir -p $RES_DIR
    mkdir -p $INIT_DIR
    mkdir -p $CONFIG_DIR

    # 1. 拷贝核心二进制
    if [ -f "$SOURCE_DIR/bin/easytier-core" ]; then
        cp -f "$SOURCE_DIR/bin/easytier-core" $BIN_DIR/easytier-core
        chmod 755 $BIN_DIR/easytier-core
        echo_date "✓ easytier-core 主核心安装成功"
    else
        echo_date "❌ 错误: 未找到核心二进制文件 $SOURCE_DIR/bin/easytier-core"
        exit 1
    fi

    # 2. 拷贝命令行工具 (easytier-cli)
    if [ -f "$SOURCE_DIR/bin/easytier-cli" ]; then
        cp -f "$SOURCE_DIR/bin/easytier-cli" $BIN_DIR/easytier-cli
        chmod 755 $BIN_DIR/easytier-cli
        echo_date "✓ easytier-cli 状态监控工具安装成功"
    fi

    # 3. 拷贝主控脚本
    if [ -f "$SOURCE_DIR/scripts/easytier_config.sh" ]; then
        cp -f "$SOURCE_DIR/scripts/easytier_config.sh" $SCRIPT_DIR/easytier_config.sh
        chmod 755 $SCRIPT_DIR/easytier_config.sh
        echo_date "✓ 后台服务主控脚本安装成功"
    fi

    # 4. 拷贝 Web 管理页面
    if [ -f "$SOURCE_DIR/webs/Module_easytier.asp" ]; then
        cp -f "$SOURCE_DIR/webs/Module_easytier.asp" $WEB_DIR/Module_easytier.asp
        echo_date "✓ Web 管理界面配置成功"
    fi

    # 5. 拷贝插件图标
    if [ -f "$SOURCE_DIR/res/icon-easytier.png" ]; then
        cp -f "$SOURCE_DIR/res/icon-easytier.png" $RES_DIR/icon-easytier.png
    fi

    # 6. 拷贝卸载脚本
    if [ -f "$SOURCE_DIR/uninstall.sh" ]; then
        cp -f "$SOURCE_DIR/uninstall.sh" $SCRIPT_DIR/uninstall_easytier.sh
        chmod 755 $SCRIPT_DIR/uninstall_easytier.sh
    fi
}

setup_init() {
    echo_date "配置开机自启脚本..."

    # 开机启动脚本 S99easytier.sh
    cat > $INIT_DIR/S99easytier.sh <<-EOF
#!/bin/sh
source ${KS_DIR}/scripts/base.sh

# 检查服务开关及开机自启开关
if [ "\$(dbus get easytier_enable)" = "1" ] && [ "\$(dbus get easytier_autostart)" = "1" ]; then
    if [ -f ${KS_DIR}/scripts/easytier_config.sh ]; then
        sh ${KS_DIR}/scripts/easytier_config.sh start
    fi
fi
EOF
    chmod 755 $INIT_DIR/S99easytier.sh

    # 关机停止脚本 N99easytier.sh
    cat > $INIT_DIR/N99easytier.sh <<-EOF
#!/bin/sh
if [ -f ${KS_DIR}/scripts/easytier_config.sh ]; then
    sh ${KS_DIR}/scripts/easytier_config.sh stop
fi
EOF
    chmod 755 $INIT_DIR/N99easytier.sh
}

register_dbus() {
    echo_date "向软件中心注册插件信息..."

    # 注册软件中心标准条目
    dbus set softcenter_module_easytier_name="easytier"
    dbus set softcenter_module_easytier_title="EasyTier"
    dbus set softcenter_module_easytier_version="$PLUGIN_VERSION"
    dbus set softcenter_module_easytier_install="1"
    dbus set softcenter_module_easytier_description="简单、安全、去中心化的内网穿透 VPN 组网工具"
    dbus set softcenter_module_easytier_homeurl="Module_easytier.asp"
    dbus set easytier_plugin_version="$PLUGIN_VERSION"
    dbus set easytier_core_version="$CORE_VERSION"
    dbus set easytier_version="$CORE_VERSION"

    # 初始化默认值 (若未设置过)
    [ -z "$(dbus get easytier_autostart)" ] && dbus set easytier_autostart="1"
    [ -z "$(dbus get easytier_watchdog)" ] && dbus set easytier_watchdog="1"
    [ -z "$(dbus get easytier_watchdog_val)" ] && dbus set easytier_watchdog_val="5"
    [ -z "$(dbus get easytier_watchdog_unit)" ] && dbus set easytier_watchdog_unit="min"
    [ -z "$(dbus get easytier_route_mode)" ] && dbus set easytier_route_mode="all"
    local WAN_IP=$(nvram get wan0_ipaddr 2>/dev/null)
    [ -z "$WAN_IP" ] && WAN_IP=$(nvram get wan_ipaddr 2>/dev/null)
    local DEF_WAN_SUBNET="192.168.1.0/24"
    if [ -n "$WAN_IP" ]; then
        DEF_WAN_SUBNET=$(echo "$WAN_IP" | awk -F. '{printf "%d.%d.%d.0/24", $1, $2, $3}')
    fi
    [ -z "$(dbus get easytier_route_blacklist)" ] && dbus set easytier_route_blacklist="$DEF_WAN_SUBNET"
    [ -z "$(dbus get easytier_accept_routes)" ] && dbus set easytier_accept_routes="1"
    [ -z "$(dbus get easytier_mode)" ] && dbus set easytier_mode="simple"
    [ -z "$(dbus get easytier_port)" ] && dbus set easytier_port="11010"
    [ -z "$(dbus get easytier_peers)" ] && dbus set easytier_peers="tcp://public.easytier.top:11010"
    [ -z "$(dbus get easytier_dhcp)" ] && dbus set easytier_dhcp="1"
    
    local MODEL=$(nvram get odmpid)
    [ -z "$MODEL" ] && MODEL=$(nvram get productid)
    [ -z "$MODEL" ] && MODEL="ROG-GS7"
    [ -z "$(dbus get easytier_node_name)" ] && dbus set easytier_node_name="$MODEL"
    [ -z "$(dbus get easytier_network_name)" ] && dbus set easytier_network_name="default_net"

    # 自动获取路由器默认 LAN 网段用于局域网子网代理
    if [ -z "$(dbus get easytier_proxy_network)" ]; then
        local LAN_IP=$(nvram get lan_ipaddr)
        if [ -n "$LAN_IP" ]; then
            local SUBNET=$(echo "$LAN_IP" | awk -F. '{printf "%d.%d.%d.0/24", $1, $2, $3}')
            dbus set easytier_proxy_network="$SUBNET"
        fi
    fi
}

main() {
    echo_date "======================================================="
    echo_date "开始安装 EasyTier 插件 (v$VERSION) ..."
    echo_date "安装源目录: $SOURCE_DIR"

    # 停止旧服务
    if [ -f "$SCRIPT_DIR/easytier_config.sh" ]; then
        echo_date "检测到已安装版本，正在停止旧服务..."
        sh $SCRIPT_DIR/easytier_config.sh stop >/dev/null 2>&1
    fi
    killall easytier-core >/dev/null 2>&1

    check_arch
    check_space
    install_files
    setup_init
    register_dbus

    echo_date "======================================================="
    echo_date "🎉 EasyTier 插件安装完成！"
    echo_date "请刷新路由器软件中心页面，或访问: http://$(nvram get lan_ipaddr)/Module_easytier.asp"
    echo_date "======================================================="
    exit 0
}

main "$@"
