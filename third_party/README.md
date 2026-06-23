# third_party/ 第三方 / 下载代码目录

> 本目录存放**第三方 / 外部下载的代码**（baseline 实现、克隆的仓库、外部库源码等）。本模板于 2026-06-19 创建，目录内无真实内容，下文为占位约定。

## 1. 定位

- 凡**非本项目自有**的代码放这里，与 [`../src/`](../src/)（自有源码）严格区分。
- 默认**不入 git**（体积大、有独立来源与许可）：用 **manifest + checksum** 或 **git submodule** 记录来源与版本，纳入版本管理的是登记信息而非代码本体。

## 2. 每个第三方项须登记（manifest）

- 名称与用途（用于哪个 baseline / 步骤）。
- 来源 URL（仓库 / release 页）。
- 版本 / commit hash / release tag。
- **License**（务必核对许可与使用范围；非商用 / 署名等约束记录在案）。
- 获取命令（`git clone … && git checkout <commit>` 或下载链接）。
- 本地路径（`third_party/<名称>/`）。

## 3. 纪律

- **不改第三方代码**；确需修改用 patch 文件记录改动（`third_party/<名称>.patch`），便于复现与升级。
- baseline 复现须可追溯：记录 commit、配置、命令；无法复现的 baseline 标 `NOT VERIFIED`，不得直接引用其数值当对比结论（见 `../docs/rules/RESEARCH_RULES.md`）。
- 不提交受限 / 隐私 / 含密钥的外部内容。

## 4. 当前状态

- 第三方代码：无（空模板）。manifest：`<third_party_manifest>`（TBD）。
