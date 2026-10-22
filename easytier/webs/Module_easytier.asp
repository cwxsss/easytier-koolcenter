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
.SimpleNote { padding: 6px 10px; line-height: 22px; background: rgba(0,0,0,0.25); border-radius: 4px; margin-bottom: 12px; }
.SimpleNote a { color: #00ffe4; text-decoration: none; }
.SimpleNote a:hover { text-decoration: underline; }
i { color: #FC0; font-style: normal; }
.loadingBarBlock { width: 750px; }
.popup_bar_bg_ks { position: fixed; margin: auto; top: 0; left: 0; width: 100%; height: 100%; z-index: 999; filter: alpha(opacity=90); visibility: hidden; background: rgba(20, 24, 28, 0.88); }
.FormTitle em { color: #00ffe4; font-style: normal; }
.FormTable th { width: 28%; font-size: 13px; font-weight: normal; }
.FormTable td { font-size: 13px; }
.formfonttitle { font-family: Roboto-Light, "Microsoft JhengHei"; font-size: 18px; margin-left: 5px; font-weight: bold; }
.FormTitle, .FormTable th, .FormTable td { font-family: Roboto-Light, "Microsoft JhengHei"; }
.ks_btn { padding: 3px 10px; background: #2f3a3d; border: 1px solid #5a6a6f; color: #fff; border-radius: 3px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 12px; }
.ks_btn:hover { background: #3f4e53; color: #00ffe4; border-color: #00ffe4; }
.ks_btn_danger { background: #5c1e24; border-color: #8c2b34; }
.ks_btn_danger:hover { background: #7c2830; color: #ff8080; border-color: #ff4d4d; }
.status_badge { display: inline-block; padding: 4px 12px; border-radius: 3px; font-weight: bold; font-size: 13px; letter-spacing: 0.5px; }
.status_running { background: #164e32; color: #4ade80; border: 1px solid #22c55e; }
.status_stopped { background: #4c1d24; color: #f87171; border: 1px solid #ef4444; }
.tab_btn { padding: 6px 16px; margin-right: 4px; background: #1f2528; border: 1px solid #434d52; border-bottom: none; color: #a0aeb5; cursor: pointer; border-radius: 4px 4px 0 0; font-size: 13px; display: inline-block; }
.tab_btn_active { background: #2b353a; color: #00ffe4; border-color: #00ffe4; font-weight: bold; }
.tab_container { border: 1px solid #434d52; background: #2b353a; padding: 12px; border-radius: 0 4px 4px 4px; }
.cli_terminal { width: 98%; height: 280px; background: #0c1012; color: #38ef7d; font-family: 'Consolas', 'Courier New', monospace; font-size: 12px; line-height: 18px; border: 1px solid #1f2d33; padding: 8px; border-radius: 4px; resize: vertical; outline: none; }
.input_text { background: #181f22; border: 1px solid #445258; color: #fff; padding: 4px 8px; border-radius: 3px; font-family: 'Consolas', monospace; }
.input_text:focus { border-color: #00ffe4; outline: none; }
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
    if (dbus["easytier_version"]) {
        E("easytier_version").innerHTML = "v" + dbus["easytier_version"];
    }

    // 基本开关
    E("easytier_enable").checked = (dbus["easytier_enable"] === "1");
    E("easytier_autostart").checked = (dbus["easytier_autostart"] !== "0");

    // 模式
    var mode = dbus["easytier_mode"] || "simple";
    if (mode === "custom") {
        E("mode_custom").checked = true;
    } else {
        E("mode_simple").checked = true;
    }
    toggle_mode_display(mode);

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

function toggle_mode_display(mode) {
    if (mode === "custom") {
        $("#simple_settings_group").hide();
        $("#custom_settings_group").show();
    } else {
        $("#simple_settings_group").show();
        $("#custom_settings_group").hide();
    }
}

function on_mode_change() {
    var mode = $("input[name='easytier_mode']:checked").val();
    toggle_mode_display(mode);
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
                E("btn_stop").style.display = "";
                E("btn_restart").style.display = "";
            } else {
                badge.className = "status_badge status_stopped";
                badge.innerHTML = "○ 服务已停止";
                E("btn_start").style.display = "";
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
    current_tab = tabIndex;
    $(".tab_btn").removeClass("tab_btn_active");
    $("#tab_btn_" + tabIndex).addClass("tab_btn_active");
    $(".tab_page").hide();
    $("#tab_page_" + tabIndex).show();

    if (tabIndex === 3) {
        fetch_cli_info('peer');
    } else if (tabIndex === 4) {
        fetch_runtime_log();
    }
}

function get_form_fields() {
    var data = {};
    data["easytier_enable"] = E("easytier_enable").checked ? "1" : "0";
    data["easytier_autostart"] = E("easytier_autostart").checked ? "1" : "0";
    var mode = $("input[name='easytier_mode']:checked").val() || "simple";
    data["easytier_mode"] = mode;

    if (mode === "simple") {
        data["easytier_node_name"] = E("easytier_node_name").value.trim();
        data["easytier_network_name"] = E("easytier_network_name").value.trim();
        data["easytier_network_secret"] = E("easytier_network_secret").value.trim();
        data["easytier_dhcp"] = E("easytier_dhcp").checked ? "1" : "0";
        data["easytier_ipv4"] = E("easytier_ipv4").value.trim();
        data["easytier_port"] = E("easytier_port").value.trim() || "11010";
        data["easytier_proxy_network"] = E("easytier_proxy_network").value.trim();
        
        var peers = E("easytier_peers").value.trim();
        data["easytier_peers"] = peers;
        try {
            data["easytier_peers_encoded"] = btoa(unescape(encodeURIComponent(peers)));
        } catch(e) {}
    } else {
        var tomlContent = E("easytier_config_content").value.trim();
        if (!tomlContent) {
            alert("高级模式下，配置文件内容不能为空！");
            return null;
        }
        data["easytier_config_content"] = tomlContent;
        try {
            data["easytier_config_content_encoded"] = btoa(unescape(encodeURIComponent(tomlContent)));
        } catch(e) {}
    }
    return data;
}

function save_and_apply(action) {
    var fields = get_form_fields();
    if (!fields) return;

    if (!action) {
        action = fields["easytier_enable"] === "1" ? "restart" : "stop";
    }

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
            alert("请求提交失败或超时！");
        }
    });
}

function service_action(action) {
    var fields = get_form_fields();
    if (!fields) return;
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
            alert("执行操作失败！");
        }
    });
}

function generate_toml_from_simple() {
    var node = E("easytier_node_name").value.trim() || "ROG-GS7";
    var netName = E("easytier_network_name").value.trim() || "default_net";
    var secret = E("easytier_network_secret").value.trim();
    var port = E("easytier_port").value.trim() || "11010";
    var isDhcp = E("easytier_dhcp").checked;
    var ipv4 = E("easytier_ipv4").value.trim();
    var proxyNet = E("easytier_proxy_network").value.trim();
    var peers = E("easytier_peers").value.trim().split("\n");

    var toml = "# 从简易向导转换生成的 EasyTier 配置\n";
    toml += 'instance_name = "' + node + '"\n';
    toml += 'hostname = "' + node + '"\n\n';

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
    E("mode_custom").checked = true;
    toggle_mode_display("custom");
    alert("已将简易配置转换为 TOML 格式！您可以进行自由编辑与深度定制。");
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
                                            EasyTier <span id="easytier_version" style="font-size:14px; color:#00ffe4; font-weight:normal;"></span>
                                            <span style="font-size:12px; color:#a0aeb5; font-weight:normal; margin-left:10px;">去中心化 Mesh VPN 异地组网工具</span>
                                        </div>
                                        <div style="float: right; width: 15px; height: 25px; margin-top: -24px">
                                            <img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
                                        </div>
                                        <div style="margin: 10px 0 12px 5px;" class="splitLine"></div>

                                        <div class="SimpleNote">
                                            <a href="https://github.com/EasyTier/EasyTier" target="_blank"><em>EasyTier</em></a> 是一款基于 Rust 打造的简单、安全、去中心化的全网状 (Full-Mesh) 内网穿透 VPN。<br />
                                            <span><a href="https://github.com/EasyTier/EasyTier" target="_blank" class="ks_btn">项目官网</a></span>
                                            <span><a href="https://easytier.cn/web/index.html#/config_generator" target="_blank" class="ks_btn" style="margin-left:5px;">官方配置生成器</a></span>
                                            <span><a href="javascript:void(0);" onclick="get_log(1)" class="ks_btn" style="margin-left:5px;">查看插件日志</a></span>
                                            <span><a href="javascript:void(0);" onclick="clear_runtime_log()" class="ks_btn ks_btn_danger" style="margin-left:5px;">清空运行日志</a></span>
                                        </div>

                                        <!-- 状态面板 -->
                                        <div style="margin-bottom: 12px;">
                                            <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                <thead><tr><td colspan="2">EasyTier - 服务运行状态</td></tr></thead>
                                                <tr>
                                                    <th>运行状态</th>
                                                    <td>
                                                        <span id="easytier_status_badge" class="status_badge status_stopped">检测中...</span>
                                                        <span style="float:right; margin-right:10px;">
                                                            <input class="button_gen" id="btn_start" onClick="service_action('start')" type="button" value="启动服务" style="display:none; font-size:12px; height:26px; padding:0 10px;" />
                                                            <input class="button_gen" id="btn_stop" onClick="service_action('stop')" type="button" value="停止服务" style="display:none; font-size:12px; height:26px; padding:0 10px;" />
                                                            <input class="button_gen" id="btn_restart" onClick="service_action('restart')" type="button" value="重启服务" style="display:none; font-size:12px; height:26px; padding:0 10px;" />
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Tab 标签按钮组 -->
                                        <div style="margin-top: 15px;">
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
                                                            <span style="color:#00ffe4; margin-left:5px; font-weight:bold;">启用 EasyTier 服务</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>开机自启</th>
                                                        <td>
                                                            <input type="checkbox" id="easytier_autostart" style="vertical-align:middle;">
                                                            <span style="color:#a0aeb5; margin-left:5px;">路由重启后自动运行 EasyTier</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>配置模式</th>
                                                        <td>
                                                            <label style="cursor:pointer; margin-right:15px;">
                                                                <input type="radio" name="easytier_mode" id="mode_simple" value="simple" onchange="on_mode_change();" checked>
                                                                <b>简易向导模式</b> (推荐，自动配置子网与对端)
                                                            </label>
                                                            <label style="cursor:pointer;">
                                                                <input type="radio" name="easytier_mode" id="mode_custom" value="custom" onchange="on_mode_change();">
                                                                <b>高级 TOML 自定义</b> (完整配置文件)
                                                            </label>
                                                        </td>
                                                    </tr>
                                                </table>

                                                <!-- 简易向导模式分组 -->
                                                <div id="simple_settings_group" style="margin-top:10px;">
                                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                        <thead><tr><td colspan="2">EasyTier 简易组网参数</td></tr></thead>
                                                        <tr>
                                                            <th>节点名称 (Hostname)</th>
                                                            <td>
                                                                <input type="text" id="easytier_node_name" class="input_text" style="width:200px;" value="ROG-GS7" />
                                                                <span style="color:#a0aeb5; margin-left:6px;">本节点在 VPN 网络中的名称</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>组网网络名称</th>
                                                            <td>
                                                                <input type="text" id="easytier_network_name" class="input_text" style="width:200px;" placeholder="例如: my_home_net" />
                                                                <span style="color:#FC0; margin-left:6px;">* 相同网络名称的节点才能互相通信</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>组网通信密钥</th>
                                                            <td>
                                                                <input type="password" id="easytier_network_secret" class="input_text" style="width:200px;" placeholder="建议填写强密码" />
                                                                <span class="ks_btn" style="margin-left:6px; cursor:pointer;" onclick="toggle_secret_visibility();">显示/隐藏</span>
                                                                <span style="color:#FC0; margin-left:6px;">* 节点连接认证口令</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>虚拟 IPv4 地址</th>
                                                            <td>
                                                                <input type="text" id="easytier_ipv4" class="input_text" style="width:160px;" placeholder="例如: 10.144.144.1" />
                                                                <label style="cursor:pointer; margin-left:8px;">
                                                                    <input type="checkbox" id="easytier_dhcp" onchange="toggle_dhcp(this.checked);" checked style="vertical-align:middle;">
                                                                    <b>启用 DHCP 自动分配</b>
                                                                </label>
                                                                <div id="ipv4_tip" style="color:#a0aeb5; margin-top:4px; font-size:11px;">(DHCP模式: 自动由组网分配可用IP)</div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>局域网网段代理 (子网转发)</th>
                                                            <td>
                                                                <input type="text" id="easytier_proxy_network" class="input_text" style="width:200px;" placeholder="例如: 192.168.50.0/24" />
                                                                <div style="color:#00ffe4; margin-top:4px; font-size:12px;">
                                                                    💡 核心功能：将此局域网网段广播至 EasyTier，远端手机/电脑连接后即可直接访问家中 NAS、台式机等所有内网设备！
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>监听端口</th>
                                                            <td>
                                                                <input type="text" id="easytier_port" class="input_text" style="width:100px;" value="11010" />
                                                                <span style="color:#a0aeb5; margin-left:6px;">本地 TCP/UDP 监听端口 (默认 11010)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>对端节点 (Peers)</th>
                                                            <td>
                                                                <textarea id="easytier_peers" style="width:96%; height:80px; font-family:'Consolas',monospace; font-size:12px;" class="input_text" placeholder="tcp://public.easytier.top:11010"></textarea>
                                                                <div style="color:#a0aeb5; margin-top:4px; font-size:11px;">
                                                                    公共中继节点或直连节点地址，每行一个。例如：<br/>
                                                                    <code>tcp://public.easytier.top:11010</code><br/>
                                                                    <code>udp://223.5.5.5:11010</code>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>

                                                <!-- 高级自定义 TOML 切换提示 -->
                                                <div id="custom_settings_group" style="margin-top:10px; display:none;">
                                                    <div style="padding:15px; background:rgba(0,0,0,0.3); border-radius:4px; border:1px dashed #5a6a6f; text-align:center;">
                                                        <span style="color:#00ffe4; font-size:14px;">当前已启用【高级 TOML 自定义模式】</span><br/>
                                                        <span style="color:#a0aeb5; font-size:12px; margin-top:6px; display:inline-block;">请前往上方 “📝 高级 TOML 配置” 标签页编辑您的 TOML 配置文件。</span><br/>
                                                        <button type="button" class="ks_btn" style="margin-top:10px;" onclick="switch_tab(2)">👉 立即前往编辑 TOML 配置</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- 页面 2: 高级 TOML 配置 -->
                                            <div id="tab_page_2" class="tab_page" style="display:none;">
                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
                                                    <thead><tr><td colspan="2">EasyTier 完整 TOML 配置文件</td></tr></thead>
                                                    <tr>
                                                        <th>TOML 配置文件内容</th>
                                                        <td>
                                                            <div style="margin-bottom:6px;">
                                                                <input class="ks_btn" onClick="generate_toml_from_simple()" type="button" value="⚡ 从简易向导转换生成 TOML 模板" />
                                                                <input class="ks_btn ks_btn_danger" onClick="E('easytier_config_content').value=''" type="button" value="清空内容" style="margin-left:6px;" />
                                                                <a href="https://easytier.cn/web/index.html#/config_generator" target="_blank" class="ks_btn" style="margin-left:6px;">打开官方配置生成器 ↗</a>
                                                            </div>
                                                            <textarea id="easytier_config_content" style="width: 97%; height: 350px; font-family:'Consolas','Courier New',monospace; font-size:12px; line-height:16px;" class="input_text" spellcheck="false" placeholder="# 请在此粘贴完整的 EasyTier TOML 配置文件..."></textarea>
                                                            <div style="margin-top:6px; color:#a0aeb5; font-size:11px;">
                                                                支持 EasyTier 全功能参数（多协议监听、WireGuard 协议监听、多子网路由、数据压缩、AES-GCM 加密等）。
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>

                                            <!-- 页面 3: 节点与对端状态 (CLI) -->
                                            <div id="tab_page_3" class="tab_page" style="display:none;">
                                                <div style="margin-bottom:10px;">
                                                    <input class="ks_btn" onClick="fetch_cli_info('peer')" type="button" value="👥 查看对端节点 (easytier-cli peer)" />
                                                    <input class="ks_btn" onClick="fetch_cli_info('node')" type="button" value="💻 查看本节点信息 (easytier-cli node)" style="margin-left:6px;" />
                                                    <input class="ks_btn" onClick="fetch_cli_info('route')" type="button" value="🗺️ 查看路由与子网 (easytier-cli route)" style="margin-left:6px;" />
                                                </div>
                                                <textarea id="cli_terminal_output" class="cli_terminal" readonly="readonly" placeholder="点击上方按钮即可查询节点与网络拓扑实时状态..."></textarea>
                                                <div style="color:#a0aeb5; font-size:11px; margin-top:6px;">
                                                    提示: 对端状态展示包含延迟 (Latency)、丢包率 (Loss Rate)、直连/中继模式以及流量统计。
                                                </div>
                                            </div>

                                            <!-- 页面 4: 运行输出日志 -->
                                            <div id="tab_page_4" class="tab_page" style="display:none;">
                                                <div style="margin-bottom:10px;">
                                                    <input class="ks_btn" onClick="fetch_runtime_log()" type="button" value="🔄 刷新运行日志" />
                                                    <input class="ks_btn ks_btn_danger" onClick="clear_runtime_log()" type="button" value="🗑️ 清空运行日志" style="margin-left:6px;" />
                                                </div>
                                                <textarea id="runtime_log_area" class="cli_terminal" style="height:320px;" readonly="readonly" placeholder="暂无运行日志..."></textarea>
                                            </div>

                                        </div>

                                        <!-- 底部操作按钮 -->
                                        <div class="apply_gen" style="margin-top:15px;">
                                            <input class="button_gen" onClick="save_and_apply()" type="button" value="保存并应用" style="font-size:14px; height:32px; padding:0 25px;" />
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
