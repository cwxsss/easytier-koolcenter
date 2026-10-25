#!/bin/sh

# =======================================================
# EasyTier 插件卸载清理脚本
# =======================================================

KS_DIR="/koolshare"
source ${KS_DIR}/scripts/base.sh
alias echo_date='echo 【$(date +"%Y年%m月%d日 %H:%M:%S")】'

echo_date "======================================================="
echo_date "开始卸载 EasyTier 插件..."

# 1. 停止运行中的服务并清理防火墙与计划任务
cru d easytier_watchdog >/dev/null 2>&1
if [ -f "${KS_DIR}/scripts/easytier_config.sh" ]; then
    echo_date "⏹️ 正在停止 EasyTier 服务与清理网络规则..."
    sh ${KS_DIR}/scripts/easytier_config.sh stop >/dev/null 2>&1
fi
killall easytier-core >/dev/null 2>&1

# 2. 删除程序二进制与脚本
echo_date "🗑️ 正在删除插件文件..."
rm -f ${KS_DIR}/bin/easytier-core
rm -f ${KS_DIR}/bin/easytier-cli
rm -f ${KS_DIR}/webs/Module_easytier.asp
rm -f ${KS_DIR}/res/icon-easytier.png
rm -f ${KS_DIR}/init.d/S99easytier.sh
rm -f ${KS_DIR}/init.d/N99easytier.sh
rm -f ${KS_DIR}/configs/easytier.conf
rm -f ${KS_DIR}/scripts/easytier_config.sh

# 清理运行时临时文件
rm -f /var/run/easytier.pid
rm -f /tmp/upload/easytier_*.txt
rm -f /tmp/upload/easytier_*.log

# 3. 清理系统 dbus 变量
echo_date "🧹 正在清理系统数据库配置 (dbus)..."
dbus remove softcenter_module_easytier_name
dbus remove softcenter_module_easytier_title
dbus remove softcenter_module_easytier_version
dbus remove softcenter_module_easytier_install
dbus remove softcenter_module_easytier_description
dbus remove softcenter_module_easytier_homeurl

dbus remove easytier_version
dbus remove easytier_enable
dbus remove easytier_autostart
dbus remove easytier_watchdog
dbus remove easytier_watchdog_interval
dbus remove easytier_accept_routes
dbus remove easytier_mode
dbus remove easytier_node_name
dbus remove easytier_network_name
dbus remove easytier_network_secret
dbus remove easytier_dhcp
dbus remove easytier_ipv4
dbus remove easytier_port
dbus remove easytier_proxy_network
dbus remove easytier_peers
dbus remove easytier_peers_encoded
dbus remove easytier_config_content
dbus remove easytier_config_content_encoded

rm -f ${KS_DIR}/scripts/uninstall_easytier.sh

echo_date "✅ EasyTier 插件已彻底卸载完成！"
echo_date "======================================================="
exit 0
