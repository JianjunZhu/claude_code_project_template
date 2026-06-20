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

接到新任务时，按序执行（默认以第 15 节 ultracode 强度执行：实质性、多步骤任务主动起 Workflow 编排并对关键结论做对抗式验证；科研类任务——文献 / 写作 / 评审——优先调用第 17 节所列技能；**以产出论文为终点的任务，按 [`docs/RESEARCH_LOOP.md`](docs/RESEARCH_LOOP.md) 起迭代研究循环**）：

1. 在 [`docs/TASK_BRIEF.md`](docs/TASK_BRIEF.md) **创建或更新**任务简报：目标、范围、输入/输出、验收标准、预期证据等级。
2. 对照 [`docs/PROJECT.md`](docs/PROJECT.md) 确认所需事实是否已知；未知处用占位符并向用户求证。
3. 给出方案（对应证据等级 1–2：假设 / 设计方案），列出步骤与可能风险。
4. 实现：编辑代码遵第 9 节，新脚本入 `scripts/`，配置入 `configs/`。
5. 运行与记录：过程写入 `docs/EXPERIMENT_LOG.md`，单次记录入 `experiments/records/`，满足第 7 节可复现要素；**放量前先按第 14 节做小批量验证**，长任务按第 14 节设哨兵监控，并在不损害正确性/可复现的前提下追求计算效率。
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

## 14. 执行效率与长任务稳健性

任务执行阶段，在**不牺牲正确性、可复现与证据等级**的前提下追求最快的有效计算；长任务要可监控、可快速止损；放量前先小批量跑通。

### 14.1 最大计算效率原则

目标：让任务端到端 wall-clock 最短，**充分利用可用计算资源**，不让昂贵算力空转或被数据吞吐拖慢。

- **先定位瓶颈再优化**：判断是计算受限（compute-bound）还是数据吞吐受限（IO / data-bound）——观察 GPU 利用率、IO 等待、CPU / 内存占用；针对瓶颈优化，不盲目堆资源。
- **数据吞吐不应让计算单元饥饿**：合理设置 dataloader 并行 worker 数、预取（prefetch）、缓存、`pin_memory`、合适 batch size；必要时把数据放本地高速盘 / 内存盘。目标是让 GPU 利用率接近饱和而非空等数据。
- **计算效率**：在不影响科研结论的前提下，用合适 batch size 提升并行度、启用混合精度 / 合适 dtype、按需多 GPU / 分布式、避免重复计算并缓存可复用的中间结果。
- **不以正确性换速度**：任何为提速引入的近似、降精度、子采样、提前停止**必须记录**，并确认不影响结论有效性；若可能影响，标 `NOT VERIFIED` 并说明。
- **效率优化不得破坏纪律**：不得因加速而违反冻结测试纪律（第 8 节）或引入数据泄漏；不得为省时间跳过可复现要素（第 7 节）。
- **资源使用可追溯**：把 GPU 利用率、吞吐、wall-clock、显存占用作为运行信息记入 `docs/EXPERIMENT_LOG.md`；无真实运行前这些数值为 `PENDING`，不得虚构。

### 14.2 长任务哨兵监控

对训练、大批量推理、大规模数据处理等**长时间运行**的任务，设置哨兵（watchdog）定时监控，发现问题快速应对。

- **定时巡检**：按任务时长选择巡检间隔，检查——进程 / 作业是否存活、loss 或关键指标是否 `NaN` / 发散、GPU 利用率是否异常掉零、显存是否将 OOM、磁盘空间、日志是否停滞（卡死）、checkpoint 是否按期产出。
- **快速止损**：一旦发现崩溃、发散、卡死或资源耗尽，**及时处置**——保存现场、记录失败模式、停止或回滚到最近 checkpoint；不让坏运行长时间空耗算力。
- **可实现手段**（按环境择用）：心跳 / 进度日志、定时轮询脚本、watchdog 进程、发散即停（NaN 即 abort）、资源与超时告警、checkpoint 定期落盘。
- **留痕与负结果**：监控发现的问题及处置写入 `docs/EXPERIMENT_LOG.md`；失败运行属负结果，**归档不删除**（第 6 节），并保留足以复现失败的上下文（commit hash / 配置 / seed / 数据划分）。

### 14.3 小批量先行验证（放量前必做）

在开启**大批量 / 全量**数据验证或正式实验之前，先在**小批量**（少量样本 / 少量 step / 单个 case）上完全跑通并验证正确性。

- **先验证什么**：数据加载与预处理正确、形状 / dtype 正确、前向与反向无报错、指标计算正确、输出与保存路径正确、端到端 pipeline 贯通、随机性 / seed 可控、评估脚本与指标口径正确。
- **通过标准**：小批量结果在量级与方向上合理（非 `NaN`、非恒定、无明显错误），达到**证据等级 3（实现正确性检查）**。注意：**小批量跑通 ≠ 方法有效**——它只证明实现 / 流程正确，不得据此宣称任何科研结论（仍为等级 3，远低于 dev / holdout / 外部）。
- **再逐步放量**：小批量完全通过后，再扩到大批量 / 全量，并继续按 14.2 设哨兵监控。
- **为什么必须**：跳过小批量直接全量是高风险——一个实现 bug 可能浪费大量算力与时间，甚至污染结果、误导结论。
- **记录**：小批量验证作为一次前置检查记入 `docs/EXPERIMENT_LOG.md`（通过前标 `INCOMPLETE` / `PENDING`），通过后再开展正式实验。

---

## 15. 工作强度与编排（默认 ultracode）

> 本项目默认以 **ultracode** 强度工作：优先追求最详尽、最正确的结果，而非最快或最省。对实质性任务**主动启用 Workflow（多 agent 编排）**，而不是被动单线执行。

- **默认强度**：除非用户另行指定，按 ultracode 处理——以彻底、可验证为第一目标，token 成本不作为约束。
- **主动编排 Workflow**：对实质性、多步骤、可并行或需交叉验证的任务（理解代码、设计方案、实现、审查、迁移、大范围检索、文献 / 证据核验等），**主动**用 Workflow 分解并并行推进，并对关键结论做对抗式验证（adversarial verify）、必要时加完整性批判后再下结论。
- **何时单线即可**：纯对话、答疑或一两步即可完成的琐碎改动，直接执行，不必起 workflow（避免无谓开销）。
- **与科研纪律一致**：并行与多视角验证用于**提升证据质量**，不得用来绕过证据等级、冻结测试（第 8 节）或可追溯要求（第 4、7 节）；workflow 产出的结论同样要落到 `docs/EVIDENCE.md` 并标注证据等级。
- **与计算效率一致**：编排策略服务于"最正确"，并与第 14 节的计算效率配合——多 agent 编排追求覆盖与确信，算力执行追求高效，二者不冲突。
- **可被用户降档**：用户显式要求"快速 / 单线 / 低强度"时以用户为准；调整后在 `docs/TASK_BRIEF.md` 注明本任务采用的强度。

---

## 16. 汇报与沟通方式

回复与汇报遵循**先结论、后细节**的顺序，同时照顾"快速读懂全局"与"深入核对细节"两种需求。

- **先一句话通俗结论**：用最朴素的语言（不堆术语）先说清——做了什么 / 现在是什么状态 / 是否成功 / 下一步是什么，让用户不读细节也能掌握全局。
- **再分层展开细节**：随后给出关键结果、改动清单、命令、证据与取舍等，供需要核对的人深入。
- **结构清晰（倒金字塔）**：较长的汇报用小标题 / 列表 / 表格分层，最重要的放最前面。
- **诚实优先于好看**：成败与未决项放在前面如实说明——失败、跳过的步骤、未验证的结论不得埋在细节里（与第 3 节不得编造、第 5 节科研安全表达一致）。
- **结论绑定证据等级**：涉及科研结果时，通俗结论也要匹配证据等级，不把 `PENDING` / `NOT VERIFIED` 说成既成事实。

---

## 17. 科研技能的主动使用

本机（用户级 `~/.claude/skills/`）已安装科研技能套件 `academic-research-skills`（含 `deep-research`、`academic-paper`、`academic-paper-reviewer`、`academic-pipeline`；许可 CC-BY-NC，仅非商用并需署名）。遇到对应科研任务时**主动调用**相应技能完成，而不是从零手写。

技能 → 任务映射：

| 任务 | 优先调用的技能 |
|---|---|
| 文献调研 / 综述 / 事实核查 / 系统综述（PRISMA） | `deep-research` |
| 论文 / 手稿写作、大纲、改稿、摘要、格式转换 | `academic-paper` |
| 同行评审 / 投稿前自检 / 方法学审查 | `academic-paper-reviewer` |
| 端到端"研究 → 写作 → 评审"流水 | `academic-pipeline` |

使用纪律（**技能不豁免本模板的科研纪律**）：

- **主动但不盲从**：技能是工具 / copilot，其产出仍须过本文件的证据与防造假规则——`deep-research` 的引用必须真实可核验，**不得编造文献**；写作产出中的指标 / 结论须能追溯到 `docs/EVIDENCE.md`，未验证标 `PENDING` / `NOT VERIFIED`。
- **评审产出是参考意见**：`academic-paper-reviewer` 的评分 / 结论是参考，非客观事实。
- **产出归档对位**：综述 → `docs/PAPER_NOTES.md` / `docs/EVIDENCE.md`，写作 → 草稿，评审 → 记录；并注明"由 `<技能名>` 生成"。
- **环境降级要诚实**：若当前环境未安装该技能（如某些 headless / CI 环境），如实说明并降级为手工流程，**不假装已调用**。
- **许可边界**：CC-BY-NC 仅非商用；涉及商用 / 可能转化的项目先与用户确认。
- **自有技能另置**：项目自有技能（自己写的）放仓库内 `.claude/skills/` 并提交，可随派生项目继承；第三方插件以本机安装或 `settings.json` 声明引入，不复制进仓库。

---

## 18. 相关文档索引

核心文档：
- [`docs/PROJECT.md`](docs/PROJECT.md) — 当前项目事实与状态
- [`docs/TASK_BRIEF.md`](docs/TASK_BRIEF.md) — 当前任务简报
- [`docs/RESEARCH_RULES.md`](docs/RESEARCH_RULES.md) — 科研纪律细则
- [`docs/RESEARCH_LOOP.md`](docs/RESEARCH_LOOP.md) — 迭代研究循环控制协议（论文产出主工作流）
- [`docs/EVIDENCE.md`](docs/EVIDENCE.md) — 结论与证据（含证据等级）
- [`docs/EXPERIMENT_LOG.md`](docs/EXPERIMENT_LOG.md) — 实验过程记录
- [`docs/RESULT_AUDIT.md`](docs/RESULT_AUDIT.md) — 结果审计
- [`docs/PAPER_NOTES.md`](docs/PAPER_NOTES.md) — 论文笔记
- [`docs/TEMPLATE_CHANGELOG.md`](docs/TEMPLATE_CHANGELOG.md) — 模板变更记录
- [`MEMORY.md`](MEMORY.md) — 长期经验
- [`README.md`](README.md) — 模板概览

任务类型配置（[`configs/task_types/`](configs/task_types/)）：
- [`foundation_model.md`](configs/task_types/foundation_model.md)
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
