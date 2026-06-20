# RESEARCH_LOOP.md —— 迭代研究循环协议

> 本文件定义本科研模板的"迭代研究循环"：一个**薄控制层**，把每阶段重活**委托给本机已装的 ARS 技能**（`deep-research` / `academic-paper` / `academic-paper-reviewer` / `academic-pipeline`），自身只负责目标设定、调度、收敛判定与状态留痕。**绝不重造 ARS 的流水线。**
> 终点目标 = **完成一篇满足明确成功判据的学术论文**。
> 本文件是**控制协议**，不记录项目事实（见 `PROJECT.md`）、不记录证据账本（见 `EVIDENCE.md`）、不记录逐次流水（见 `EXPERIMENT_LOG.md`）。
> 本模板于 2026-06-19 创建；本文件不含任何真实项目事实或结果。

---

## 0. 用途与定位

- **终点判据驱动**：循环只有在"论文完成判据"（见第 5 节）全部满足时才停止，而非"读起来完整"时。
- **何时启用**：项目进入"以产出论文为目标"的阶段（任务类型见 `configs/task_types/paper_writing.md`）。轻量答疑、单步改动不必起循环。
- **与四类文档的关系**：每轮证据 → `docs/EVIDENCE.md`；逐轮过程 → `docs/EXPERIMENT_LOG.md`；claim→证据映射 → `docs/PAPER_NOTES.md`；本文件只存**循环状态**（第 6 节）。
- **与 ARS 的关系**：本循环是调度器，ARS 技能是执行单元；技能产出**不豁免**本模板纪律（统一证据等级 1-9、不得编造、冻结测试、负结果保留、可追溯六问）。
- **执行跨三类工作**：循环的"执行"涵盖**调研、代码 / 实验工程（写代码 · 运行 · 测试）、写作**三类——多数 claim 的证据来自实验，故代码 / 实验工程是 claim 沿证据等级爬升的主要途径（见第 3 节"代码 / 实验工程子循环"）。代码工程委托给本仓库 `scripts/` 与自有技能（非 ARS），写作 / 评审委托 ARS。

---

## 1. 角色（同一 agent 轮流担任三职责）

| 职责 | 做什么 | 主要委托 |
|---|---|---|
| 执行者 | 推进当前阶段（调研 / **代码 · 实验工程** / 写作 / 改稿），产出 artifact | `deep-research`、`academic-paper`（`/ars-plan`、`/ars-outline`、`/ars-revision`）、`scripts/` 下工程脚本与自有技能 |
| 检查者 | 对照成功判据与证据等级核验，找 gap、过度声称、不可追溯项 | `academic-paper-reviewer`（`/ars-reviewer`，含 Devil's Advocate）、`/ars-citation-check` |
| 修订者 | 按检查结论做**一处聚焦修订**，更新映射与状态 | `academic-paper`（`/ars-revision`） |

> **减少自评偏差**：检查环节优先借 `academic-paper-reviewer` 做**独立同行评审**，而非由执行者自评"看起来不错"。评审结论是参考意见（CLAUDE.md 第 17 节），但其指出的 critical 项必须落实到第 6 节状态表。

---

## 2. 第 0 步：目标设定（人审关卡）

目标须**可证伪、有成功判据**，至少包含：核心 claim 清单、各 claim 的**目标证据等级**、目标期刊/格式、主要/辅助指标口径。两种来源：

- **来源 a（用户给定）**：用户直接给出学术目标 → agent 复述为结构化目标卡（下表）→ **用户确认**后进入循环。
- **来源 b（agent 提议）**：用户只给方向 → 用 `deep-research`（如 `lit-review` / `three-way-scan`）调研现状与 gap → agent **提议**若干候选目标（每个含可证伪 claim 与目标证据等级）→ **用户确认/挑选**后进入循环。

> **硬关卡**：目标设定**必须经用户确认**，agent 不得自行拍板开始迭代。目标卡定稿后：核心 claim 清单与各 claim 目标证据等级登记到 `docs/PAPER_NOTES.md` 第 2 节（核心 claim→证据映射表），论文元信息登记到第 1 节；并在本文件第 6 节状态表落地。

**目标卡（确认后填写）**

| 项 | 值 |
|---|---|
| 论文工作标题 | `<论文标题>`（TBD） |
| 终点成功判据 | 见第 5 节"完成"定义 |
| 核心 claim 清单 | C1 `<…>` / C2 `<…>` / C3 `<…>`（TBD） |
| 各 claim 目标证据等级 | C1=`<6/7/8>` …（TBD，对照 EVIDENCE 1-9） |
| 目标期刊/格式 | `<目标期刊>`（TBD） |
| 用户确认 | [ ] 已确认（PENDING） |

---

## 3. 循环主体（每轮 = 执行 → 检查 → 修订）

每轮聚焦**一个 claim 或一处缺口**（借鉴 autoresearch"每轮一处原子改动、delta 可归因"），按下表推进；逐轮 detail 写入 `docs/EXPERIMENT_LOG.md`，状态汇总更新第 6 节。

| 阶段 | 做什么 | 委托哪个 ARS | 落到哪个文档 |
|---|---|---|---|
| 执行·调研 | 补文献 / 核查事实 / 系统综述，为 claim 找支撑或反证 | `deep-research` | `EVIDENCE.md`、`PAPER_NOTES.md` |
| 执行·工程 / 实验 | 写 / 改代码、跑实验、单元 / 集成测试，产出实验 artifact 支撑 claim | 见下「代码 / 实验工程子循环」（`scripts/` + 自有技能，非 ARS） | `EXPERIMENT_LOG.md`、`EVIDENCE.md`、`outputs/` |
| 执行·写作 | 大纲 / 章节 / 改稿，把已验证证据组织成正文 | `academic-paper`（`/ars-plan`、`/ars-outline`、`/ars-revision`） | 草稿、`PAPER_NOTES.md` |
| 检查·评审 | 独立同行评审（含 Devil's Advocate），列 critical/major/minor | `academic-paper-reviewer`（`/ars-reviewer`） | `EXPERIMENT_LOG.md` |
| 检查·引用 | 引用真实性与一致性核查，禁编造文献 | `/ars-citation-check` | `PAPER_NOTES.md` 第 9 节 |
| 修订 | 针对最高优先级问题做一处修订，回填证据等级 | `academic-paper`（`/ars-revision`） | 草稿、`PAPER_NOTES.md` |

> **端到端可选与分工**：默认按上表**单步委托**（单 claim / 单缺口的聚焦迭代）。仅当需一次跑通"research→write→integrity→review→revise→finalize"、且各 claim 已较成熟时，才用 `academic-pipeline`（`/ars-full`）作为整轮执行单元；其内部各阶段产出仍按上表对位归档，其自带的评审 / 完整性结果**仍须按第 5/7 节闸门复核，不替代人审**。避免单步委托与 pipeline 双层编排重复。

**代码 / 实验工程子循环**（claim 的证据多来自实验；"执行·工程 / 实验"按此推进——这一段是 autoresearch 原生的代码迭代精华，是 claim 沿证据等级 3→4→5… 爬升的主因）：

1. **改一处**：写 / 改一处代码或配置（一次一个变更，delta 可归因，呼应"原子改动"）。
2. **小批量先验**：先按 CLAUDE.md 第 14.3 节小批量跑通（数据 / 形状 / 指标 / pipeline 正确，达证据等级 3）再放量。
3. **运行**：按第 14.1 节算力高效执行、第 14.2 节为长任务设哨兵监控；**先 commit 再运行**，保证可回退。
4. **测试 / 验证**：跑单元 / 集成测试与固定评估脚本，取**机械化指标**（脚本输出的数值），算相对上一轮的 delta。
5. **keep / discard**（autoresearch 精华）：指标改善且无回归 → 保留；变差 / 崩溃 / 无效 → 回退（如 `git revert`），失败零成本、历史单调趋好；**负结果归档不删除**（第 7 节、CLAUDE.md 第 6 节）。
6. **留痕升级证据**：artifact（checkpoint / 指标 / 日志 / manifest+checksum）记入 `EXPERIMENT_LOG.md`，可信结论升级到 `EVIDENCE.md` 并上调对应 claim 的实际证据等级。

> 纪律：评估脚本 / 阈值在 holdout / 外部集前**冻结**（CLAUDE.md 第 8 节）；删除 checkpoint / 日志 / 数据属**不可逆操作**需明确指令（CLAUDE.md 第 9.2 节）；机械化指标优先于主观判断。

---

## 4. 收敛指标（可归因、机械化优先）

借鉴 autoresearch 的"机械化判定 + 剩余工作量标量"，把"是否继续"尽量变成可勾选的客观条件，而非主观感觉：

- **剩余工作量** = 未达标 claim 数 + **失败 / 未通过的实验或测试数** + 评审未决 critical 项数 + 未解决引用错误数。该值应**单调下降**才算收敛。
- **每轮可归因**：每轮只动一处，记录该轮 artifact / 证据等级变化，使剩余工作量的 delta 可归因到单一改动。
- **降级即回退**：若某轮为"过关"而下调标准（见第 7 节），该轮视为**无效轮**，不计入收敛进度，并在 `EXPERIMENT_LOG.md` 标注。

---

## 5. 停止 / 收敛判据、迭代上限与人审

**完成（CONVERGED）—— 须同时满足**：

1. [ ] 第 6 节所有核心 claim 状态脱离 PENDING，且**实际证据等级 ≥ 目标证据等级**；
2. [ ] `academic-paper-reviewer` 最近一轮评审**无 critical 项**（major 已处理或有明确依据保留）；
3. [ ] `/ars-citation-check` 无编造/错误引用，`PAPER_NOTES.md` 第 2/3/4 节映射完备且数字一致；
4. [ ] 局限性与负结果如实呈现（`PAPER_NOTES.md` 第 5/6 节），无超证据声明（RESEARCH_RULES 第 11 节）；
5. [ ] 用户对定稿做**最终人审确认**。

**非完成的终止态（防死循环）**：

- **PLATEAU（停滞）**：连续 ≥ 3 轮剩余工作量不降（或在降标准与升标准间反复振荡）→ **停循环、上报用户**，不自行放宽判据。
- **BLOCKED（受阻）**：关键证据无法获得（如缺数据、外部集不可得）、或某 claim 目标证据等级在现有资源下不可达 → 停、上报、记入负结果。
- **预算上限**：默认**最大 12 轮**（或用户设定的 `轮次上限 N`）。达上限仍未 CONVERGED → 强制停，按当前状态如实上报，**不得为收尾而降标**。

**必须人审的节点**：① 目标设定（第 2 节）；② 重大方向改变（增删核心 claim、改目标证据等级、换目标期刊）；③ 定稿（完成判据第 5 项）。三者 agent 均**不得自行决定**。

---

## 6. 循环状态表（紧凑，逐轮覆盖更新）

> 本表是循环的**单一状态视图**；逐轮过程明细记入 `docs/EXPERIMENT_LOG.md`，证据记入 `docs/EVIDENCE.md`，claim 映射记入 `docs/PAPER_NOTES.md`。本模板内全为占位符。

| 项 | 值 |
|---|---|
| 论文工作标题 | `<论文标题>`（TBD） |
| 当前轮次 / 上限 | 0 / 12（INCOMPLETE） |
| 剩余工作量（第 4 节） | TBD |
| 本轮聚焦 | `<本轮 claim / gap>`（TBD） |
| 下一步 | `<下一步动作>`（PENDING） |

**各 claim 状态**

| claim | 表述（简） | 目标等级 | 实际等级 | 支持 artifact | 状态 |
|---|---|---|---|---|---|
| C1 | `<…>`（TBD） | `<7>` | TBD | `<路径/ID>`（TBD） | PENDING |
| C2 | `<…>`（TBD） | `<6>` | TBD | `<路径/ID>`（TBD） | PENDING |

**未决 gap**

| 编号 | gap / 评审项 | 严重度（critical/major/minor） | 处理 | 状态 |
|---|---|---|---|---|
| G1 | `<…>`（TBD） | TBD | TBD | PENDING |

**停止判据勾选**：[ ] claim 全达标 ・ [ ] 无 critical ・ [ ] 引用/映射通过 ・ [ ] 局限/负结果完整 ・ [ ] 用户定稿确认 ——（全勾 = CONVERGED）

---

## 7. 防滥用闸门（收敛不得靠降低标准）

- **不得降标收敛**：达不到目标证据等级时，**降低 claim 强度或下调目标等级**只能经第 5 节"重大方向改变"人审，不得在循环内悄悄完成；私自降标的轮次按第 4 节作废。
- **目标等级须匹配结论强度**：目标证据等级要与 claim 结论强度相称——强结论目标等级须 ≥ 7（锁定 holdout），临床 / 泛化类主张须对应外部或独立证据（RESEARCH_RULES 第 11 节）；设定低目标等级却作强 / 临床结论的目标卡不予通过。
- **不得在 holdout/外部集上调**：检查/修订**不得**借 holdout（等级 7）或外部集（等级 8）来"挑"写法或选择性报告（RESEARCH_RULES 第 5 节）；这类集合一次性评估、冻结后用。
- **证据不足即 PENDING**：claim 即使"读起来完整、行文流畅"，只要未满足可追溯六问或证据等级未达标，状态**必须**保持 PENDING / NOT VERIFIED，不得在状态表或正文标为完成。
- **不得编造补齐**：缺证据时标占位符并上报，**不得**用虚构指标 / 文献 / 对比填满表格（RESEARCH_RULES 第 1 节、PAPER_NOTES 第 9 节）。
- **评审是参考非免责**：通过 `academic-paper-reviewer` 不等于证据达标；评审无 critical 仅是完成判据之一，证据等级仍以真实 artifact 为准。

---

## 关联文档

- Agent 行为总则：`../CLAUDE.md`（第 14–17 节）
- 科研纪律细则：`./RESEARCH_RULES.md`
- 论文 claim→证据映射：`./PAPER_NOTES.md`
- 证据账本：`./EVIDENCE.md`
- 实验流水：`./EXPERIMENT_LOG.md`
- 任务类型配置：`../configs/task_types/paper_writing.md`、`../configs/task_types/software_engineering.md`
- 代码工程纪律：`../CLAUDE.md` 第 9 节（代码编辑 / 不可逆操作）、第 14 节（算力 / 哨兵 / 小批量先验）
