# Vanta // 游戏、开发与研究的 Linux 原型

> 一台机器，一套严肃的工作环境。能玩、能写代码、能研究系统；不对尚未验证的兼容性作承诺。

Vanta 基于 [Bazzite](https://github.com/ublue-os/bazzite) 与 [Universal Blue 镜像模板](https://github.com/ublue-os/image-template)。这个仓库提供用于构建 x86_64 安装 ISO 的配置和脚本。**ISO 已由 GitHub Actions 构建；启动、安装与实机兼容性尚未验证。**

## 设计目标

| 领域 | 方案 |
| :--- | :--- |
| 游戏 | Bazzite 桌面、Steam 与 Proton |
| 虚拟化 | QEMU/KVM、libvirt、virt-manager；适配 AMD-V 与 Intel VT-x |
| 状态检查 | `vanta-check` 只读显示 CPU、KVM 与 GPU 信息 |
| 技术实验室 | `vanta-lab` 首次启动时创建 Fedora 45 Distrobox，包含 Rust/Cargo、C/C++、GDB、binutils、radare2、Python、Nmap、DNS/WHOIS 工具与 jq |

主目标硬件是 **Ryzen 5 5600X + RTX 2080 + 32 GB RAM**。x86_64 Intel 处理器也可作为 CPU 目标；当前基础镜像针对 NVIDIA 显卡。AMD/Intel 显卡需要选择另一条基础镜像路线。

`vanta-check` 与 `vanta-lab` 都有桌面入口。Distrobox 会共享宿主机的个人目录，它是开发环境，**不是恶意样本沙箱**；不可信样本应放在一次性虚拟机中分析。

## 游戏兼容性：边界必须说清楚

Steam/Proton 能运行哪些游戏，取决于游戏本身及发行商的反作弊支持。截至 **2026-11-24**，Vanguard 版《英雄联盟》和受 EAC 保护的 Rust 官方服务器不能按本镜像的 Linux 路线运行；这些游戏仍需 Windows。Vanta 的 ISO 不会修改 Windows，也不会自动配置双系统。

## 构建链

```text
main 分支 → Build container image → ghcr.io/dajiejie1/vanta:latest
          → Build Vanta ISO（手动触发）→ vanta-iso + SHA256SUMS
          → 虚拟机启动验证 → 安装介质
```

1. [容器镜像工作流](https://github.com/dajiejie1/vanta/actions/workflows/build.yml) 已成功；公开的 `ghcr.io/dajiejie1/vanta:latest` 可以匿名拉取。
2. [ISO 构建记录](https://github.com/dajiejie1/vanta/actions/runs/45405031898) 已成功，产生 `vanta-iso` 与 `SHA256SUMS`。[技术预览 Release](https://github.com/dajiejie1/vanta/releases/tag/vanta-preview-2026-11-24) 提供长期下载；也可以手动重新运行 [Build Vanta ISO](https://github.com/dajiejie1/vanta/actions/workflows/build-disk.yml)。
3. 先在虚拟机里验证启动和安装流程，再考虑写入 USB。安装前备份目标磁盘。

工作流会把仓库所有者写入安装配置。未配置 Cosign `SIGNING_SECRET` 时，签名步骤会跳过；不应把未签名镜像描述成已签名。

## 下载技术预览

在 [Vanta 技术预览](https://github.com/dajiejie1/vanta/releases/tag/vanta-preview-2026-11-24) 下载 `part01`、`part02` 与 `SHA256SUMS`。GitHub Release 的单文件上限小于 2 GiB，因此这份 2.16 GB 的 ISO 分成两部分。把三个文件放在同一目录，在 **Windows 命令提示符 `cmd.exe`** 里合并：

```cmd
copy /b Vanta-preview-2026-11-24.iso.part01+Vanta-preview-2026-11-24.iso.part02 Vanta-preview-2026-11-24.iso
```

然后在 PowerShell 校验完整文件：

```powershell
Get-FileHash -Algorithm SHA256 .\Vanta-preview-2026-11-24.iso
```

预期结果：`1213d241ac494c8f7742448aa2af46270a8d9baeebdcc969a75b3592dc077dff`。安装器需要网络连接来获取公开的 Vanta 镜像。ISO 仍应先在虚拟机里测试，不能直接视为已验证的安装介质。

在 Linux 上，本地构建可使用 `just build-iso` 和 rootful Podman；公开工作流使用 Ubuntu 24.04，以避开 [osbuild 在 Ubuntu 26.04 runner 上的挂载问题](https://github.com/osbuild/osbuild/issues/2579)。

## 当前状态

容器镜像构建和 Fedora 45 安装 ISO 生成工作流已成功，安装包附有 SHA-256 校验文件。**尚未完成虚拟机启动、安装流程或实机验证。**这个仓库仍是技术原型，不应直接写入主力电脑磁盘。

## 来源与许可

基于 [Universal Blue 镜像模板](https://github.com/ublue-os/image-template) 与 [Bazzite](https://github.com/ublue-os/bazzite)；模板许可为 Apache-2.0，见 [`LICENSE`](LICENSE)。

兼容性资料：[Valve / Proton](https://partner.steamgames.com/doc/steamdeck/proton) · [Riot / Vanguard](https://www.leagueoflegends.com/en-ph/news/dev/dev-vanguard-x-lol/) · [Facepunch / Rust](https://rust.facepunch.com/news/the-lumberjack)
