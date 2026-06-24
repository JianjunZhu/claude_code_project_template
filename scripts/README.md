# scripts/ 脚本目录约定

> 本文件描述本项目脚本目录的组织规则。本模板于 2026-06-19 创建。除模板基础设施脚本 `bootstrap_new_project.sh`（从模板派生新项目）与 `update_from_template.sh`（把模板规则更新到本项目）外，**当前目录内没有任何项目脚本**（训练 / 评估 / 数据处理等），下文均为占位约定。

本目录用于存放训练、评估、数据处理、绘图等脚本。源码与轻量脚本入 git。

---

## 1. 用途

| 脚本类别 | 说明 | 命名建议 |
| --- | --- | --- |
| 训练 | 模型训练入口 | `train_<任务/模型>.py` |
| 评估 | 在 validation / test / holdout / 外部测试集上评估 | `eval_<任务/集合>.py` |
| 数据处理 | 预处理、划分、manifest/checksum 生成 | `prep_<步骤>.py`、`make_manifest_<数据集>.py` |
| 绘图 / 分析 | 指标可视化、结果分析 | `plot_<内容>.py`、`analyze_<内容>.py` |
| 工具 | 通用辅助 | `util_<功能>.py` |

主脚本路径用占位符 `<主脚本>` 表达。

---

## 2. 命名建议

- 用动词前缀表明用途：`train_` / `eval_` / `prep_` / `plot_` / `analyze_` / `util_`。
- 名称小写、用下划线分隔；包含任务或对象，便于检索。
- 避免在脚本名中写入日期或一次性运行编号——运行的时间信息属于 `docs/records/EXPERIMENT_LOG.md` 与输出 manifest，而非脚本名。

---

## 3. 可复现要求

重要脚本（尤其训练与评估）应当可复现，并满足：

- 通过命令行参数或配置文件控制行为，避免硬编码隐私路径；路径用占位符 `<数据路径>` `<模型权重路径>` `<输出目录>`。
- 显式设置并记录 seed。
- 记录运行环境：`<Python解释器>` / `<Conda环境>`。
- 运行时打印或落盘：commit hash、配置、命令行参数、输出位置。

每次重要运行须登记到：

- `docs/records/EXPERIMENT_LOG.md`：流水总览 + 该次运行的详细记录（命令、环境、seed、配置、输出路径）。
- `docs/records/EVIDENCE.md`：该运行支撑的结论及其统一证据等级（1 假设 → 9 独立复现）。

---

## 4. 纪律

- 评估脚本在用于 holdout / 外部测试前应冻结；测试期间不修改评估逻辑以迎合结果。
- 脚本产生的指标在未验证前标 PENDING，结论未确认标 NOT VERIFIED。
- 删除脚本属不可逆操作，须明确指令，优先归档。

---

## 5. 当前状态

- 项目脚本（训练 / 评估 / 数据处理等）：无（空模板）
- 模板基础设施脚本：`bootstrap_new_project.sh` —— 从模板一键派生新项目（导出指定 ref、重置 git 历史、写入可追溯派生信息）；用法见 `bash scripts/bootstrap_new_project.sh -h`。
- 模板基础设施脚本：`update_from_template.sh` —— 把模板的规则文件（`CLAUDE.md`、`docs/rules/*`、`configs/task_types/`、脚手架脚本）更新到本（已派生）项目，**只覆盖规则、不动项目自有内容**（`docs/records/` 下的 PROJECT / EVIDENCE / 实验 / 数据 / 结果）；用法见 `bash scripts/update_from_template.sh -h`。
  - **旧布局迁移**：对早于 `v0.4.0-template` 的扁平 `docs/*.md` 项目，会一次性迁移到 `docs/rules/` + `docs/records/`——记录文件 `git mv` 入 `docs/records/`（**保留内容**）、旧扁平规则 `git rm`（新版本随同步落到 `docs/rules/`）；幂等、非破坏、`--dry-run` 预览，并对早于该版本、不含 `docs/rules/` 的 ref **拒绝迁移以防数据丢失**。可选 `--rewrite-refs` 改写项目正文里的 `docs/<名>.md` 引用。
  - **重要**：项目特异规则请写入 `docs/records/PROJECT.md`，**不要直接改 `docs/rules/*` 或 `CLAUDE.md` 等模板规则文件**，以免 `update_from_template.sh` 更新时被覆盖。
- 模板基础设施脚本：`check_template.sh` —— 模板自检 linter，检查**机械不变量**（无扁平 `docs/<名>.md` 引用、所有 `.md` 链接可解析、无 ` ```math ` 围栏、所有 `.sh` 过 `bash -n`、ALLOW 文件齐备、`docs/rules`+`docs/records` 结构完整、追加式目录有 `.gitkeep`）；有失败则退出码非 0，适合挂 pre-commit / CI。**仅机械检查，不替代证据纪律与人审的语义反造假**。用法 `bash scripts/check_template.sh`（或 `--quiet`）。
- 主脚本：`<主脚本>`（TBD）
