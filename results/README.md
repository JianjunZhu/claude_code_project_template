# results/ 整理后结果目录

> 本目录存放**整理后、用于支撑 claim 的结果与验证结果**（指标表、汇总、图）。本模板于 2026-06-19 创建，目录内无真实结果，下文为占位约定。

## 1. 定位（与 outputs/ 的区别）

- [`../outputs/`](../outputs/)：代码运行的**中间产物**（checkpoints / 日志 / 原始预测），体积大，**默认不入 git**。
- `results/`：从 outputs 中**整理出的、轻量的**结果——指标表（CSV / JSON）、验证结果汇总、图——用于进入 [`../docs/EVIDENCE.md`](../docs/EVIDENCE.md)、[`../docs/PAPER_NOTES.md`](../docs/PAPER_NOTES.md)、论文。**轻量文件入 git**（大文件仍放 `outputs/`，用 manifest 记录）。

## 2. 可追溯（每个结果都要能回答）

- 来自哪个 `outputs/<实验>/<run-id>/`？
- 由什么命令 / 评估脚本生成（commit hash、seed、配置）？
- 何时生成？对应**证据等级**（1–9）？
- 是开发集 / 内部 / holdout / 外部验证结果（口径不可混用）？

## 3. 组织建议

- 按实验 / 指标命名，如 `results/<实验>_<指标>.csv`、`results/figures/<图>.png`（相对路径引用）。
- **验证 / 外部评测结果单列**，注明数据来源（见 [`../data/validation/`](../data/validation/)）。
- 未核验数字标 PENDING，未确认结论标 NOT VERIFIED。

## 4. 当前状态

- 结果：无（空模板），全部 PENDING / NOT VERIFIED。
