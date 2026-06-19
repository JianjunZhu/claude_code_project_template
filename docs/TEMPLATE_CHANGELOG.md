# TEMPLATE_CHANGELOG.md —— 模板变更日志

> 用途：记录**本科研项目模板本身**的演进（目录结构、规则、占位文档、配置骨架等），而非某个具体项目的实验进展。
> 项目级的实验流水请记入 `docs/EXPERIMENT_LOG.md`；长期经验请记入 `MEMORY.md`。
> 顺序约定：**最新条目置顶**。

---

## 条目格式

每条变更使用统一四要素，建议用表格或如下列表表达：

| 日期 | 变更 | 原因 | 影响 |
|---|---|---|---|
| YYYY-MM-DD | 这次改了什么（结构/规则/文档/配置） | 为什么改 | 对使用方式 / 既有项目的影响（含是否需要迁移、是否破坏性变更） |

或等价的列表形式：

- **日期**：YYYY-MM-DD
- **变更**：……
- **原因**：……
- **影响**：……（破坏性变更请显式标注 BREAKING）

> 填写须知：
> - 只记录模板层面的改动；具体项目事实不写入本文件。
> - 删除/重命名文件、修改证据等级定义、调整目录结构等属破坏性变更，须在"影响"列标注 BREAKING 并说明迁移方式。
> - 不可逆操作（删除文档/配置骨架）需明确指令，优先归档而非删除。

---

## 变更记录

| 日期 | 变更 | 原因 | 影响 |
|---|---|---|---|
| 2026-06-19 | **初始化空模板**：建立项目根文件（CLAUDE.md、MEMORY.md、README.md、.gitignore）；建立 `docs/`（PROJECT.md、TASK_BRIEF.md、RESEARCH_RULES.md、EVIDENCE.md、EXPERIMENT_LOG.md、RESULT_AUDIT.md、PAPER_NOTES.md、TEMPLATE_CHANGELOG.md）；建立 `configs/task_types/` 下 11 个任务类型配置骨架（segmentation、completion、detection、tracking、registration、robotics、reinforcement_learning、benchmark、paper_writing、grant_writing、software_engineering）；建立 `scripts/`、`experiments/{records,records_archive}/`、`data/README.md`、`outputs/README.md`；写入基础科研规则、统一证据等级、占位文档与证据/实验记录模板。**未写入任何虚假项目事实、实验结果、数据集信息、指标、baseline 或论文结论**；除"本模板于 2026-06-19 创建"外，全部为占位符。 | 搭建可复现、可追溯、可追加的科研项目起点，统一 Agent 行为规则 / 项目事实 / 科研证据 / 长期经验四类内容的边界 | 模板首次可用；后续具体项目在此基础上填充真实内容。本条为基线，无破坏性变更。 |

---

*后续每次修改模板，请在上表顶部新增一行，遵循"日期 | 变更 | 原因 | 影响"格式。*
