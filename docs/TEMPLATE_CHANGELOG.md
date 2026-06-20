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
| 2026-06-20 | **新增派生脚本**：`scripts/bootstrap_new_project.sh` —— 从模板指定 ref（默认 HEAD，可选 v0-template）导出已提交内容到新目录、重置为全新 git 历史、在 `docs/PROJECT.md` 写入可追溯派生信息（模板 ref + commit hash + 日期 + 项目名）；支持 `-n/-d/-r/-t/--remote/-f`，不编造项目事实、不自动 push；同步在 `scripts/README.md` 说明。 | 让"从模板派生新项目"一键完成且来源可追溯，符合可复现与防造假纪律。 | 非破坏性：仅新增脚本与说明；派生项目默认携带该脚本，可再次派生。 |
| 2026-06-19 | **新增工作强度规则**：在 `CLAUDE.md` 增设第 15 节「工作强度与编排（默认 ultracode）」——默认以 ultracode 强度工作、对实质性任务主动启用 Workflow 多 agent 编排并对抗式验证，琐碎/对话任务仍单线；原「相关文档索引」顺延为第 16 节，新任务流程加指引。 | 固化用户默认工作模式：追求最详尽、最正确的结果，主动并行编排与交叉验证，同时与证据纪律和计算效率一致。 | 非破坏性：新增一节；CLAUDE.md 文档索引 15→16，无交叉引用断链。 |
| 2026-06-19 | **新增执行纪律规则**：在 `CLAUDE.md` 增设第 14 节「执行效率与长任务稳健性」（14.1 最大计算效率原则、14.2 长任务哨兵监控、14.3 小批量先行验证），原「相关文档索引」顺延为第 15 节；在 `docs/RESEARCH_RULES.md` 增设第 15 节「执行前验证与运行监控」镜像要点并交叉引用，避免重复。 | 在不牺牲正确性 / 可复现 / 证据等级前提下提升计算效率，并通过哨兵监控与小批量先行降低长任务与大批量运行的风险与算力浪费。 | 非破坏性：仅新增规则与小节；既有编号变动仅 CLAUDE.md 文档索引 14→15，无交叉引用断链。 |
| 2026-06-19 | **初始化空模板**：建立项目根文件（CLAUDE.md、MEMORY.md、README.md、.gitignore）；建立 `docs/`（PROJECT.md、TASK_BRIEF.md、RESEARCH_RULES.md、EVIDENCE.md、EXPERIMENT_LOG.md、RESULT_AUDIT.md、PAPER_NOTES.md、TEMPLATE_CHANGELOG.md）；建立 `configs/task_types/` 下 11 个任务类型配置骨架（segmentation、completion、detection、tracking、registration、robotics、reinforcement_learning、benchmark、paper_writing、grant_writing、software_engineering）；建立 `scripts/`、`experiments/{records,records_archive}/`、`data/README.md`、`outputs/README.md`；写入基础科研规则、统一证据等级、占位文档与证据/实验记录模板。**未写入任何虚假项目事实、实验结果、数据集信息、指标、baseline 或论文结论**；除"本模板于 2026-06-19 创建"外，全部为占位符。 | 搭建可复现、可追溯、可追加的科研项目起点，统一 Agent 行为规则 / 项目事实 / 科研证据 / 长期经验四类内容的边界 | 模板首次可用；后续具体项目在此基础上填充真实内容。本条为基线，无破坏性变更。 |

---

*后续每次修改模板，请在上表顶部新增一行，遵循"日期 | 变更 | 原因 | 影响"格式。*
