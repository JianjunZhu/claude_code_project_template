# CLAUDE.md — Claude Code 在本项目的工作手册

> 本文件是 Claude Code 每次打开本项目时**首先读取**的文件。它定义的是 **Agent 行为规则**（你该怎么工作），不是项目事实。
> 本模板于 2026-06-19 创建。这是一个**科研项目空模板**：除该创建日期外，模板中不包含任何真实的项目事实、实验结果、数据集信息、指标数值、baseline 或论文结论。所有具体内容均以占位符表达，待真实项目填充。

阅读对象：在本项目中工作的 Claude Code（及任何协作的人类）。请在动手前完整读完本文件，并按文末"首次打开项目流程"执行。

---

## 1. 本文件定位与四类内容分工

本项目把信息严格分为四类，**不要混淆**，写入前先判断属于哪一类、应落到哪个文件：

| 类别 | 文件 | 内容 | 判别标准 |
|---|---|---|---|
| Agent 行为规则 | `CLAUDE.md`（本文件） | Claude Code 在本项目"怎么工作"的准则、流程、纪律 | 描述的是**做事方式**，与具体项目无关，换一个项目仍成立 |
| 当前项目事实 | [`docs/PROJECT.md`](docs/PROJECT.md) | 当前项目是什么、目标、数据、环境、路径、状态等**事实** | 描述的是**这个项目此刻的客观情况**，会随项目推进而变化 |
| 科研证据 | [`docs/EVIDENCE.md`](docs/EVIDENCE.md)、[`docs/EXPERIMENT_LOG.md`](docs/EXPERIMENT_LOG.md) | 结论、指标、实验记录及其支撑 artifact 与证据等级 | 任何**数字、实验结果、被验证/被否定的结论** |
| 长期经验 | [`MEMORY.md`](MEMORY.md) | 跨任务、跨项目反复有用的**长期教训与约定** | 一条经验**下个月、下个任务仍然有用**才写这里 |

落位口诀：
- "Claude 应该怎么做" → 本文件。
- "项目现在是什么样" → `docs/PROJECT.md`。
- "某个结果/数字/结论及其证据" → `docs/EVIDENCE.md`（+ `docs/EXPERIMENT_LOG.md` 的过程记录）。
- "以后还会用到的教训" → `MEMORY.md`。
- 一次性的过程记录、临时调试笔记 → `docs/EXPERIMENT_LOG.md`，**不要**进 `MEMORY.md`。

---

## 2. 空项目与占位符纪律

本模板为空。在真实信息出现之前，**绝不猜测、绝不编造**真实值。

- 项目事实未知 → 用**尖括号占位符**，例如：`<项目名称>`、`<任务类型>`、`<研究目标>`、`<数据集名称>`、`<数据路径>`、`<主要指标>`、`<辅助指标>`、`<外部测试集>`、`<Python解释器>`、`<Conda环境>`、`<主脚本>`、`<模型权重路径>`、`<输出目录>`、`<目标期刊>`、`<基金项目类型>` 等。
- 信息确实未知 → 标 **TBD**。
- 结果尚未验证（已产出但未核对/未确认正确）→ 标 **PENDING**。
- 结论尚未确认（缺乏足够证据下结论）→ 标 **NOT VERIFIED**。
- 实验未完成（中断、跑了一半、还缺步骤）→ 标 **INCOMPLETE**。

纪律：
1. 看到占位符或 TBD/PENDING/NOT VERIFIED/INCOMPLETE，**不要**自行替换成"看起来合理"的值；要么向用户求证，要么保留标记。
2. 用户提供真实值后，再替换占位符，并在 `docs/PROJECT.md` 留下来源/时间。
3. 不确定就显式说"未知/待确认"，**宁可留白，不可虚构**。

---

## 3. 不得编造清单 + 必须标 PENDING / NOT VERIFIED 的情形

以下内容**没有真实 artifact 支持时，一律不得写成既成事实**：

- 实验结果、指标数值（任何 $\text{metric}$ 的具体数字）。
- 数据规模、样本数、train/validation/test 划分大小。
- 对比方法、baseline、leaderboard 名次、是否 state-of-the-art。
- 训练状态（是否收敛、训了多少 epoch、是否完成）。
- 模型行为（在某类样本上更好/更稳、失败模式）。
- 论文结论、临床结论、可用性声明。
- 消融实验结论。
- 运行时间、硬件占用（显存、GPU 数、耗时）。

处理方式：
- 已产出但未核对 → **PENDING**，并指明等待哪个核对动作。
- 结论缺证据 → **NOT VERIFIED**，写清还缺什么证据。
- 完全未知 → **TBD** 或尖括号占位符。
- 任何写入 `docs/EVIDENCE.md` 的数字/结论，必须能追溯到 artifact（见第 4 节），否则不得写入。

---

## 4. 证据可追溯与统一证据等级

### 4.1 可追溯六问

任何写进 `docs/EVIDENCE.md` 的数字或关键结论，必须能回答以下六问，缺项即标 TBD/PENDING：

1. **结论是什么？**
2. **由哪个 artifact 支持？**（日志、指标文件、checkpoint、图表等）
3. **artifact 在哪？**（路径 / manifest + checksum）
4. **何时生成？**
5. **由什么命令生成？**（含 seed、配置、commit hash）
6. **是初步还是最终证据？**（对应下方证据等级）

### 4.2 统一证据等级（低 → 高，全模板共用同一套）

引用证据强度时**必须用且只用**这套等级，不得把低等级说成高等级：

1. 假设
2. 设计方案
3. 实现正确性检查
4. 开发集验证
5. 内部验证
6. 冻结内部测试
7. 锁定 holdout 测试
8. 外部验证
9. 独立复现

使用规则：
- 标注证据时写明等级（如"等级 4：开发集验证"）。
- **禁止升级描述**：仅在开发集上看到的好结果，不能说成"已在 holdout 验证（等级 7）"或"已外部验证（等级 8）"。
- 等级越高，纪律越严（见第 8 节冻结测试）。

---

## 5. 结论表达与科研安全表达

- 证据不足时，**不得**声称：临床有效、诊断更优、泛化强、鲁棒、达到 state-of-the-art、可临床使用。
- 使用谨慎措辞：**"我们假设 / 预期 / 初步观察到 / 仍需验证 / 当前证据仅支持……"**。
- 把"结论"与"证据等级"绑定表述，例如："当前证据（等级 4，开发集）仅支持……，能否泛化到 holdout/外部数据 NOT VERIFIED。"
- 区分"统计上的差异"与"实际/临床意义"，不要混为一谈。
- 不替用户对外承诺性能；对外口径以 `docs/EVIDENCE.md` 中已达到的最高证据等级为准。

---

## 6. 负结果保留

- 失败的运行、被否定的假设、数据泄漏风险、指标不一致、复现失败等**负结果必须保留**。
- 负结果**可归档、不可删除**：移入 [`experiments/records_archive/`](experiments/records_archive/) 并在 `docs/EXPERIMENT_LOG.md` 标注原因，而不是抹掉。
- 负结果与正结果同样是证据；删除负结果等同于伪造研究记录，**禁止**。

---

## 7. 实验记录与可复现要求

每次实验（哪怕失败）都要可复现、可追溯。

- 过程与原始记录写入 [`docs/EXPERIMENT_LOG.md`](docs/EXPERIMENT_LOG.md)；可被引用的结论与指标沉淀到 [`docs/EVIDENCE.md`](docs/EVIDENCE.md)。
- 单次实验记录放 [`experiments/records/`](experiments/records/)，结束后归档到 [`experiments/records_archive/`](experiments/records_archive/)。
- 一条可复现记录至少包含：
  - **commit hash**（代码版本）
  - **环境**（`<Python解释器>` / `<Conda环境>` / 依赖版本）
  - **seed**
  - **数据划分**（train/validation/test，及划分来源）
  - **配置**（配置文件路径/内容）
  - **命令行参数**（完整命令）
  - **checkpoint 路径**（`<模型权重路径>`）
  - **评估脚本**（路径 + 版本）
  - **输出 manifest**（artifact 列表 + checksum，输出目录见 `<输出目录>`）
- 缺任一要素，该结果按 PENDING 处理，不得当作可信结论引用。

---

## 8. 冻结测试 / holdout 纪律

涉及 holdout（等级 7）与外部验证（等级 8）时，严格执行：

- **不**在 holdout / 外部测试集上调 checkpoint、阈值、架构、loss。
- **不**反复在 holdout / 外部测试集上"试方法"来挑选最优；这会让其退化为开发集，等级随之失效。
- 测试**前**冻结：协议、脚本、模型、阈值、配置；冻结点记录 commit hash 与时间。
- 一旦发生泄漏（如用测试信息做过选择），**必须如实记录**在 `docs/EXPERIMENT_LOG.md`，并下调相应结论的证据等级。
- 方法选择、调参、early stopping 一律在开发集 / 内部验证集（等级 4–5）上完成。

---

## 9. 代码编辑规则与不可逆操作规则

### 9.1 代码编辑

- 编辑前先用 Read 读到要改的文件与上下文；改动聚焦、最小、可解释。
- 遵循已有代码风格与目录约定；新增脚本放 [`scripts/`](scripts/)。
- 不在源码里硬编码私有绝对路径 / 密钥 / token；用配置或环境变量，路径用占位符。
- 改动影响到事实/结论/流程时，同步更新对应文档（见第 12 节）。

### 9.2 不可逆操作（需明确指令）

- 删除**数据 / checkpoint / 日志 / 指标 / 草稿 / 配置**属于不可逆操作，**必须有用户明确指令**才执行。
- **优先归档，而非删除**：移入 `*_archive/` 目录或加 `.bak`，并记录原因，而不是 `rm`。
- 批量删除、`git reset --hard`、强制覆盖、清空目录等危险操作前，先说明影响并征得确认。
- 不确定是否可逆 → 当作不可逆处理，先问。

---

## 10. git 规则与 Memory 规则

### 10.1 git

- **入 git**：源码、脚本、配置、轻量文档（Markdown、小图）。
- **默认不入 git**：原始数据、模型权重、大输出、概率图、医学影像、大体积中间产物；用 **manifest + checksum** 记录其位置与校验，纳入版本管理的是 manifest 而非数据本身。
- **绝不提交**：密钥、token、私有/隐私路径、受限数据。
- 提交信息清晰说明改了什么、为什么；不把待确认事实写成既成结论。
- 仅在用户要求时提交或推送。`.gitignore` 应覆盖数据/权重/大输出目录。

### 10.2 Memory

- [`MEMORY.md`](MEMORY.md) **只记长期经验**：反复踩的坑、稳定的约定、跨任务可复用的教训。
- **临时记录、单次实验过程、调试笔记 → `docs/EXPERIMENT_LOG.md`**，不要塞进 `MEMORY.md`。
- 写入 `MEMORY.md` 前自问："这条经验下个任务还会用到吗？"否，就别写这里。

---

## 11. 首次打开项目流程（8 步）

每次首次进入本项目，按序执行：

1. 读本文件 `CLAUDE.md`，确认行为规则与证据等级。
2. 读 [`docs/PROJECT.md`](docs/PROJECT.md)，了解当前项目事实与状态（多为占位符则说明项目尚未填充）。
3. 读 [`docs/RESEARCH_RULES.md`](docs/RESEARCH_RULES.md)，确认科研纪律细则。
4. 读 [`docs/TASK_BRIEF.md`](docs/TASK_BRIEF.md)，了解当前任务（若不存在或为空，说明暂无活动任务）。
5. 浏览 [`docs/EVIDENCE.md`](docs/EVIDENCE.md) 与 [`docs/EXPERIMENT_LOG.md`](docs/EXPERIMENT_LOG.md)，掌握已有证据与其证据等级。
6. 读 [`MEMORY.md`](MEMORY.md)，吸收长期经验。
7. 按需查看 [`configs/task_types/`](configs/task_types/) 中与当前 `<任务类型>` 对应的配置说明。
8. 与用户确认目标与边界后再动手；信息缺失处保留占位符并向用户求证，**不要**用猜测开工。

---

## 12. 新任务流程（8 步）

接到新任务时，按序执行：

1. 在 [`docs/TASK_BRIEF.md`](docs/TASK_BRIEF.md) **创建或更新**任务简报：目标、范围、输入/输出、验收标准、预期证据等级。
2. 对照 [`docs/PROJECT.md`](docs/PROJECT.md) 确认所需事实是否已知；未知处用占位符并向用户求证。
3. 给出方案（对应证据等级 1–2：假设 / 设计方案），列出步骤与可能风险。
4. 实现：编辑代码遵第 9 节，新脚本入 `scripts/`，配置入 `configs/`。
5. 运行与记录：过程写入 `docs/EXPERIMENT_LOG.md`，单次记录入 `experiments/records/`，满足第 7 节可复现要素。
6. 核对结果：未核对标 PENDING，核对后将可信结论与指标写入 `docs/EVIDENCE.md`，注明证据等级与 artifact 六问。
7. 涉及 holdout/外部测试，严格执行第 8 节冻结纪律；负结果按第 6 节保留归档。
8. 收尾：更新 `docs/PROJECT.md` 状态，把长期教训沉淀到 `MEMORY.md`，必要时更新本文件与 [`docs/TEMPLATE_CHANGELOG.md`](docs/TEMPLATE_CHANGELOG.md)。

---

## 13. 文档维护与 Markdown 规则

### 13.1 文档维护

- 文档应**可追加、可审计**：新增内容追加而非覆盖历史；纠正旧结论时保留旧记录并注明更正。
- 改动事实 → 更新 `docs/PROJECT.md`；改动结论/指标 → 更新 `docs/EVIDENCE.md`；模板本身演进 → 记入 `docs/TEMPLATE_CHANGELOG.md`。
- 结果审计写入 [`docs/RESULT_AUDIT.md`](docs/RESULT_AUDIT.md)；论文相关笔记写入 [`docs/PAPER_NOTES.md`](docs/PAPER_NOTES.md)。

### 13.2 Markdown（须在 VS Code 正常渲染）

- 正文一律简体中文；仅约定的固定术语保留英文（如 CLAUDE.md、MEMORY.md、PENDING、TBD、NOT VERIFIED、INCOMPLETE、artifact、holdout、benchmark、baseline、checkpoint、commit hash、manifest、checksum、seed、train/validation/test、case-level、aggregate、leaderboard、state-of-the-art、git）。
- 行内公式用 `$...$`，块公式用独立成段的 `$$ ... $$`。
- **禁止**使用以 `math` 作语言标注的代码围栏。
- 图片用相对路径。
- Mermaid 仅在确有助于理解时使用。
- 多用标题、列表、表格；语气专业、简洁、可追加。

---

## 14. 相关文档索引

核心文档：
- [`docs/PROJECT.md`](docs/PROJECT.md) — 当前项目事实与状态
- [`docs/TASK_BRIEF.md`](docs/TASK_BRIEF.md) — 当前任务简报
- [`docs/RESEARCH_RULES.md`](docs/RESEARCH_RULES.md) — 科研纪律细则
- [`docs/EVIDENCE.md`](docs/EVIDENCE.md) — 结论与证据（含证据等级）
- [`docs/EXPERIMENT_LOG.md`](docs/EXPERIMENT_LOG.md) — 实验过程记录
- [`docs/RESULT_AUDIT.md`](docs/RESULT_AUDIT.md) — 结果审计
- [`docs/PAPER_NOTES.md`](docs/PAPER_NOTES.md) — 论文笔记
- [`docs/TEMPLATE_CHANGELOG.md`](docs/TEMPLATE_CHANGELOG.md) — 模板变更记录
- [`MEMORY.md`](MEMORY.md) — 长期经验
- [`README.md`](README.md) — 模板概览

任务类型配置（[`configs/task_types/`](configs/task_types/)）：
- [`segmentation.md`](configs/task_types/segmentation.md)
- [`completion.md`](configs/task_types/completion.md)
- [`detection.md`](configs/task_types/detection.md)
- [`tracking.md`](configs/task_types/tracking.md)
- [`registration.md`](configs/task_types/registration.md)
- [`robotics.md`](configs/task_types/robotics.md)
- [`reinforcement_learning.md`](configs/task_types/reinforcement_learning.md)
- [`benchmark.md`](configs/task_types/benchmark.md)
- [`paper_writing.md`](configs/task_types/paper_writing.md)
- [`grant_writing.md`](configs/task_types/grant_writing.md)
- [`software_engineering.md`](configs/task_types/software_engineering.md)

目录约定：
- [`scripts/`](scripts/) — 脚本
- [`experiments/records/`](experiments/records/) — 单次实验记录
- [`experiments/records_archive/`](experiments/records_archive/) — 实验记录归档（含负结果）
- [`data/README.md`](data/README.md) — 数据说明（数据本身不入 git）
- [`outputs/README.md`](outputs/README.md) — 输出说明（大输出不入 git）

---

> 提醒：本文件定义"怎么做"。一旦发现行为规则与某次实际操作冲突，以本文件为准；若规则本身需要修订，先与用户确认，再更新本文件并记入 `docs/TEMPLATE_CHANGELOG.md`。
