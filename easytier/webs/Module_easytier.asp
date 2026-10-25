<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<link rel="shortcut icon" href="/res/icon-easytier.png" />
<link rel="icon" href="/res/icon-easytier.png" />
<title>软件中心 - EasyTier</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/table/table.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/softcenter.js"></script>
<style>
a:focus { outline: none; }
.SimpleNote { padding: 8px 12px; line-height: 24px; background: rgba(0,0,0,0.3); border-radius: 4px; margin-bottom: 12px; white-space: nowrap; overflow: hidden; }
.SimpleNote a { color: #00ffe4; text-decoration: none; }
.SimpleNote a:hover { text-decoration: underline; }
i { color: #FC0; font-style: normal; }
.loadingBarBlock { width: 750px; }
.popup_bar_bg_ks { position: fixed; margin: auto; top: 0; left: 0; width: 100%; height: 100%; z-index: 999; filter: alpha(opacity=90); visibility: hidden; background: rgba(20, 24, 28, 0.88); }
.FormTitle em { color: #00ffe4; font-style: normal; }
.FormTable th { width: 22% !important; font-size: 13px; font-weight: normal; white-space: nowrap; }
.FormTable td { font-size: 13px; white-space: nowrap; }
.formfonttitle { font-family: Roboto-Light, "Microsoft JhengHei"; font-size: 18px; margin-left: 5px; font-weight: bold; }
.FormTitle, .FormTable th, .FormTable td { font-family: Roboto-Light, "Microsoft JhengHei"; }

/* ================= 按钮全面优化: 彻底覆写 softcenter.css width: 14% 限制 ================= */
.et_btn, .ks_btn {
    display: inline-block !important;
    width: auto !important;
    min-width: unset !important;
    max-width: none !important;
    height: 28px !important;
    line-height: 26px !important;
    padding: 0 12px !important;
    margin: 0 6px 0 0 !important;
    white-space: nowrap !important;
    word-break: keep-all !important;
    overflow: visible !important;
    text-overflow: clip !important;
    box-sizing: border-box !important;
    font-family: Roboto-Light, "Microsoft JhengHei", sans-serif !important;
    font-size: 12px !important;
    text-align: center !important;
    vertical-align: middle !important;
    cursor: pointer !important;
    border-radius: 4px !important;
    border: 1px solid #4a5a60 !important;
    background: #252e32 !important;
    color: #ffffff !important;
    text-decoration: none !important;
}
.et_btn:hover, .ks_btn:hover {
    background: #344247 !important;
    color: #00ffe4 !important;
    border-color: #00ffe4 !important;
    text-decoration: none !important;
}
.et_btn_danger, .ks_btn_danger {
    background: #5c1e24 !important;
    border-color: #8c2b34 !important;
    color: #ffcccc !important;
}
.et_btn_danger:hover, .ks_btn_danger:hover {
    background: #7c2830 !important;
    color: #ffffff !important;
    border-color: #ff4d4d !important;
}
.et_btn_primary {
    background: #8b0018 !important;
    border-color: #cf0a2c !important;
    color: #ffffff !important;
}
.et_btn_primary:hover {
    background: #ad001e !important;
    border-color: #ff2a4b !important;
    color: #ffffff !important;
}

/* 按钮操作工具栏 (强制单行不换行) */
.btn_toolbar {
    margin-bottom: 8px;
    white-space: nowrap !important;
    overflow-x: auto;
    overflow-y: hidden;
    line-height: 32px;
}

/* 状态徽章 */
.status_badge {
    display: inline-block !important;
    width: auto !important;
    max-width: none !important;
    white-space: nowrap !important;
    padding: 3px 10px !important;
    border-radius: 4px !important;
    font-weight: bold !important;
    font-size: 13px !important;
    letter-spacing: 0.5px !important;
    vertical-align: middle !important;
    line-height: 20px !important;
    box-sizing: border-box !important;
}
.status_running { background: #164e32 !important; color: #4ade80 !important; border: 1px solid #22c55e !important; }
.status_stopped { background: #4c1d24 !important; color: #f87171 !important; border: 1px solid #ef4444 !important; }
.status_checking { background: #4d3a0e !important; color: #facc15 !important; border: 1px solid #eab308 !important; }

/* 标签页导航 */
.tab_btn_bar {
    margin-top: 15px;
    white-space: nowrap !important;
    overflow: hidden;
}
.tab_btn {
    padding: 7px 18px !important;
    margin-right: 4px !important;
    background: #1f2528 !important;
    border: 1px solid #434d52 !important;
    border-bottom: none !important;
    color: #a0aeb5 !important;
    cursor: pointer !important;
    border-radius: 4px 4px 0 0 !important;
    font-size: 13px !important;
    display: inline-block !important;
    white-space: nowrap !important;
    vertical-align: bottom !important;
}
.tab_btn_active {
    background: #2b353a !important;
    color: #00ffe4 !important;
    border-color: #00ffe4 !important;
    font-weight: bold !important;
}
.tab_container {
    border: 1px solid #434d52;
    background: #2b353a;
    padding: 12px;
    border-radius: 0 4px 4px 4px;
}

/* 终端输出框 */
.cli_terminal {
    width: 98% !important;
    height: 320px !important;
    background: #0c1012 !important;
    color: #38ef7d !important;
    font-family: 'Consolas', 'Courier New', monospace !important;
    font-size: 12px !important;
    line-height: 18px !important;
    border: 1px solid #1f2d33 !important;
    padding: 8px !important;
    border-radius: 4px !important;
    resize: vertical !important;
    outline: none !important;
    box-sizing: border-box !important;
}

/* 单行输入框 */
.input_text {
    background: #181f22 !important;
    border: 1px solid #445258 !important;
    color: #fff !important;
    padding: 4px 8px !important;
    border-radius: 3px !important;
    font-family: 'Consolas', monospace !important;
    box-sizing: border-box !important;
    vertical-align: middle !important;
}
.input_text:focus { border-color: #00ffe4 !important; outline: none !important; }
.inline_tip { color: #a0aeb5; margin-left: 8px; font-size: 12px; vertical-align: middle; white-space: nowrap; }
.inline_warn { color: #FC0; margin-left: 8px; font-size: 12px; vertical-align: middle; white-space: nowrap; }
.inline_highlight { color: #00ffe4; margin-left: 8px; font-size: 12px; vertical-align: middle; white-space: nowrap; }
</style>
<script type="text/javascript">
var dbus = {};
var refresh_flag = 0;
var count_down;
var current_tab = 1;

function init() {
    show_menu(menu_hook);
    register_event();
    get_dbus_data();
    check_status();
}

function menu_hook(title, tab) {
    tabtitle[tabtitle.length - 1] = new Array("", "EasyTier");
    tablink[tablink.length - 1] = new Array("", "Module_easytier.asp");
}

function register_event() {
    $(".popup_bar_bg_ks").click(function() { count_down = -1; });
    $(window).resize(function(){
        if($('.popup_bar_bg_ks').css("visibility") == "visible"){
            var log_h_offset = ((window.innerHeight || document.documentElement.clientHeight) - E("loadingBarBlock").clientHeight) / 2;
            var log_w_offset = ((window.innerWidth || document.documentElement.clientWidth) - E("loadingBarBlock").clientWidth) / 2 + 90;
            $('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
        }
    });
}

function get_dbus_data() {
    $.ajax({
        type: "GET",
        url: "/_api/easytier_",
        dataType: "json",
        async: false,
        success: function(data) {
            dbus = (data && data.result && data.result[0]) ? data.result[0] : {};
            conf2obj();
        },
        error: function() { conf2obj(); }
    });
}

function conf2obj() {
    // 双版本号展示 (插件版本与官方核心版本)
    var pVer = dbus["easytier_plugin_version"] || "1.1.0";
    var cVer = dbus["easytier_core_version"] || dbus["easytier_version"] || "2.6.4";
    if (E("easytier_plugin_ver")) E("easytier_plugin_ver").innerHTML = "v" + pVer;
    if (E("easytier_core_ver")) E("easytier_core_ver").innerHTML = "(Core v" + cVer + ")";

    // 基本开关
    E("easytier_enable").checked = (dbus["easytier_enable"] === "1");
    E("easytier_autostart").checked = (dbus["easytier_autostart"] !== "0");
    E("easytier_watchdog").checked = (dbus["easytier_watchdog"] !== "0");
    E("easytier_watchdog_val").value = dbus["easytier_watchdog_val"] || dbus["easytier_watchdog_interval"] || "5";
    E("easytier_watchdog_unit").value = dbus["easytier_watchdog_unit"] || "min";

    // 模式与 Tab 对应
    var mode = dbus["easytier_mode"] || "simple";
    current_tab = (mode === "custom") ? 2 : 1;
    $(".tab_btn").removeClass("tab_btn_active");
    $("#tab_btn_" + current_tab).addClass("tab_btn_active");
    $(".tab_page").hide();
    $("#tab_page_" + current_tab).show();

    // 简易模式参数
    if (dbus["easytier_node_name"]) E("easytier_node_name").value = dbus["easytier_node_name"];
    if (dbus["easytier_network_name"]) E("easytier_network_name").value = dbus["easytier_network_name"];
    if (dbus["easytier_network_secret"]) E("easytier_network_secret").value = dbus["easytier_network_secret"];
    
    // IP 与 DHCP
    var isDhcp = (dbus["easytier_dhcp"] === "1" || !dbus["easytier_ipv4"]);
    E("easytier_dhcp").checked = isDhcp;
    E("easytier_ipv4").value = dbus["easytier_ipv4"] || "";
    toggle_dhcp(isDhcp);

    // 监听端口
    E("easytier_port").value = dbus["easytier_port"] || "11010";

    // 局域网子网代理
    if (dbus["easytier_proxy_network"]) {
        E("easytier_proxy_network").value = dbus["easytier_proxy_network"];
    } else {
        // 自动探测 LAN 网段
        var lanIp = '<% nvram_get("lan_ipaddr"); %>' || '192.168.50.1';
        var parts = lanIp.split('.');
        if (parts.length === 4) {
            E("easytier_proxy_network").value = parts[0] + '.' + parts[1] + '.' + parts[2] + '.0/24';
        }
    }

    // 对端子网接收策略与白名单
    var routeMode = dbus["easytier_route_mode"] || (dbus["easytier_accept_routes"] === "0" ? "none" : "all");
    E("easytier_route_mode").value = routeMode;
    toggle_route_mode(routeMode);

    if (dbus["easytier_route_whitelist_encoded"]) {
        try {
            E("easytier_route_whitelist").value = decodeURIComponent(escape(atob(dbus["easytier_route_whitelist_encoded"])));
        } catch(e) {
            E("easytier_route_whitelist").value = dbus["easytier_route_whitelist"] || "";
        }
    } else {
        E("easytier_route_whitelist").value = dbus["easytier_route_whitelist"] || "";
    }

    // 对端节点列表
    if (dbus["easytier_peers_encoded"]) {
        try {
            E("easytier_peers").value = decodeURIComponent(escape(atob(dbus["easytier_peers_encoded"])));
        } catch(e) {
            E("easytier_peers").value = dbus["easytier_peers"] || "tcp://public.easytier.top:11010";
        }
    } else if (dbus["easytier_peers"]) {
        E("easytier_peers").value = dbus["easytier_peers"];
    } else {
        E("easytier_peers").value = "tcp://public.easytier.top:11010";
    }

    // 高级 TOML 配置内容
    if (dbus["easytier_config_content_encoded"]) {
        try {
            E("easytier_config_content").value = decodeURIComponent(escape(atob(dbus["easytier_config_content_encoded"])));
        } catch(e) {
            E("easytier_config_content").value = dbus["easytier_config_content"] || "";
        }
    } else if (dbus["easytier_config_content"]) {
        E("easytier_config_content").value = dbus["easytier_config_content"];
    }
}

function toggle_route_mode(mode) {
    if (mode === "whitelist") {
        $("#route_whitelist_tr").show();
    } else {
        $("#route_whitelist_tr").hide();
    }
}

function on_route_mode_change() {
    var mode = E("easytier_route_mode").value;
    toggle_route_mode(mode);
}

function toggle_dhcp(checked) {
    E("easytier_ipv4").disabled = checked;
    if (checked) {
        $("#ipv4_tip").text("(DHCP模式: 自动由组网分配可用IP)");
    } else {
        $("#ipv4_tip").text("(静态IP模式: 请填写如 10.144.144.1/24)");
    }
}

function check_status() {
    var postData = {"id": parseInt(Math.random() * 100000000), "method": "easytier_config.sh", "params": ['status'], "fields": ""};
    $.ajax({
        type: "POST",
        url: "/_api/",
        data: JSON.stringify(postData),
        dataType: "json",
        timeout: 4000,
        success: function(response) {
            var text = (response && response.result) ? response.result : "停止";
            var badge = E("easytier_status_badge");
            if (text.indexOf("运行中") !== -1) {
                badge.className = "status_badge status_running";
                badge.innerHTML = "● " + text;
                E("btn_start").style.display = "none";
                E("btn_stop").style.display = "inline-block";
                E("btn_restart").style.display = "inline-block";
            } else {
                badge.className = "status_badge status_stopped";
                badge.innerHTML = "○ 服务已停止";
                E("btn_start").style.display = "inline-block";
                E("btn_stop").style.display = "none";
                E("btn_restart").style.display = "none";
            }
            setTimeout(check_status, 10000);
        },
        error: function() {
            var badge = E("easytier_status_badge");
            badge.className = "status_badge status_stopped";
            badge.innerHTML = "○ 状态未就绪";
            setTimeout(check_status, 8000);
        }
    });
}

function switch_tab(tabIndex) {
    var prevTab = current_tab;
    current_tab = tabIndex;
    $(".tab_btn").removeClass("tab_btn_active");
    $("#tab_btn_" + tabIndex).addClass("tab_btn_active");
    $(".tab_page").hide();
    $("#tab_page_" + tabIndex).show();

    if (tabIndex === 2) {
        if (prevTab === 1 || !E("easytier_config_content").value.trim()) {
            // 从基本配置切换到高级 TOML 配置时，自动从简易向导生成 TOML 写入到框中
            generate_toml_from_simple(true);
        }
    } else if (tabIndex === 3) {
        fetch_cli_info('peer');
    } else if (tabIndex === 4) {
        fetch_runtime_log();
    }
}

function get_form_fields() {
    var data = {};
    data["easytier_enable"] = E("easytier_enable").checked ? "1" : "0";
    data["easytier_autostart"] = E("easytier_autostart").checked ? "1" : "0";
    data["easytier_watchdog"] = E("easytier_watchdog").checked ? "1" : "0";
    data["easytier_watchdog_val"] = E("easytier_watchdog_val").value.trim() || "5";
    data["easytier_watchdog_unit"] = E("easytier_watchdog_unit").value || "min";

    var mode = (current_tab === 2) ? "custom" : "simple";
    data["easytier_mode"] = mode;

    data["easytier_node_name"] = E("easytier_node_name").value.trim();
    data["easytier_network_name"] = E("easytier_network_name").value.trim();
    data["easytier_network_secret"] = E("easytier_network_secret").value.trim();
    data["easytier_dhcp"] = E("easytier_dhcp").checked ? "1" : "0";
    data["easytier_ipv4"] = E("easytier_ipv4").value.trim();
    data["easytier_port"] = E("easytier_port").value.trim() || "11010";
    data["easytier_proxy_network"] = E("easytier_proxy_network").value.trim();
    var routeMode = E("easytier_route_mode").value;
    data["easytier_route_mode"] = routeMode;
    var rWhitelist = E("easytier_route_whitelist").value.trim();
    data["easytier_route_whitelist"] = rWhitelist;
    try {
        data["easytier_route_whitelist_encoded"] = btoa(unescape(encodeURIComponent(rWhitelist)));
    } catch(e) {}
    data["easytier_accept_routes"] = (routeMode === "all") ? "1" : "0";
    
    var peers = E("easytier_peers").value.trim();
    data["easytier_peers"] = peers;
    try {
        data["easytier_peers_encoded"] = btoa(unescape(encodeURIComponent(peers)));
    } catch(e) {}

    var tomlContent = E("easytier_config_content").value.trim();
    if (mode === "custom" && !tomlContent) {
        alert("高级模式下，配置文件内容不能为空！");
        return null;
    }
    data["easytier_config_content"] = tomlContent;
    try {
        data["easytier_config_content_encoded"] = btoa(unescape(encodeURIComponent(tomlContent)));
    } catch(e) {}

    return data;
}

var is_submitting = false;

function set_btn_state(disabled) {
    $("#btn_apply, #btn_start, #btn_stop, #btn_restart").prop("disabled", disabled);
    if (disabled) {
        $("#btn_apply, #btn_start, #btn_stop, #btn_restart").css("opacity", "0.6");
    } else {
        $("#btn_apply, #btn_start, #btn_stop, #btn_restart").css("opacity", "1.0");
    }
}

function save_and_apply(action) {
    if (is_submitting) return;
    var fields = get_form_fields();
    if (!fields) return;

    if (!action) {
        action = fields["easytier_enable"] === "1" ? "restart" : "stop";
    }

    is_submitting = true;
    set_btn_state(true);

    var postData = {
        "id": parseInt(Math.random() * 100000000),
        "method": "easytier_config.sh",
        "params": [action, "web_submit"],
        "fields": fields
    };

    $.ajax({
        type: "POST",
        url: "/_api/",
        data: JSON.stringify(postData),
        dataType: "json",
        timeout: 10000,
        success: function() {
            get_log(0);
        },
        error: function() {
            is_submitting = false;
            set_btn_state(false);
            alert("请求提交失败或超时！");
        }
    });
}

function service_action(action) {
    if (is_submitting) return;
    var fields = get_form_fields();
    if (!fields) return;

    is_submitting = true;
    set_btn_state(true);

    var postData = {
        "id": parseInt(Math.random() * 100000000),
        "method": "easytier_config.sh",
        "params": [action, "web_submit"],
        "fields": fields
    };
    $.ajax({
        type: "POST",
        url: "/_api/",
        data: JSON.stringify(postData),
        dataType: "json",
        timeout: 10000,
        success: function() {
            get_log(0);
        },
        error: function() {
            is_submitting = false;
            set_btn_state(false);
            alert("执行操作失败！");
        }
    });
}

function generate_toml_from_simple(silent) {
    var node = E("easytier_node_name").value.trim() || "ROG-GS7";
    var netName = E("easytier_network_name").value.trim() || "default_net";
    var secret = E("easytier_network_secret").value.trim();
    var port = E("easytier_port").value.trim() || "11010";
    var isDhcp = E("easytier_dhcp").checked;
    var ipv4 = E("easytier_ipv4").value.trim();
    var proxyNet = E("easytier_proxy_network").value.trim();
    var routeMode = E("easytier_route_mode").value;
    var rWhitelist = E("easytier_route_whitelist").value.trim();
    var peers = E("easytier_peers").value.trim().split("\n");

    var toml = "# ==========================================\n";
    toml += "# EasyTier 配置文件 (由 KoolCenter 自动生成)\n";
    toml += "# ==========================================\n";
    toml += 'instance_name = "' + node + '"\n';
    toml += 'hostname = "' + node + '"\n\n';

    if (routeMode === "none") {
        toml += "# 声明手动路由为空，禁用接收对端子网路由，避免上级网络冲突\n";
        toml += "routes = []\n\n";
    } else if (routeMode === "whitelist") {
        toml += "# 对端子网白名单路由\nroutes = [\n";
        var rArr = rWhitelist.split(/[\n,;]+/);
        for (var i = 0; i < rArr.length; i++) {
            var r = rArr[i].trim();
            if (r && r.indexOf("#") !== 0) {
                toml += '    "' + r + '",\n';
            }
        }
        toml += "]\n\n";
    }

    if (isDhcp || !ipv4) {
        toml += "dhcp = true\n";
    } else {
        toml += "dhcp = false\n";
        toml += 'ipv4 = "' + ipv4 + '"\n';
    }

    toml += "\n[network_identity]\n";
    toml += 'network_name = "' + netName + '"\n';
    toml += 'network_secret = "' + secret + '"\n\n';

    toml += "listeners = [\n";
    toml += '    "tcp://0.0.0.0:' + port + '",\n';
    toml += '    "udp://0.0.0.0:' + port + '"\n';
    toml += "]\n\n";

    for (var i = 0; i < peers.length; i++) {
        var p = peers[i].trim();
        if (p && p.indexOf("#") !== 0) {
            toml += "[[peer]]\n";
            toml += 'uri = "' + p + '"\n\n';
        }
    }

    if (proxyNet) {
        toml += "# 局域网子网代理 (打通家中内网)\n";
        toml += "[[proxy_network]]\n";
        toml += 'cidr = "' + proxyNet + '"\n';
    }

    E("easytier_config_content").value = toml;
    if (!silent) {
        alert("已将当前简易向导参数转换为 TOML 配置！您可以自由编辑与深度定制。");
    }
}

function clear_toml_content() {
    if (confirm("确定要清空 TOML 配置文件内容吗？")) {
        E("easytier_config_content").value = "";
    }
}

function fetch_cli_info(type) {
    E("cli_terminal_output").value = "正在从 EasyTier 节点查询 " + type + " 实时状态，请稍候...";
    var postData = {"id": parseInt(Math.random() * 100000000), "method": "easytier_config.sh", "params": ['get_' + type + 's'], "fields": ""};
    $.ajax({
        type: "POST",
        url: "/_api/",
        data: JSON.stringify(postData),
        dataType: "json",
        timeout: 6000,
        success: function() {
            setTimeout(function() {
                $.ajax({
                    url: '/_temp/easytier_' + type + '_info.txt',
                    type: 'GET',
                    cache: false,
                    dataType: 'text',
                    success: function(resp) {
                        E("cli_terminal_output").value = resp || "无返回信息 (服务可能未启动或对端未连接)";
                    },
                    error: function() {
                        E("cli_terminal_output").value = "暂未获取到状态信息，请确保服务已启动。";
                    }
                });
            }, 500);
        },
        error: function() {
            E("cli_terminal_output").value = "查询请求超时，请检查服务状态。";
        }
    });
}

function fetch_runtime_log() {
    $.ajax({
        url: '/_temp/easytier_runtime.log',
        type: 'GET',
        cache: false,
        dataType: 'text',
        success: function(resp) {
            var area = E("runtime_log_area");
            area.value = resp || "运行日志为空";
            area.scrollTop = area.scrollHeight;
        },
        error: function() {
            E("runtime_log_area").value = "暂未产生运行日志或服务尚未运行。";
        }
    });
}

function clear_runtime_log() {
    if (confirm("确定要清空 EasyTier 运行日志吗？")) {
        var postData = {"id": parseInt(Math.random() * 100000000), "method": "easytier_config.sh", "params": ["clear_runtime_log", "web_submit"], "fields": {}};
        $.ajax({
            type: "POST", url: "/_api/", data: JSON.stringify(postData), dataType: "json", timeout: 6000,
            success: function() {
                E("runtime_log_area").value = "运行日志已清空！";
            }
        });
    }
}

function toggle_secret_visibility() {
    var input = E("easytier_network_secret");
    input.type = (input.type === "password") ? "text" : "password";
}

// KoolCenter 弹窗进度与日志
function get_log(action) {
    E("ok_button").style.visibility = "hidden";
    showWBLoadingBar();
    $.ajax({
        url: '/_temp/easytier_log.txt',
        type: 'GET',
        cache: false,
        dataType: 'text',
        success: function(response) {
            var retArea = E("log_content");
            if (response.indexOf("XU6J03M6") !== -1) {
                retArea.value = response.replace(/XU6J03M6/g, " ");
                E("ok_button").style.visibility = "visible";
                retArea.scrollTop = retArea.scrollHeight;
                if (action == 1) { count_down = -1; refresh_flag = 0; } else { count_down = 4; refresh_flag = 1; }
                count_down_close();
                setTimeout(function(){ check_status(); get_dbus_data(); }, 1000);
                return false;
            }
            setTimeout(function(){ get_log(action); }, 300);
            retArea.value = response.replace(/XU6J03M6/g, " ");
            retArea.scrollTop = retArea.scrollHeight;
        },
        error: function() {
            E("loading_block_title").innerHTML = "暂无日志信息 ...";
            E("log_content").value = "等待执行中...";
        }
    });
}

function showWBLoadingBar() {
    document.scrollingElement.scrollTop = 0;
    E("loading_block_title").innerHTML = "&nbsp;&nbsp;EasyTier 任务执行日志";
    E("LoadingBar").style.visibility = "visible";
    var log_h_offset = ((window.innerHeight || document.documentElement.clientHeight) - E("loadingBarBlock").clientHeight) / 2;
    var log_w_offset = ((window.innerWidth || document.documentElement.clientWidth) - E("loadingBarBlock").clientWidth) / 2 + 90;
    $('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}

function hideWBLoadingBar() {
    is_submitting = false;
    set_btn_state(false);
    E("LoadingBar").style.visibility = "hidden";
    E("ok_button").style.visibility = "hidden";
    if (refresh_flag == 1) refreshpage();
}

function count_down_close() {
    if (count_down === 0) { hideWBLoadingBar(); return; }
    if (count_down < 0) { E("ok_button1").value = "手动关闭"; return; }
    E("ok_button1").value = "自动关闭 (" + count_down + ")";
    --count_down;
    setTimeout(count_down_close, 1000);
}
</script>
</head>
<body id="app" skin='<% nvram_get("sc_skin"); %>' onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    
    <!-- 日志弹窗 -->
    <div id="LoadingBar" class="popup_bar_bg_ks">
        <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
            <tr>
                <td height="100">
                    <div id="loading_block_title" style="margin:10px auto 10px 10px; width:85%; font-size:13pt; font-weight:bold; color:#00ffe4;"></div>
                    <div id="loading_block_spilt" style="margin:5px 0 10px 10px; font-size:12px; color:#ffcc00;">
                        <span>● 请等待脚本操作完成并输出终止指令，期间请勿刷新页面。</span>
                    </div>
                    <div style="margin: 0 15px 10px 15px; border: 1px solid #1f2d33; border-radius: 4px; overflow:hidden">
                        <textarea cols="50" rows="22" wrap="off" readonly="readonly" id="log_content" style="border:none; width:99%; font-family:'Consolas','Lucida Console',monospace; font-size:11px; background:#0c1012; color:#38ef7d; outline:none; padding:8px; line-height:16px;"></textarea>
                    </div>
                    <div id="ok_button" class="apply_gen" style="background:#14181c; visibility:hidden; padding-bottom:10px;">
                        <input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <table class="content" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="17">&nbsp;</td>
            <td valign="top" width="202">
                <div id="mainMenu"></div>
                <div id="subMenu"></div>
            </td>
            <td valign="top">
                <div id="tabMenu" class="submenuBlock"></div>
                <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="top">
                            <table width="760px" border="0" cellpadding="5" cellspacing="0" class="FormTitle" id="FormTitle">
                                <tr>
                                    <td bgcolor="#4D595D" colspan="3" valign="top">
                                        <div>&nbsp;</div>
                                        <div class="formfonttitle">
                                            EasyTier 
                                            <span id="easytier_plugin_ver" style="font-size:13px; color:#00ffe4; font-weight:normal; margin-left:8px;">v1.1.0</span>
                                            <span id="easytier_core_ver" style="font-size:12px; color:#a0aeb5; font-weight:normal; margin-left:6px;">(Core v2.6.4)</span>
                                            <span style="font-size:12px; color:#62727b; font-weight:normal; margin-left:10px;">去中心化 Mesh VPN 异地组网工具</span>
                                        </div>
                                        <div style="float: right; width: 15px; height: 25px; margin-top: -24px">
                                            <img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
                                        </div>
                                        <div style="margin: 10px 0 12px 5px;" class="splitLine"></div>

                                        <!-- 顶部链接栏: 单行紧凑显示 -->
                                        <div class="SimpleNote">
                                            <span style="margin-right:12px;"><a href="https://github.com/EasyTier/EasyTier" target="_blank"><em>EasyTier</em></a> 是基于 Rust 打造的安全去中心化 Full-Mesh 组网方案。</span>
                                            <a href="https://github.com/EasyTier/EasyTier" target="_blank" class="et_btn">项目官网 ↗</a>
                                            <a href="javascript:void(0);" onclick="get_log(1)" class="et_btn">插件日志</a>
                                            <a href="javascript:void(0);" onclick="clear_runtime_log()" class="et_btn et_btn_danger">清空运行日志</a>
                                        </div>

                                        <!-- 状态面板: 单行紧凑展示 -->
                                        <div style="margin-bottom: 12px;">
                                            <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                <thead><tr><td colspan="2">EasyTier - 服务运行状态</td></tr></thead>
                                                <tr>
                                                    <th>运行状态</th>
                                                    <td>
                                                        <span id="easytier_status_badge" class="status_badge status_checking">检测中...</span>
                                                        <span style="float:right; margin-right:8px; white-space:nowrap;">
                                                            <button type="button" class="et_btn et_btn_primary" id="btn_start" onClick="service_action('start')" style="display:none;">▶ 启动服务</button>
                                                            <button type="button" class="et_btn et_btn_danger" id="btn_stop" onClick="service_action('stop')" style="display:none;">■ 停止服务</button>
                                                            <button type="button" class="et_btn" id="btn_restart" onClick="service_action('restart')" style="display:none;">↻ 重启服务</button>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Tab 标签按钮组: 强制单行显示 -->
                                        <div class="tab_btn_bar">
                                            <div id="tab_btn_1" class="tab_btn tab_btn_active" onclick="switch_tab(1)">⚙️ 基本配置</div>
                                            <div id="tab_btn_2" class="tab_btn" onclick="switch_tab(2)">📝 高级 TOML 配置</div>
                                            <div id="tab_btn_3" class="tab_btn" onclick="switch_tab(3)">🌐 节点与对端状态 (CLI)</div>
                                            <div id="tab_btn_4" class="tab_btn" onclick="switch_tab(4)">📜 运行输出日志</div>
                                        </div>

                                        <!-- Tab 容器 -->
                                        <div class="tab_container">

                                            <!-- 页面 1: 基本配置 -->
                                            <div id="tab_page_1" class="tab_page">
                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                    <thead><tr><td colspan="2">开关与模式设置</td></tr></thead>
                                                    <tr>
                                                        <th>开启 EasyTier</th>
                                                        <td>
                                                            <input type="checkbox" id="easytier_enable" style="vertical-align:middle;">
                                                            <span style="color:#00ffe4; margin-left:6px; font-weight:bold; vertical-align:middle;">启用 EasyTier 服务</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>开机自启</th>
                                                        <td>
                                                            <input type="checkbox" id="easytier_autostart" style="vertical-align:middle;">
                                                            <span style="color:#a0aeb5; margin-left:6px; vertical-align:middle;">路由器重启后自动拉起 EasyTier 服务</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>看门狗进程守护</th>
                                                        <td>
                                                            <input type="checkbox" id="easytier_watchdog" style="vertical-align:middle;">
                                                            <span style="color:#a0aeb5; margin-left:6px; vertical-align:middle;">异常退出时自动拉起，检测间隔: 每</span>
                                                            <input type="text" id="easytier_watchdog_val" class="input_text" style="width:45px; text-align:center; margin:0 4px; vertical-align:middle;" value="5" />
                                                            <select id="easytier_watchdog_unit" class="input_text" style="width:65px; vertical-align:middle;">
                                                                <option value="min" selected>分钟</option>
                                                                <option value="hour">小时</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                </table>

                                                <!-- 简易向导模式分组: 各表单字段均单行显示 -->
                                                <div id="simple_settings_group" style="margin-top:10px;">
                                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                        <thead><tr><td colspan="2">EasyTier 简易组网参数</td></tr></thead>
                                                        <tr>
                                                            <th>节点名称 (Hostname)</th>
                                                            <td>
                                                                <input type="text" id="easytier_node_name" class="input_text" style="width:200px;" value="ROG-GS7" />
                                                                <span class="inline_tip">本设备在虚拟组网中展示的主机名</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>组网网络名称</th>
                                                            <td>
                                                                <input type="text" id="easytier_network_name" class="input_text" style="width:200px;" placeholder="例如: my_home_net" />
                                                                <span class="inline_warn">* 加入同一网络的设备必须完全一致</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>组网通信密钥</th>
                                                            <td>
                                                                <input type="password" id="easytier_network_secret" class="input_text" style="width:200px;" placeholder="建议设置强口令" />
                                                                <button type="button" class="et_btn" onclick="toggle_secret_visibility();" style="margin-left:6px;">👁️ 显示/隐藏</button>
                                                                <span class="inline_warn">* 组网认证口令</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>虚拟 IPv4 地址</th>
                                                            <td>
                                                                <input type="text" id="easytier_ipv4" class="input_text" style="width:160px;" placeholder="例如: 10.144.144.1" />
                                                                <label style="cursor:pointer; margin-left:10px; vertical-align:middle;">
                                                                    <input type="checkbox" id="easytier_dhcp" onchange="toggle_dhcp(this.checked);" checked style="vertical-align:middle;">
                                                                    <b style="vertical-align:middle;">启用 DHCP 自动分配</b>
                                                                </label>
                                                                <span id="ipv4_tip" class="inline_tip">(自动由组网分配可用IP)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>局域网网段代理 (子网转发)</th>
                                                            <td>
                                                                <input type="text" id="easytier_proxy_network" class="input_text" style="width:180px;" placeholder="例如: 192.168.50.0/24" />
                                                                <span class="inline_tip">广播本机内网网段供异地设备直连访问</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>对端子网接收策略</th>
                                                            <td>
                                                                <select id="easytier_route_mode" class="input_text" onchange="on_route_mode_change();" style="width:260px; vertical-align:middle;">
                                                                    <option value="all">自动接收全部对端子网 (默认)</option>
                                                                    <option value="whitelist">白名单模式 (仅允许指定子网，推荐)</option>
                                                                    <option value="none">全部拒收 (仅对外广播本路由内网)</option>
                                                                </select>
                                                                <span class="inline_tip">控制是否学习并写入其他节点广播的子网路由</span>
                                                            </td>
                                                        </tr>
                                                        <tr id="route_whitelist_tr" style="display:none;">
                                                            <th style="vertical-align:top; padding-top:10px;">子网白名单 (Routes)</th>
                                                            <td style="white-space:normal;">
                                                                <textarea id="easytier_route_whitelist" style="width:98%; height:60px; font-family:'Consolas',monospace; font-size:12px; line-height:16px;" class="input_text" placeholder="例如: 172.16.0.0/16&#10;10.3.0.0/16"></textarea>
                                                                <div style="color:#a0aeb5; margin-top:4px; font-size:11px;">
                                                                    仅学习并写入上方指定的远端子网（每行一个），未指定的远端子网将被丢弃以避免网关冲突。
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>监听端口</th>
                                                            <td>
                                                                <input type="text" id="easytier_port" class="input_text" style="width:100px;" value="11010" />
                                                                <span class="inline_tip">本地 TCP/UDP 外部通信端口 (默认 11010)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th style="vertical-align:top; padding-top:10px;">对端节点 (Peers)</th>
                                                            <td style="white-space:normal;">
                                                                <textarea id="easytier_peers" style="width:98%; height:75px; font-family:'Consolas',monospace; font-size:12px; line-height:16px;" class="input_text" placeholder="tcp://public.easytier.top:11010"></textarea>
                                                                <div style="color:#a0aeb5; margin-top:4px; font-size:11px;">
                                                                    公共中继节点或私有对端地址 (每行一个)，例如: <code>tcp://public.easytier.top:11010</code> 或 <code>udp://223.5.5.5:11010</code>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>

                                            <!-- 页面 2: 高级 TOML 配置 (完全单行按钮，不换行，不截断) -->
                                            <div id="tab_page_2" class="tab_page" style="display:none;">
                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                    <thead><tr><td colspan="2">EasyTier 完整 TOML 配置文件</td></tr></thead>
                                                    <tr>
                                                        <th style="vertical-align:top; padding-top:10px;">TOML 配置文件内容</th>
                                                        <td style="white-space:normal;">
                                                            <!-- 单行按钮工具栏 -->
                                                            <div class="btn_toolbar">
                                                                <button type="button" class="et_btn et_btn_primary" onclick="generate_toml_from_simple()">⚡ 从简易向导生成 TOML</button>
                                                                <button type="button" class="et_btn et_btn_danger" onclick="clear_toml_content()">🗑️ 清空内容</button>
                                                            </div>
                                                            <textarea id="easytier_config_content" style="width: 98%; height: 380px; font-family:'Consolas','Courier New',monospace; font-size:12px; line-height:17px;" class="input_text" spellcheck="false" placeholder="# 请在此粘贴完整的 EasyTier TOML 配置文件..."></textarea>
                                                            <div style="margin-top:6px; color:#a0aeb5; font-size:11px;">
                                                                支持 EasyTier 全功能参数（多协议监听、WireGuard 协议监听、多子网路由、数据压缩、AES-GCM 加密等）。
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>

                                            <!-- 页面 3: 节点与对端状态 (CLI) (单行按钮) -->
                                            <div id="tab_page_3" class="tab_page" style="display:none;">
                                                <div class="btn_toolbar">
                                                    <button type="button" class="et_btn" onclick="fetch_cli_info('peer')">👥 对端节点 (peer)</button>
                                                    <button type="button" class="et_btn" onclick="fetch_cli_info('node')">💻 本机状态 (node)</button>
                                                    <button type="button" class="et_btn" onclick="fetch_cli_info('route')">🗺️ 路由与子网 (route)</button>
                                                </div>
                                                <textarea id="cli_terminal_output" class="cli_terminal" readonly="readonly" placeholder="点击上方按钮即可查询节点与网络拓扑实时状态..."></textarea>
                                                <div style="color:#a0aeb5; font-size:11px; margin-top:6px;">
                                                    提示: 对端状态展示包含延迟 (Latency)、丢包率 (Loss Rate)、直连/中继模式以及流量统计。
                                                </div>
                                            </div>

                                            <!-- 页面 4: 运行输出日志 (单行按钮) -->
                                            <div id="tab_page_4" class="tab_page" style="display:none;">
                                                <div class="btn_toolbar">
                                                    <button type="button" class="et_btn" onclick="fetch_runtime_log()">🔄 刷新运行日志</button>
                                                    <button type="button" class="et_btn et_btn_danger" onclick="clear_runtime_log()">🗑️ 清空运行日志</button>
                                                </div>
                                                <textarea id="runtime_log_area" class="cli_terminal" style="height:360px;" readonly="readonly" placeholder="暂无运行日志..."></textarea>
                                            </div>

                                        </div>

                                        <!-- 底部操作按钮 -->
                                        <div class="apply_gen" style="margin-top:16px;">
                                            <input class="button_gen" id="btn_apply" onClick="save_and_apply()" type="button" value="保存并应用" style="font-size:14px; height:33px; width:130px;" />
                                        </div>

                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <div id="footer"></div>
</body>
</html>
