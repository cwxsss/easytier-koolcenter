# EasyTier for ROG 魔盒 (GS7) KoolCenter 官改软件中心插件

<p align="center">
  <img src="easytier/res/icon-easytier.png" alt="EasyTier" width="100" height="100">
</p>

<p align="center">
  <a href="https://github.com/cwxsss/easytier-koolcenter/releases/latest"><img src="https://img.shields.io/github/v/release/cwxsss/easytier-koolcenter?color=brightgreen&label=Release" alt="Latest Release"></a>
  <a href="https://github.com/cwxsss/easytier-koolcenter/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License"></a>
  <img src="https://img.shields.io/badge/Platform-Asuswrt%203006%20%7C%20ARM64-red.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Router-ROG%20GS7%20BE7200-orange.svg" alt="Router">
</p>

本插件专为 **华硕 ROG 魔盒 (ROG GS7 / BE7200)** 及基于 **Asuswrt 3.0.0.6 (3006) 架构的 KoolCenter 官改固件** 深度定制，将轻量、安全、去中心化的全网状 (Full-Mesh) VPN 组网工具 **[EasyTier](https://github.com/EasyTier/EasyTier)** 完整集成到路由器软件中心。

---

## 📥 快速下载

* **最新离线安装包**: 👉 [**easytier.tar.gz**](https://github.com/cwxsss/easytier-koolcenter/releases/latest/download/easytier.tar.gz)
* **MD5 校验文件**: [easytier.tar.gz.md5](https://github.com/cwxsss/easytier-koolcenter/releases/latest/download/easytier.tar.gz.md5)
* **所有历史版本**: [Releases 页面](https://github.com/cwxsss/easytier-koolcenter/releases)

---

## 🌟 固件与硬件环境

| 项目 | 说明 |
| :--- | :--- |
| **适配设备** | **华硕 ROG 魔盒 (ROG GS7 / BE7200 双频)** 及同系列 Wi-Fi 7 / Wi-Fi 6 路由器 |
| **固件平台** | KoolCenter 官改固件（如 `GS7_3.0.0.6_102_58273_koolcenter` 及更新版本） |
| **处理器架构** | 联发科 Filogic 880 (MT7988DV, 四核 ARMv8-A Cortex-A73 64位, `aarch64`) |
| **平台校验标识** | `mtk` (已注入 `.valid` 文件，完美通过 `ks_tar_install.sh` 平台白名单检测) |
| **内置程序** | EasyTier 官方发布版 v2.6.4 (`easytier-core` 核心守护进程 + `easytier-cli` 状态监控工具) |

---

## 🚀 核心功能特色

1. **深度贴合 ROG 视觉与后台机制**
   * 界面针对 ROG 红黑电竞 UI 主题深度优化，无缝融入华硕 3006 官方后台。
   * 严格遵循 KoolCenter 规范，采用非阻塞异步应答架构，彻底根除耗时操作导致的 `httpd` 崩溃或 504 Gateway Timeout 报错。
2. **简易向导 + 高级 TOML 双模式**
   * **简易向导模式 (推荐)**：直观配置节点名称、网络名称、通信密钥、虚拟 IPv4 (静态 / DHCP)、监听端口以及对端节点列表。
   * **高级 TOML 模式**：提供完整的 TOML 配置文件编辑窗口，支持【一键从简易向导转换生成 TOML 模板】，满足多协议监听 (TCP/UDP/WireGuard) 与进阶加密调优需求。
3. **自动局域网子网代理 (Subnet Proxy)**
   * 自动探测路由器当前 LAN 网段（例如 `192.168.50.0/24`），一键将家庭局域网广播到 EasyTier 虚拟网。
   * 异地手机、笔记本连接 EasyTier 后，可直接访问家中 NAS、台式机、打印机或智能家居后台，无需每台设备分别安装客户端。
4. **内核级防火墙与 NAT 转发策略联动**
   * 启动时自动加载 `tun` 驱动，动态下发 iptables 双向转发及 NAT MASQUERADE 规则，保证跨网段数据包正常回包；停止或卸载时完整清理规则。
5. **集成 easytier-cli 实时监控面板**
   * Web 界面内建 CLI 终端面板，可一键实时查询：
     * 👥 **对端节点 (easytier-cli peer)**: 查看直连/中继模式、通信协议、延迟 (Latency)、丢包率与流量统计。
     * 💻 **本节点状态 (easytier-cli node)**: 查看节点 ID、虚拟 IP、网络拓扑信息。
     * 🗺️ **路由与子网 (easytier-cli route)**: 监控子网转发路由同步状态。
6. **开机自启与看门狗自动守护 (Watchdog)**
   * 注册标准开机启动（`init.d/S99easytier.sh`）与优雅关机（`init.d/N99easytier.sh`）脚本。
   * **内置进程看门狗 (Watchdog)**：利用系统 Cron 任务周期性巡检（支持 1/2/5 分钟），遇到网络重载、瞬态波动或进程异常退出时自动拉起重启。
   * **排他文件互斥锁 (Flock)**：全流程加锁防护，彻底杜绝 Web 连续点击、异步请求与定时任务并发踩踏。

---

## 🛠️ 安装教程

### 方法一：软件中心网页端离线安装 (推荐)

1. 前往 [Releases 页面](https://github.com/cwxsss/easytier-koolcenter/releases/latest) 下载 **`easytier.tar.gz`**。
2. 浏览器打开 ROG 魔盒后台（通常为 `http://192.168.50.1`）。
3. 点击左侧菜单进入 **【KoolCenter 软件中心】**（或 **【酷友社软件中心】**）。
4. 切换到 **【离线安装】** 选项卡。
5. 点击“选择文件”上传 **`easytier.tar.gz`**，点击 **【上传并安装】**。
6. 等待安装日志窗口提示“安装完成”并自动关闭。
7. **按 `Ctrl + F5` 强制刷新页面**，即可在插件列表中看到 **EasyTier** 图标。

---

### 方法二：通过 SSH 终端命令行安装 (备用)

如果网页离线安装遇到问题，可使用 SSH 手动安装：

1. 在路由器后台【系统管理】->【系统设置】中开启 **SSH 访问**。
2. 使用终端连接路由器：
   ```bash
   ssh admin@192.168.50.1
   ```
3. 在路由器终端中一键下载并安装：
   ```bash
   cd /tmp
   wget --no-check-certificate https://github.com/cwxsss/easytier-koolcenter/releases/latest/download/easytier.tar.gz
   tar -zxvf easytier.tar.gz
   chmod +x /tmp/easytier/install.sh
   /tmp/easytier/install.sh
   ```
4. 刷新网页后台即可进入插件进行配置。

---

## 📖 配置与使用指南

1. **基本设置**：
   * 打开 EasyTier 插件页面。
   * 勾选 **【开启 EasyTier】** 与 **【开机自启】**。
2. **组网参数 (简易模式)**：
   * **节点名称**: 默认为 `ROG-GS7`（可按需自定义，如 `home-gs7`）。
   * **组网网络名称**: 设定一个网络标识（例如 `my_family_vpn`）。
   * **组网通信密钥**: 设置强密码（加入同一网络的设备必须填写相同的网络名称和密钥）。
   * **虚拟 IPv4**: 建议勾选 **【启用 DHCP 自动分配】**；若需要固定 IP，取消勾选并填入如 `10.144.144.1`。
   * **局域网网段代理**: 默认自动填入路由器当前 LAN 网段（例如 `192.168.50.0/24`），保持默认即可。
   * **对端节点 (Peers)**: 填入公共中继节点或私有节点地址，默认已预设官方公共节点：
     ```text
     tcp://public.easytier.top:11010
     ```
3. **启动服务**：
   * 点击页面底部的 **【保存并应用】**。
   * 顶部状态徽章变为绿色的 **“● 运行中 (PID: xxx)”** 即表示启动成功。
4. **状态与节点监控**：
   * 切换至 **【🌐 节点与对端状态 (CLI)】** 标签页。
   * 点击 **【查看对端节点】** 即可实时看到连接的远端设备 IP、延时与传输情况。

---

## ❓ 常见问题排查 (FAQ)

1. **提示“不是ASUS mtk平台的离线包”？**
   * 本安装包内已经将 `mtk`、`hnd`、`qca` 等全平台标识写入 `.valid` 文件，完全通过平台校验。请确保上传的是未经解压重压的完整 `easytier.tar.gz`。
2. **异地设备连接后无法 ping 通家中局域网电脑？**
   * 请确认电脑自身的本地防火墙（如 Windows Defender 防火墙）是否拦截了 ICMP 回显请求。
   * 确认路由器 Web 界面中的“局域网网段代理”与实际家庭网段相符（例如实际是 `192.168.50.x`，代理配置需为 `192.168.50.0/24`）。
3. **服务刚启动后莫名自行退出，日志显示 `terminate signal received, exiting...`？**
   * **子网代理 CIDR 冲突（最常见致命原因）**：如果路由器是二级路由（WAN 口获取到光猫的 `192.168.1.x`），而 EasyTier 网络的其他节点广播了 `192.168.1.0/24`，或者本设备误将 `192.168.1.0/24` 设为了代理；系统一旦添加指向 `tun0` 的路由，本路由器的默认网关就会被劫持导致全网断开。华硕固件检测到 WAN 掉线后会触发网络重载，进而发送信号终止 EasyTier。**解决办法**：请将子网代理修改为与上级光猫不同的内网网段（如 `192.168.50.0/24`），并确保对端没有重复广播相同的网段。
   * **看门狗与并发锁保障**：最新版本已内置看门狗守护进程（Watchdog）以及排他互斥锁（Flock）。即使遇到偶发瞬态网络波动或信号干扰，看门狗也会在 1~2 分钟内自动重新拉起服务。
4. **如何彻底卸载？**
   * 在软件中心已安装插件列表中点击 EasyTier 下方的“卸载”按钮即可；或在 SSH 下执行：
     ```bash
     sh /koolshare/scripts/uninstall_easytier.sh
     ```

---

## 📄 开源许可

本项目基于 [Apache License 2.0](LICENSE) 开源。EasyTier 核心代码版权归原作者 [EasyTier Team](https://github.com/EasyTier/EasyTier) 所有。
