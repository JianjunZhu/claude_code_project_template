# 科研项目空模板（claude_code_project_template）

> 本模板于 2026-06-19 创建。
>
> 这是一个**科研项目空模板**：初始化时**可以没有任何代码、数据、实验、结果或论文**。模板只提供一套可追加、可追溯、防造假的工作骨架与协作纪律，供后续逐步填充真实内容。

---

## 1. 模板用途

本模板用于在 Claude Code（Agent）协助下开展科研项目，目标是让"Agent 行为规则 / 项目事实 / 科研证据 / 长期经验"四类信息**各归其位、互不污染**，并在整个项目生命周期中保持：

- **可追溯**：每一个数字、每一条关键结论都能回答"结论是什么 / 由哪个 artifact 支持 / artifact 在哪 / 何时生成 / 由什么命令生成 / 是初步还是最终证据"。
- **防造假**：在没有真实 artifact 支持前，绝不写入实验结果、指标、数据规模、baseline、训练状态、论文或临床结论。
- **可复现**：记录 commit hash、环境、seed、数据划分、配置、命令行参数、checkpoint 路径、评估脚本与输出 manifest。
- **可追加**：所有文档结构清晰、语气专业简洁，便于随项目推进不断补充。

初始化阶段，几乎所有项目事实都应当是占位符或 TBD / PENDING / NOT VERIFIED / INCOMPLETE，这是**正常状态**，不是缺陷。

---

## 2. 完整目录结构

```text
claude_code_project_template/
├── CLAUDE.md                          # Agent 行为规则（Agent 读这里决定怎么做事）
├── MEMORY.md                          # 长期经验 / 教训（跨任务复用，不是当前项目事实）
├── README.md                          # 本文件：模板总览与使用指南
├── QUICKSTART.md                      # 5 分钟上手（首次填写清单 + 合成示例）
├── .editorconfig                      # 统一编辑器格式（lf/文末空行/缩进，保证一致渲染）
├── .gitignore                         # git 忽略规则（数据/权重/大输出/缓存/密钥）
├── docs/                              # 文档：规则（固定）与记录（随项目更新）分开
│   ├── rules/                         # 规则文件：模板拥有，固定，仅经 update_from_template.sh 同步
│   │   ├── RESEARCH_RULES.md          # 科研纪律（证据等级、冻结测试、防造假）
│   │   ├── RESEARCH_LOOP.md           # 迭代研究循环协议（三环：计划/执行/写作）
│   │   └── TEMPLATE_CHANGELOG.md      # 模板自身的变更记录
│   └── records/                       # 记录文件：项目自有，随项目推进更新，同步脚本绝不触碰
│       ├── PROJECT.md                 # 当前项目事实（唯一事实源，全部占位符起步）
│       ├── TASK_BRIEF.md              # 当前任务简报（这一阶段要做什么）
│       ├── EVIDENCE.md                # 科研证据台账（结论 ↔ artifact 映射）
│       ├── EXPERIMENT_LOG.md          # 实验流水日志（按时间追加，含负结果）
│       ├── RESULT_AUDIT.md            # 结果审计（指标一致性、泄漏、复现核查）
│       └── PAPER_NOTES.md             # 论文/写作笔记（主张需有证据支撑）
├── configs/
│   ├── task_types/                    # 各任务类型配置（按需启用，12 个）
│   └── experiments/                   # 单次实验配置（seed/超参/划分，入 git）
├── src/                               # 项目自有源码（库/模块/模型/数据处理）
├── scripts/                           # 运行入口脚本（train_/eval_/prep_/plot_）+ 模板工具
│   ├── bootstrap_new_project.sh       # 从模板一键派生新项目
│   ├── update_from_template.sh        # 把模板规则更新到已派生项目（不动项目内容）
│   ├── check_template.sh              # 模板自检 linter（机械不变量，可挂 pre-commit/CI）
│   └── README.md                      # 脚本目录约定
├── third_party/                       # 第三方/下载代码（baseline/克隆仓库，不入 git，用 manifest）
├── data/                              # 数据（不入 git，用 manifest+checksum）
│   ├── raw/                           # 原始数据
│   ├── processed/                     # 预处理后数据
│   ├── validation/                    # 验证/外部评测数据
│   └── README.md                      # 数据组织与登记约定
├── outputs/                           # 运行中间产物（不入 git）
│   ├── <实验名>/<run-id>/             # 每次运行：checkpoints/ logs/ metrics/ predictions/
│   └── README.md                      # 输出组织约定
├── results/                           # 整理后结果 + 验证结果（轻量表/图，入 git）
│   └── README.md
├── reports/                           # 每轮研究报告
│   ├── round-<NN>_<主题>.md           # 逐轮报告（活跃）
│   ├── archive/                       # 归档旧报告（只归档不删除）
│   ├── SUMMARY.md                     # 定期归档总结（滚动汇总）
│   └── README.md
└── experiments/
    ├── records/                       # 单次运行记录（活跃）
    ├── records_archive/               # 归档运行记录（负结果不删除）
    └── README.md
```

---

## 3. 各文件职责（一句话说明）

| 路径 | 类别 | 一句话职责 |
| --- | --- | --- |
| [CLAUDE.md](CLAUDE.md) | Agent 行为规则 | 规定 Agent 在本项目里如何工作、能做什么、禁止什么。 |
| [MEMORY.md](MEMORY.md) | 长期经验 | 跨任务复用的经验与教训，不记录当前项目的具体事实。 |
| [README.md](README.md) | 总览 | 模板用途、结构、使用步骤与纪律要点（本文件）。 |
| [QUICKSTART.md](QUICKSTART.md) | 上手 | 5 分钟上手：派生 → 首次填写清单 → 一个明确标注的合成示例。 |
| [.editorconfig](.editorconfig) | 配置 | 统一编辑器格式（lf / 文末空行 / 缩进），保证文档一致渲染。 |
| [.gitignore](.gitignore) | 配置 | 规定哪些文件不进 git（数据、权重、大输出、缓存、密钥）。 |
| [docs/records/PROJECT.md](docs/records/PROJECT.md) | 项目事实 | 当前项目的唯一事实源：目标、任务类型、数据、环境、路径。 |
| [docs/records/TASK_BRIEF.md](docs/records/TASK_BRIEF.md) | 项目事实 | 当前阶段的任务简报：本轮要交付什么、范围与约束。 |
| [docs/rules/RESEARCH_RULES.md](docs/rules/RESEARCH_RULES.md) | 科研纪律 | 证据等级、冻结测试纪律、防造假与安全表达规则。 |
| [docs/rules/RESEARCH_LOOP.md](docs/rules/RESEARCH_LOOP.md) | 工作流 | 三环迭代循环协议（计划/执行/写作），论文产出主流程。 |
| [docs/records/EVIDENCE.md](docs/records/EVIDENCE.md) | 科研证据 | 证据台账：每条结论对应的 artifact、位置、生成命令、等级。 |
| [docs/records/EXPERIMENT_LOG.md](docs/records/EXPERIMENT_LOG.md) | 科研证据 | 按时间追加的实验流水，含失败与负结果。 |
| [docs/records/RESULT_AUDIT.md](docs/records/RESULT_AUDIT.md) | 科研证据 | 对结果做一致性 / 泄漏 / 复现的审计核查。 |
| [docs/records/PAPER_NOTES.md](docs/records/PAPER_NOTES.md) | 写作 | 论文与写作笔记，主张必须可回溯到证据。 |
| [docs/rules/TEMPLATE_CHANGELOG.md](docs/rules/TEMPLATE_CHANGELOG.md) | 模板维护 | 记录模板本身的演进，与项目事实分离。 |
| [configs/task_types/](configs/task_types/) | 配置 | 各任务类型的配置与约定，按项目实际需要启用。 |
| [configs/experiments/](configs/experiments/) | 配置 | 单次实验可复现配置（seed/超参/划分），入 git。 |
| [src/](src/) | 代码 | 项目自有源码（库/模块/模型/数据处理）。 |
| [third_party/](third_party/) | 代码 | 第三方/下载代码（baseline/克隆仓库，不入 git，用 manifest）。 |
| [scripts/](scripts/) | 代码 | 运行入口脚本 + 模板工具，配合 commit hash 与配置使用。 |
| [scripts/bootstrap_new_project.sh](scripts/bootstrap_new_project.sh) | 工具 | 从模板一键派生新项目（重置 git 历史 + 可追溯派生信息）。 |
| [scripts/update_from_template.sh](scripts/update_from_template.sh) | 工具 | 把模板规则更新到已派生项目（只覆盖规则、不动项目内容）。 |
| [scripts/check_template.sh](scripts/check_template.sh) | 工具 | 模板自检 linter：机械不变量（无扁平引用、链接可解析、无 math 围栏、脚本语法等），可挂 pre-commit/CI。 |
| [scripts/README.md](scripts/README.md) | 说明 | 脚本目录的命名、可复现与记录约定。 |
| [experiments/README.md](experiments/README.md) | 说明 | 实验记录目录约定（records / records_archive 分工）。 |
| [experiments/records/](experiments/records/) | 科研证据 | 活跃实验的记录目录。 |
| [experiments/records_archive/](experiments/records_archive/) | 科研证据 | 归档实验记录，负结果归此而非删除。 |
| [data/README.md](data/README.md) | 说明 | 数据组织与 manifest/checksum 约定（数据本体不入 git）。 |
| [outputs/README.md](outputs/README.md) | 说明 | 运行中间产物组织（`<实验>/<run>/`，大输出不入 git）。 |
| [results/](results/) | 科研证据 | 整理后结果与验证结果（轻量表/图，入 git，支撑 claim）。 |
| [reports/](reports/) | 科研证据 | 每轮研究报告 + `archive/` + `SUMMARY.md`（定期归档总结）。 |

---

## 4. 四类内容分工（务必区分，不要混淆）

| 类别 | 落点文件 | 内容性质 | 典型例子 |
| --- | --- | --- | --- |
| **Agent 行为规则** | `CLAUDE.md` | "Agent 该怎么做事"——稳定的协作约束 | 不在 holdout 上调参；不可逆操作需明确指令 |
| **当前项目事实** | `docs/records/PROJECT.md`、`docs/records/TASK_BRIEF.md` | "这个项目此刻是什么"——会随项目变化 | `<研究目标>`、`<数据集名称>`、`<Conda环境>` |
| **科研证据** | `docs/records/EVIDENCE.md`、`docs/records/EXPERIMENT_LOG.md`、`docs/records/RESULT_AUDIT.md` | "有什么被验证过"——结论与 artifact 的映射 | 某指标由某 checkpoint + 某评估脚本生成（含证据等级） |
| **长期经验** | `MEMORY.md` | "以后做事要记住什么"——跨项目复用 | 某类数据划分易泄漏；某流程容易出错的教训 |

> 关键原则：**项目事实不要写进 `MEMORY.md`，经验不要写进 `PROJECT.md`，未验证的结果不要写进任何文件当成已验证。**

### 4.1 `docs/` 的另一条分界：规则（固定）vs 记录（随项目更新）

上面的"四类内容"按**内容性质**分；`docs/` 还按**所有权与更新方式**正交地分成两类——这决定了升级模板时哪些文件会被覆盖、哪些绝不会动：

| 子目录 | 类别 | 谁拥有 / 何时变 | 文件 |
| --- | --- | --- | --- |
| [`docs/rules/`](docs/rules/) | **规则文件（固定）** | **模板拥有**；派生项目内**不应手改**，只在模板升级、经 `scripts/update_from_template.sh` 同步时整体更新 | `RESEARCH_RULES.md`、`RESEARCH_LOOP.md`、`TEMPLATE_CHANGELOG.md` |
| [`docs/records/`](docs/records/) | **记录文件（随项目更新）** | **项目自有**；随项目推进不断追加 / 修改，同步脚本**绝不触碰** | `PROJECT.md`、`TASK_BRIEF.md`、`EVIDENCE.md`、`EXPERIMENT_LOG.md`、`RESULT_AUDIT.md`、`PAPER_NOTES.md` |

> 一句话：**`rules/` 跟着模板走，`records/` 跟着项目走。** 同理，根目录的 `CLAUDE.md`、`README.md` 也是模板拥有（会被同步覆盖），`MEMORY.md` 是项目自有。
>
> **纪律**：项目特异的规则 / 偏好写进 `docs/records/PROJECT.md`，**不要直接改 `docs/rules/*` 或 `CLAUDE.md`**——否则下次 `update_from_template.sh` 升级会覆盖掉你的改动（见第 5.3 节）。

---

## 5. 使用方法

### 5.1 从模板派生新项目（bootstrap）

在**模板仓库内**运行——最简一条命令（先确保已配 git 身份：`git config --global user.name "你的名字"` 与 `user.email`）：

```bash
scripts/bootstrap_new_project.sh -n <新项目名> -r v0.4.0-template
```

默认生成在 `../<新项目名>`：**剥离模板 git 历史 → 新建独立仓库（main 分支）→ 写入可追溯派生信息**；不自动 push。常用选项：

- 绑定远程（不自动推）：`--remote git@github.com:<你>/<新项目名>.git`
- 指定目录 / 任务类型：`-d <目录>`、`-t <任务类型>`（如 `foundation_model`、`segmentation`）
- 换台机器：先 `git clone <模板URL>`，进入后再运行上面的命令并用 `-d` 指定目标目录。

### 5.2 首次使用步骤（派生后）

> 想更快上手：[QUICKSTART.md](QUICKSTART.md) 提供勾选清单与一个明确标注的合成示例。下面是详版步骤：

1. **先读 [CLAUDE.md](CLAUDE.md)** —— 了解 Agent 在本项目中的行为规则与禁止事项，确保协作从一开始就遵守科研纪律。
2. **再读 [docs/records/PROJECT.md](docs/records/PROJECT.md)** —— 这是当前项目的唯一事实源；把其中的占位符（如 `<项目名称>`、`<任务类型>`、`<研究目标>`、`<数据集名称>`、`<数据路径>`、`<主要指标>`）逐项替换为真实信息，未知项保留为 `TBD`。
3. **然后读 [docs/records/TASK_BRIEF.md](docs/records/TASK_BRIEF.md)** —— 明确"当前这一阶段具体要做什么"，界定范围、交付物与约束。
4. **按需启用任务类型配置** —— 在 [configs/task_types/](configs/task_types/) 中选择与本项目匹配的任务类型（如 `segmentation.md`、`benchmark.md`、`paper_writing.md` 等），其余可暂不使用。
5. **开始记录证据** —— 一旦产生真实运行/结果，先进 [docs/records/EXPERIMENT_LOG.md](docs/records/EXPERIMENT_LOG.md)（流水），再把可信结论登记到 [docs/records/EVIDENCE.md](docs/records/EVIDENCE.md)（台账），并标注证据等级。

### 5.3 更新模板规则（模板升级后同步到已派生项目）

派生项目是**独立仓库，不会自动跟随模板**。模板规则更新后，**在项目目录内**运行（要求工作区干净）：

```bash
scripts/update_from_template.sh --template <模板路径或URL> -r v0.4.0-template --dry-run
```

确认无误后去掉 `--dry-run` 实跑，再 `git diff` 审阅 → `git add -A && git commit`。要点：

- **只覆盖模板拥有的规则文件**（`CLAUDE.md`、`docs/rules/RESEARCH_RULES.md`、`docs/rules/RESEARCH_LOOP.md`、`docs/rules/TEMPLATE_CHANGELOG.md`、`configs/task_types/`、脚手架脚本），**绝不触碰项目自有内容**（`docs/records/` 下全部记录、实验 / 数据 / 结果 / 代码）。
- **旧布局自动迁移（v0.4.0-template 关键能力）**：早于本版本派生的项目，文档是**扁平的** `docs/*.md`。新脚本检测到扁平布局时会**一次性迁移到 `docs/rules/` + `docs/records/`**：把项目自有的记录文件（`PROJECT.md`、`EVIDENCE.md` 等）用 `git mv` **移入 `docs/records/`、完整保留你填写的内容**；把扁平旧址的规则文件（`RESEARCH_RULES.md` 等）`git rm` 删除，新版本随同步落到 `docs/rules/`。迁移**幂等**（已迁移则跳过）、**非破坏性**（记录内容不被覆盖，仅移动位置），`--dry-run` 会先预览将移动 / 删除哪些文件。
  - 可选 `--rewrite-refs`：迁移后顺带把项目记录文件**正文里**对 `docs/<名>.md` 的引用改写为 `docs/{rules,records}/<名>.md`（仅做这一确定性的路径替换，会触碰项目内容，默认关闭）。
- **补缺新目录**（可选 `--scaffold`）：旧项目缺 `src/`、`third_party/`、`results/`、`reports/`、`configs/experiments/`、`data/{raw,processed,validation}/` 等目录时，加 `--scaffold` 会**只新建缺失的脚手架文件、绝不覆盖已有**（已定制的同名文件原样保留），幂等。例：`update_from_template.sh --template <模板> -r v0.4.0-template --scaffold --dry-run`。
- 不自动提交；写 `.template-sync` 记录同步来源（ref + commit + 日期）。
- **纪律**：项目特异规则写进 [docs/records/PROJECT.md](docs/records/PROJECT.md)，**不要直接改 `docs/rules/*` 或 `CLAUDE.md` 等模板规则文件**，以免更新时被覆盖。

### 5.4 建议安装的技能 / 工具（增强协作）

下列工具与本模板配合更高效，**建议按需安装到本机**（技能 / 工具本体不入仓库）。它们是**增强项而非前置**——模板规则与流程不依赖它们，未安装时如实降级为手工流程。

**① academic-research-skills（ARS）** — 科研全流程技能套件（许可 CC-BY-NC，仅非商用）

- 来源：<https://github.com/imbad0202/academic-research-skills>
- 能力：`deep-research`（文献 / 综述 / 系统综述）、`academic-paper`（写作 / 改稿 / 引用核查）、`academic-paper-reviewer`（多视角同行评审）、`academic-pipeline`（端到端）。
- 安装（在 Claude Code 内）：

```
/plugin marketplace add Imbad0202/academic-research-skills
/plugin install academic-research-skills
```

- 用法：见 [CLAUDE.md](CLAUDE.md) 第 17 节与 [docs/rules/RESEARCH_LOOP.md](docs/rules/RESEARCH_LOOP.md)（写作 / 评审环委托 ARS）。

**② codegraph** — 代码知识图谱（Claude Code 的 MCP server，许可 MIT，100% 本地、无需 API key）

- 来源：<https://github.com/colbymchenry/codegraph>
- 特点：把整库的**符号、调用关系、imports、继承、路由→handler**预建成本地 **SQLite + FTS5 知识图谱**，**亚毫秒查询**、文件 watcher **增量同步**（约 2 秒去抖）；用即时图查询代替反复 grep / 读文件，**显著省 token 与工具调用**（README 基准：约 47% 更少 token、约 58% 更少工具调用）。支持 20+ 语言、零配置。
- 主要查询：`codegraph_explore`（"X 怎么工作 / 从 X 到 Y 的流程"，主力，一次拿结构化结果）、`codegraph_search`（按名查符号）、`codegraph_callers`（谁调用了它，含回调注册处）、`codegraph_node`（单符号完整源码 + 调用轨迹）；另有 callees / impact / files / status。
- 安装：`curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh`（或 `npm i -g @colbymchenry/codegraph`），安装器自动写好 MCP 配置。
- **每个项目首次需建索引**：在项目根运行 `codegraph init` 生成 `.codegraph/`（未建索引时 MCP 不激活）；之后自动增量同步。`.codegraph/` 为本地生成物，不入 git。
- 用法纪律：**写 / 改代码前先用 codegraph 理解结构、调用关系与影响面**（见 [CLAUDE.md](CLAUDE.md) 第 9 节），尤其在 `src/`、`third_party/` 与执行循环的代码工程阶段。

---

## 6. 占位符与证据纪律要点

### 6.1 占位符约定

信息未知时**用占位符表达，不得猜测真实值**：

- 项目事实用尖括号占位符，例如：`<项目名称>` `<任务类型>` `<研究目标>` `<数据集名称>` `<数据路径>` `<主要指标>` `<辅助指标>` `<外部测试集>` `<Python解释器>` `<Conda环境>` `<主脚本>` `<模型权重路径>` `<输出目录>` `<目标期刊>` `<基金项目类型>`。
- 状态用固定标记：
  - 信息未知 → **TBD**
  - 结果未验证 → **PENDING**
  - 结论未确认 → **NOT VERIFIED**
  - 实验未完成 → **INCOMPLETE**

### 6.2 统一证据等级（低 → 高，全模板引用同一套）

> 权威定义见 [docs/rules/RESEARCH_RULES.md](docs/rules/RESEARCH_RULES.md) 第 0 节（单一来源，避免多处描述漂移）；下表为速查。

| 等级 | 含义 |
| --- | --- |
| 1 | 假设 |
| 2 | 设计方案 |
| 3 | 实现正确性检查 |
| 4 | 开发集验证 |
| 5 | 内部验证 |
| 6 | 冻结内部测试 |
| 7 | 锁定 holdout 测试 |
| 8 | 外部验证 |
| 9 | 独立复现 |

**不得把低等级证据描述成高等级。** 例如：开发集（等级 4）上的初步结果不能写成 holdout（等级 7）或外部验证（等级 8）的结论。

### 6.3 证据可追溯（每个数字/关键结论都要能回答）

- 结论是什么？
- 由哪个 artifact 支持？
- artifact 在哪（路径/manifest）？
- 何时生成？
- 由什么命令生成（含 commit hash、seed、配置、参数）？
- 是初步证据还是最终证据（证据等级）？

### 6.4 冻结测试与负结果纪律

- 不在 holdout / 外部测试集上调 checkpoint、阈值、架构、loss，也不反复用其优化方法。
- 测试前**冻结**协议、脚本、模型、阈值、配置；一旦发生泄漏，必须记录。
- **负结果必须保留**（失败运行、被否定的假设、数据泄漏风险、指标不一致）：可归档到 [experiments/records_archive/](experiments/records_archive/)，**不可删除**。

### 6.5 可复现与不可逆操作

- 复现要素：commit hash、环境、seed、数据划分、配置、命令行参数、checkpoint 路径、评估脚本、输出 manifest。
- 数据 / 权重 / 大输出默认**不进 git**，用 **manifest + checksum** 替代；不提交密钥、token 或隐私路径。
- 删除数据 / checkpoint / 日志 / 指标 / 草稿 / 配置等**不可逆操作需明确指令**，优先归档而非删除。

### 6.6 科研安全表达

证据不足时，**不得**声称临床有效、诊断更优、泛化强、鲁棒、SOTA（state-of-the-art）或可临床使用。应使用谨慎措辞，如"我们假设 / 预期 / 仍需验证 / 当前证据仅支持……"。

---

## 7. 不得写入虚假项目内容（声明）

> 除"本模板于 2026-06-19 创建"这一真实事实外，本模板**初始状态不包含任何真实的项目事实**。
>
> 在没有真实 artifact 支持之前，**绝对禁止**写入：虚假的项目名称、实验结果、数据集信息、指标数值、baseline、对比方法、训练状态、模型行为、消融结论、运行时间、硬件占用、论文或临床结论。
>
> 所有具体项目内容一律以占位符（尖括号）或 TBD / PENDING / NOT VERIFIED / INCOMPLETE 表达，待真实信息到位后再替换。

---

## 8. 模板合格标准要点

一个**合格**的本模板实例，应满足：

- **四类内容分离**：Agent 行为规则、当前项目事实、科研证据、长期经验各归其位，无相互污染。
- **规则 / 记录分离**：`docs/rules/`（固定，模板拥有，仅经 `update_from_template.sh` 同步）与 `docs/records/`（项目自有，随项目更新）物理分开；规则文件不被项目手改，记录文件不被同步脚本覆盖。
- **零造假**：除创建日期外无任何未经 artifact 支持的项目事实、指标或结论；未知/未验证项均以占位符或状态标记呈现。
- **证据可追溯**：每条结论可回溯到 artifact、位置、生成命令、时间与证据等级。
- **证据等级一致**：全模板共用同一套 1–9 等级，无"低等级当高等级"的表述。
- **负结果保留**：失败与被否定的假设有据可查，归档而非删除。
- **冻结测试合规**：holdout / 外部测试集未被用于调参或反复优化，泄漏有记录。
- **可复现要素齐备**：commit hash、环境、seed、数据划分、配置、参数、checkpoint、评估脚本、manifest 可被记录与查找。
- **git 卫生**：数据 / 权重 / 大输出不入 git（以 manifest + checksum 替代），无密钥或隐私路径泄漏。
- **安全表达**：无证据不足却夸大（临床有效 / 更优 / 泛化 / 鲁棒 / SOTA）的措辞。
- **可在 VS Code 正常渲染**：行内公式用 `$...$`，块公式用独立成段的 `$$ ... $$`；图片用相对路径；结构清晰、可追加。

---

*本模板正文使用简体中文；CLAUDE.md、MEMORY.md、PENDING、TBD、NOT VERIFIED、INCOMPLETE、artifact、holdout、benchmark、baseline、checkpoint、commit hash、manifest、checksum、seed、train/validation/test、case-level、aggregate、leaderboard、state-of-the-art、git 等固定术语保留英文。*
