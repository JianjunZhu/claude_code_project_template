# RESEARCH_LOOP.md —— 迭代研究循环协议

> 本文件定义本科研模板的**迭代闭环**：整个项目 = **三个串联但异构的循环**——**① 计划 → ② 执行 → ③ 写作**。三环都迭代，但**内部 workflow 各不相同**，分别贴合"做设计 / 做实验 / 做写作"三种任务的本质与失败模式——**不是同一个"产出→评审→修订"的套子套三遍**。
> **薄控制层**：循环只管阶段调度、迭代与收敛判定、状态留痕；每个角色的重活**委托已装 ARS 技能、本仓库 `scripts/`/`src/`、以及原生 Workflow 多 agent 编排**，绝不重造其流水线。
> 终点 = **一篇满足科研目标与成功判据的学术论文**。
> 本文件是控制协议，不记录项目事实（`docs/records/PROJECT.md`）/ 证据账本（`docs/records/EVIDENCE.md`）/ 逐次流水（`docs/records/EXPERIMENT_LOG.md`）。本模板内不含真实结果。

---

## 0. 总览：三个异构循环

三环各自的**本质不同**，因此内部编排（agent 角色 + workflow 形态）也不同；它们靠**统一的交接契约、三道人审、环间升级、防卡死与反滥用闸门**（§4）串成一条研究管线。

| 环 | 任务本质 | 内部编排形态 | 主力 agent 角色 | 出环判据（＋人审） | 最大轮次 |
|---|---|---|---|---|---|
| **① 计划** | 不确定下的**发散设计 → 收敛择优** | 多方案 fan-out → **红队对抗** → **评审团择优** → **冻结预注册** | 文献侦察 · 研究架构师 · 红队（魔鬼代言+方法学）· 综合裁判 · 冻结官 | 无 critical ＋ 计划冻结 | ≤ 4 |
| **② 执行** | **机械收敛**的工程＋实验 | 原子改动 → 小批验证 → 监控运行 → 审计 → **对抗核验** → 升等级（loop-until-dry 饱和） | 实现者 · 哨兵 · 结果审计 · 对抗核验 | claim 实际等级 ≥ 目标 ＋ 证据达标 | ≤ 8 |
| **③ 写作** | 受证据约束的**结构化起草 + 模拟同行评审** | 大纲+证据映射 → **分章并行起草** → 整合 → 自检 → **5 视角评审团** → 修订⇄复评 | 大纲架构师 · 分章起草者 · 一致性编辑 · 证据/引用核查 · 评审团 · 修订者 | 评审无 critical ＋ 定稿 | ≤ 5 |

```text
            ┌───────── 共享状态：TASK_BRIEF / EVIDENCE / EXPERIMENT_LOG / 剩余工作量标量 ─────────┐
            │                                                                                  │
   ┌────────▼────────┐        交接：冻结计划         ┌────────▼────────┐        交接：达标证据账本     ┌────────▼────────┐
   │ ① 计划循环       │  ＋每条 claim 目标等级  ───▶ │ ② 执行循环       │  ＋负结果归档  ───────────▶ │ ③ 写作循环       │
   │ 发散设计·红队·冻结│                            │ 机械收敛·对抗核验 │                            │ 起草·评审团·修订  │
   └────────┬────────┘                            └────────┬────────┘                            └────────┬────────┘
            │  ◀── 升级回路：执行发现「设计有误」回环 1 ──────┘   ◀── 升级回路：评审暴露「证据缺口」回环 2 ──────┘
            │
        人审关卡 ①计划冻结        人审关卡 ②证据达标             人审关卡 ③论文定稿 ── 完成
```

> 共性（§4 详述）：每环"做产物"由其角色编排完成，"判是否过"务必由**独立视角**进行（候选随机标号、盲化去偏），而非自评"看着不错"；三处**人审**不可由 agent 自行拍板；任何长自主执行都按 `CLAUDE.md` 第 14.2 节设**监察者**防卡死。
> 术语说明：表中 `parallel-fanout / pipeline / judge-panel / adversarial-verify / loop-until-dry` 是**编排形态的描述性叫法**（对应 `CLAUDE.md` 第 15 节的 Workflow 多 agent 编排），不是某个固定工具名。同一插件可在不同环担不同职：如 `synthesis_agent` 在计划环任"综合裁判"、在写作环任"一致性编辑"——是一个插件的两种用法，角色名不同不代表是两个独立引擎。

---

## 1. 环 1 · 计划循环 —— 发散设计 → 红队 → 冻结

**本质**：在信息不全下把"研究直觉"变成**去风险、可执行、已预注册成功判据**的计划。失败模式是**看不见的设计缺陷**（做错问题 / 不可行 / 设计性数据泄漏 / 不可证伪或过强的 claim / 预算不现实 / 缺基线消融 / 隐藏假设 / 伦理问题），一旦漏过就**白烧算力**。
**为何不用通用套子**：单线"产出→评审→修订"易陷入对单一方案的自我辩护。计划环要**并行出多个候选方案 → 独立红队各自找茬 → 裁判择优 → 冻结**——由控制层裁定哪个方案胜出，而非设计者自评。

| 角色 | 职责 | 为何适配本任务 | 委托 | 落点 |
|---|---|---|---|---|
| 文献侦察（RQ Architect） | 摸清现状 / gap / 现成基线与数据 / 新颖性；提出 2–4 个**候选研究问题 ＋ 成功判据** | 唯有足够广度才能发现"问题已被解决 / 数据不可得 / 隐藏假设" | `deep-research`（lit-review / systematic review〔PRISMA〕/ 3W 模式，内含 research-question、source-verification 子 agent） | `docs/records/PAPER_NOTES.md`、`docs/records/EVIDENCE.md`（背景，等级 1–2） |
| 研究架构师 | 对每个候选 RQ 拆成可执行步骤：实验设计、数据划分、指标口径、条件覆盖、可复现要素、算力/时间预算 | 把设计落成 workflow 任务，在写码前暴露可行性瓶颈，并把 claim 映射到目标证据等级 | `research_architect_agent`（插件）/ `deep-research`（methodology）＋ 参 `configs/task_types/<任务类型>.md` | `docs/records/TASK_BRIEF.md`（候选计划） |
| 红队（魔鬼代言＋方法学） | 对每个候选**独立找茬**：claim 可否证伪、有无泄漏、指标口径、条件是否饱和、隐藏假设、预算现实性、伦理 | 独立多视角抓人眼漏掉的设计缺陷（如指标定义里的训练-测试泄漏）；多 persona 防共识偏置 | `deep-research`（devil's-advocate、ethics 子 agent）＋ `academic-paper-reviewer`（methodology-focus 模式），**各 persona 分开打分** | `docs/records/EXPERIMENT_LOG.md`（每候选 critical/major/minor） |
| 综合裁判 | 跨候选比对：找矛盾、辨真伪权衡、必要时提混合/分阶段方案，给出**胜出方案 ＋ 理由 ＋ 红队问题的处置** | 防在等价方案间反复横跳；确保胜方显式回应每条红队 critical | `synthesis_agent`（插件，跨源整合/矛盾/gap）＋ judge-panel 聚合 | `docs/records/TASK_BRIEF.md`（选定方案＋理由） |
| 冻结官（预注册） | 锁定 claim 定义、**每条 claim 目标证据等级**（匹配结论强度，RESEARCH_RULES 第 4 节）、成功判据、预登记基线/消融、追踪中的假设；冻结点记 commit hash＋时间 | 防执行期"事后改 claim / 调目标等级"漂移；冻结是**人审关卡**，agent 不得自批 | `academic-paper-reviewer`（calibration 自检清单）＋ **人审** | `docs/records/TASK_BRIEF.md`（冻结块）、`docs/records/EVIDENCE.md`（claim→目标等级，定稿） |

**内部 workflow（一轮）**

```text
  ① 文献+可行性扫描  ──single──▶  2–4 个候选 RQ + 成功判据（等级 1–7）
        │
  ② 设计候选计划   ──parallel-fanout──▶  每个 RQ 一份完整可执行计划（数据划分/指标/基线/预算/风险）
        │
  ③ 红队对抗     ──adversarial-verify──▶  各 persona 独立给每个候选打 critical/major/minor
        │                                                            │ 红队 critical 未清
  ④ 矛盾归并 + 评审团择优  ──judge-panel──▶  胜出方案 ＋ 权衡留痕 ◄────────┘（回 ②，重设计/补方案）
        │
  ⑤ 冻结 + 预注册  ──human-gate──▶  锁 claim/等级/判据；人审通过 → 出环 1 进入环 2
```

**收敛标量**：剩余工作量 = 未被计划缓解的红队 critical/major 数 ＋ 被判不可达的目标等级数 ＋ 冻结时仍含糊的 claim 定义数；逐轮单调下降，目标降到 0（或仅余有据缓解的 minor）。
**终止 / 升级**：默认 **≤ 4 轮**；连续 2 轮剩余工作量降幅 < 2 → **PLATEAU**，停并上报（多半要先补调研）；共识认定某目标等级不可达（如外部数据拿不到）→ **BLOCKED**，升级人审重定目标；满 4 轮未收敛 → 强制停、交当前最佳计划＋未决项由人定夺。
**本环反模式**：① 设计者偏爱方案默认胜出（须由独立裁判按"红队 critical 最少＋等级最可达"裁定）；② 冻结后私改 claim/等级（属"重大变更"，须回环 1 人审，§4）；③ 红队两 persona 100% 同评（评审可疑，加第三视角或人审）；④ 留下**不可证伪**的 claim（如"预期更鲁棒"——须改成"在 `<holdout>` 上 `<指标>` ≥ `<阈值>`"）；⑤ 证据目标与结论强度不匹配（开发集等级 4 却下"鲁棒"结论）；⑥ 设计性泄漏（用测试统计做预处理）；⑦ 预算-现实差（"1 卡 1 周训 1B 模型"应判 BLOCKED 而非小问题）。

> **推荐起手式 · Baseline 先行**：确定主题后，本环优先确立一个可信 baseline（复用开源实现或自训），以其为标尺，再针对 baseline 的**具体不足**或一处**方法学创新**设计候选方案——而非泛泛"做得更好"。强烈推荐、非强制，细则见 `RESEARCH_RULES.md` 第 6 节。

---

## 2. 环 2 · 执行循环 —— 机械收敛 → 对抗核验

**本质**：沿冻结计划反复实验，使每条核心 claim 的**实际证据等级 ≥ 目标等级**（1–9，见 `docs/records/EVIDENCE.md`）。与计划/写作的"主观评审"根本不同——执行是**机械收敛**：以 git commit 为原子单位，靠固定脚本取机械化指标，靠独立核验闸住"升等级"。失败模式很具体：实现 bug、实操泄漏、未采样/造假指标、回归、不可复现、停滞/卡死、用开发集过度声称。
**为何不用通用套子**：执行的收敛是**可计算的标量**（未覆盖条件、失败实验、未核验指标）单调下降，不是主观质量判断；"评审"环节是**对抗核验**——独立质疑者试图**证伪**某结果，过不了关 claim 才允许升级。

| 角色 | 职责 | 为何适配本任务 | 委托 | 落点 |
|---|---|---|---|---|
| 实现者 | 写码/数据/配置；**每轮一处原子改动**；先 commit 再跑；异常时假设驱动调试 | 工程活只有"原生代码＋版本控制"才能表达原子改动与 `git revert` 可逆 | `src/`＋`scripts/`＋git（第三方放 `third_party/`）；小批量先验 `CLAUDE.md` 第 14.3 节 | `outputs/<实验>/<run>/`、commit |
| 哨兵 | 长跑期 ~30 min 巡检，查代码/agent/网络三类卡死（无输出、`NaN`、资源饱和、checkpoint 不落）；阶梯处置 | 执行算力密集，绝不能静默失败或死等 | `CLAUDE.md` 第 14.2 节哨兵；`Monitor`/定时自检 | `docs/records/EXPERIMENT_LOG.md`（卡死与处置） |
| 结果审计 | 每轮跑完：收 artifact，核可追溯（commit/seed/config/命令）、查泄漏（划分隔离、预处理只用 train、holdout 未被调）、指标一致性；汇成逐轮研究报告；缺采样/缺 artifact 标 `NOT VERIFIED` | 原始指标须**机械化复核**后才能进 claim；审计**独立于实现者**，只验不改 | 固定评估脚本＋`docs/records/RESULT_AUDIT.md` 清单 | `docs/records/RESULT_AUDIT.md`、`docs/records/EVIDENCE.md`、`reports/round-<NN>_*.md` |
| 对抗核验 | claim 升级前，派 N 个独立质疑者试图**证伪**："指标是不是伪影？比较公平吗？换 seed/规模/OOD 还成立吗？基线同等调优了吗？"任一证伪成立则该 claim `BLOCKED` | 机械指标可能"形式正确、实质错误"（泄漏/挑样/噪声）；把同行质疑**前置**到投稿前 | 原生 Workflow **adversarial-verify**（N 质疑者）＋ `academic-paper-reviewer`（methodology-focus / re-review）＋ `deep-research`（fact-check） | `docs/records/EXPERIMENT_LOG.md`（证伪尝试与结论） |

> 条件覆盖清单（基线/消融/seed/规模/OOD/泄漏控制/算力）与**饱和停**（loop-until-dry：连续 3 轮无新条件即停）由**控制层**维护、记入 `docs/records/TASK_BRIEF.md`，不另设常驻 agent——它属收敛/终止判定（§4），对应下方流程第 ⑪ 步。

**内部 workflow（一轮，以 git commit 为原子单位）**

```text
  ① 选焦点·原子改动 ─▶ ② 小批量先验(等级3闸) ─▶ ③ commit＋冻结点(hash/seed/config/env)
                                │失败回①
                                ▼
  ④ 运行〔哨兵 30min 巡检·先 commit 再跑〕 ──pipeline──▶ ⑤ 收 artifact＋机械指标 ─▶ ⑥ 结果审计(可追溯/泄漏/一致)
        │卡死/NaN→重试·回滚·上报                                                        │未过→标 NOT VERIFIED 回①
        ▼                                                                              ▼
  ⑦ 统计回归($U$检验＋效应量＋噪声带) ─▶ ⑧ keep/discard〔变差/崩溃即 git revert，负结果归档〕
                                                        │ keep
                                                        ▼
  ⑨ 对抗核验〔N 质疑者并行试证伪〕 ──adversarial-verify──▶ ⑩ 升证据等级〔未被证伪＋审计过；≥7 须人审〕
        │任一证伪→BLOCKED 回①/升级环1                                  │
        ▼                                                              ▼
  ⑪ 条件饱和检查〔3 轮无新条件即停〕 ──loop-until-dry──▶ ⑫ 出环判据：剩余工作量=0 ＋人审 → 进入环 3
        │未饱和→回①                                              │未达标且计划仍成立→回①；计划不足→升级环 1
```

**执行细则（复用现有规则、不重复造）**：每轮**改一处** → 小批量先验（第 14.3 节）→ 运行（算力高效 14.1 / 哨兵 14.2，**先 commit 再跑**）→ 机械化指标 → keep/discard（`git revert`）→ 留痕升级。配套：**假设驱动调试**（异常时一条可证伪假设＋具名技术）、**回归统计检验**（声称提速/无损失用 Mann-Whitney $U$ 检验＋效应量＋噪声带，第 8 节；未真实采样标 `NOT VERIFIED` 不得虚构 $p$ 值）、**实验条件覆盖**（基线/消融/seed/规模/OOD/泄漏控制/算力）。
**收敛标量**：剩余工作量 = 未达标 claim 数 ＋ 失败/回滚实验数 ＋ 未覆盖条件数 ＋ 被证伪/`BLOCKED` claim 数 ＋ 未决泄漏/指标异常数；逐轮单调下降。
**终止 / 升级**：默认 **≤ 8 轮**；剩余工作量连续 ≥ 3 轮不降 → **PLATEAU**；关键证据不可得（如 holdout 仅在开发集涨，疑泄漏；外部数据缺）→ **BLOCKED**；单次运行超时上限即杀并回滚。**不得降标收尾**——降目标等级属"重大变更"须人审；升到等级 ≥ 7 须人审；计划本身不足（设计错/目标不可达）→ **回环 1 的②** 重规划。
**本环反模式**：批量多改（破坏原子性/不可逆）；开发期在 holdout/外部集上跑（毁冻结纪律）；不审计就信指标；对"显然的提升"跳过对抗核验；单 seed 指标升到等级 ≥ 5（须 `NOT VERIFIED`/补采样）；删负结果（应归档）；用开发集结论过度声称"鲁棒/SOTA"；基线与本方法用不同评估脚本；首次成功即宣称收敛（须查饱和）；卡 ≥ 3 轮不升级（设计可能不可行，立刻回环 1）。

---

## 3. 环 3 · 写作循环 —— 并行起草 → 评审团 → 修订

**进入条件**：环 2 证据经**人审确认达到科研目标**。
**本质**：把**已验证证据**转成可投稿论文——结构化起草 + 模拟同行评审 + 据评审修订，全程**不得越证据等级**。失败模式：claim 越级（证据不够却写"鲁棒/泛化/SOTA"）、引用造假/张冠李戴、并行分章导致记号/术语/叙事不一致、缺 limitations/负结果、评审暴露证据缺口（→回执行环）、过度修订空转。
**为何不用通用套子**：写作可**并行分章**（fan-out 缩短 wall-clock），评审须**多视角评审团**（judge-panel）而非单一自评，且贯穿**证据忠实**这条与计划/执行都不同的主线。

| 角色 | 职责 | 为何适配本任务 | 委托 | 落点 |
|---|---|---|---|---|
| 大纲架构师 | 出章节结构 ＋ **证据映射**（每节挂哪些 claim/artifact/等级）；大纲先过人审再写 | 先定骨架与证据映射，从源头堵住"写出无证据支撑的段落" | `academic-paper`（`/ars-outline`） | 稿件大纲、`docs/records/PAPER_NOTES.md` |
| 分章起草者 | **分章并行**起草（intro/related/method/experiments/results/discussion），每章只引 `docs/records/EVIDENCE.md` 已验证证据 | 各章相对独立，并行 fan-out 缩短 wall-clock | 原生 Workflow **parallel-fanout** ＋ `academic-paper`（`/ars-full`） | 稿件 |
| 一致性编辑 | 缝合各章、统一记号/术语/叙事线、消矛盾、补 limitations | 并行起草必然留接缝与记号冲突，需专门整合 | `synthesis_agent`、`report_compiler_agent`（插件） | 稿件 |
| 证据/引用核查 | 自检：每个数字/图/表↔`EVIDENCE.md` 且**等级匹配**；引用**真实可核验、零编造** | 写作最大造假风险在 claim 越级与引用编造，须独立核查 | `academic-paper`（`/ars-citation-check`）＋ 证据绑定自检清单 | `docs/records/PAPER_NOTES.md` |
| 评审团 | **5 视角**评审（EIC＋3 审稿人＋魔鬼代言人），盲化去偏，出 critical/major/minor 清单 | 模拟真实投稿评审，多视角找问题胜过单评 | `academic-paper-reviewer`（`/ars-reviewer`） | `docs/records/EXPERIMENT_LOG.md`（问题清单） |
| 修订者 | 据清单逐条修订、回填、改稿，附 response letter；**re-review** 核对上轮意见是否落实 | 修订须对照清单逐条闭环；re-review 防"假装改了" | `academic-paper`（`/ars-revision`）＋ reviewer 的 re-review 模式 | 稿件、`docs/records/PAPER_NOTES.md` |

**内部 workflow（一轮）**

```text
  ① 大纲 + 证据映射(/ars-outline) ──human-gate──▶ 大纲过审再写
        │
  ② 分章并行起草 ──parallel-fanout──▶ 各章只引 EVIDENCE.md 已验证证据
        │
  ③ 整合一致性(synthesis_agent) ─▶ ④ 自检：证据绑定 + 引用核查(/ars-citation-check，零编造)
        │
  ⑤ 评审团(/ars-reviewer，5 视角盲化) ──judge-panel──▶ critical/major/minor 清单
        │                                                          │ 未达标且未到上限
  ⑥ 据清单修订(/ars-revision) + re-review 核对 ◄──pipeline─────────┘（证据缺口 → 升级环 2 补实验）
        │ 评审无 critical ＋ 引用全通过 ＋ 数字全可追溯
  ⑦ 定稿 ──human-gate──▶ 完成（必要时 /ars-format-convert 转 LaTeX/DOCX）
```

> 端到端可直接用 `academic-pipeline`（research→write→integrity→review→revise→…→finalize）兜整条写作-评审-修订链；本环把它当**可选总流水**，但出环判据与人审仍按本协议。
> 逐轮研究报告（`reports/round-<NN>_*.md`）归**环 2**产出；本环只产稿件与评审/修订记录。

**收敛标量**：剩余工作量 = 未决 critical/major 评审项 ＋ 引用错误数 ＋ 未绑定到 `EVIDENCE.md` 的数字 ＋ 越级 claim 数；逐轮单调下降。
**终止 / 升级**：默认 **≤ 5 轮** 或连续 2 轮无实质改进 → 停、上报当前稿＋未决项；评审暴露**证据缺口** → **回环 2** 补实验（保留写作状态，补完再回写作）。
**本环反模式**：claim 越级（证据等级不够却写"鲁棒/泛化/SOTA/临床可用"——RESEARCH_RULES 第 1/4 节）；编造或张冠李戴引用；并行章节记号/术语/叙事打架未整合；缺 limitations / 不报负结果；把 `PENDING`/`NOT VERIFIED` 写成既成结论；为改而改的空转修订（须对照评审清单逐条闭环）。

---

## 4. 三环共用：交接契约 · 人审 · 升级 · 防卡死 · 反滥用

**① 环间交接契约**（每环须向下一环交出**带出处的产物＋状态**，而非只交内容）：
- 环 1 → 环 2：**冻结的计划**（`docs/records/TASK_BRIEF.md`）＋ 每条 claim 的**目标证据等级映射**（`docs/records/EVIDENCE.md`）＋ 预登记的基线/消融/条件清单。
- 环 2 → 环 3：**达标的证据账本**（`docs/records/EVIDENCE.md`，各 claim 实际等级 ≥ 目标）＋ `results/` 整理结果 ＋ **负结果归档**（`experiments/records_archive/`）。
- 环 3 → 完成：定稿稿件 ＋ 可复现声明 ＋ response letter。

**② 三道人审关卡（出环必经，agent 不得自批）**：环 1 计划冻结、环 2 证据达标判定、环 3 论文定稿。增删核心 claim / 改目标证据等级 / 换目标期刊 / 改冻结约束属**"重大变更"**，一律须人审；冻结后再改冻结产物须重新人审。
> 注意区分：环 2 流程第 ⑩ 步"claim 升到证据等级 ≥ 7 须人审"是**证据纪律检查点**（防越级），**不是第 4 道出环关卡**——出环关卡始终只有上述三道；但它确实增加了人工触点，长项目要预留这部分人审工作量。

**③ 环间升级回路（显式、保状态、不丢进度）**：
- 执行发现**计划本身不足**（设计错 / 目标不可达 / 假设不成立）→ 回**环 1 ②**：记升级原因与触发 claim，存好执行 artifact，回计划"设计/修订"步；修订完带新计划回执行，**从中断处续跑**，不重跑无关阶段。
- 写作评审暴露**证据缺口**（如 C2 需等级 7、现 5）→ 回**环 2**：记缺口，存好写作稿，回执行针对性补实验；补达标后回写作续修。
- 升级须由**收敛裁判/评审**（非 agent 随口）基于已观察证据触发；执行未真跑就喊"设计坏了"属过早升级，不予受理。

**④ 统一收敛标量（防空转）**：**剩余工作量** = 未达标 claim ＋ 失败/回滚实验或测试 ＋ 未覆盖条件 ＋ 未决 critical（计划红队 / 评审）＋ 引用错误 ＋ 证据可追溯缺口。**逐轮须单调下降**；某轮持平或上升即触发复查。各环出环 = 本环相关项归零 ＋ 该环判据满足 ＋ 人审。

**⑤ 防卡死与终止**：每环有**最大轮次**（4 / 8 / 5）与 **PLATEAU**（剩余工作量连续 ≥ 3 轮不降）/ **BLOCKED**（关键产出不可得）两种终止态；三环都是长自主执行，按 `CLAUDE.md` 第 14.2 节设**监察者**（~30 min 巡检，盯代码/agent/网络三类卡死），每个长步骤设超时上限，停滞即阶梯处置（重试 → 重启/回滚 → 换法 → 上报），**绝不让循环长期卡在某处不前进**。PLATEAU/BLOCKED 不在环内硬扛——带完整上下文升级人审。

**⑥ 反滥用闸门**：不得在环内私自降 claim 强度 / 降目标等级（须走"重大变更"人审）；目标证据等级须匹配结论强度（强结论 ≥ 7，临床/泛化类须外部或独立证据，RESEARCH_RULES 第 4 节）；统计量未真实采样标 `NOT VERIFIED` 不得虚构；证据不足的产物即使"读着完整"仍 `PENDING`；缺证据不得编造补齐（RESEARCH_RULES 第 1 节）；交接前做**反造假核对**：每个数字有对应 artifact＋可追溯，无 claim 越级，无静默改目标等级。

---

## 5. 循环状态表（紧凑，逐轮覆盖更新）

> 单一状态视图放本表；逐轮明细记 `docs/records/EXPERIMENT_LOG.md`，claim→证据映射记 `docs/records/PAPER_NOTES.md`，证据等级记 `docs/records/EVIDENCE.md`，条件清单记 `docs/records/TASK_BRIEF.md`。本模板内全为占位符。

| 项 | 值 |
|---|---|
| 当前环 / 轮次 | 环 1 计划 · 第 0 / 4 轮（INCOMPLETE） |
| 论文工作标题 | `<论文标题>`（TBD） |
| 环 1 出环 | 计划无 critical ＋ 冻结预注册 ＋ 人审（PENDING） |
| 环 2 出环 | claim 实际等级 ≥ 目标 ＋ 人审；剩余工作量 = TBD（PENDING） |
| 环 3 出环 | 评审无 critical ＋ 引用全通过 ＋ 定稿人审（PENDING） |
| 本轮聚焦 | `<本轮 阶段 / claim / gap>`（TBD） |
| 升级标记 | `<无 / 执行→计划 / 写作→执行>`（TBD） |

**各 claim 状态**

| claim | 目标等级 | 实际等级 | 支持 artifact | 状态 |
|---|---|---|---|---|
| C1 | `<7>` | TBD | `<路径/ID>`（TBD） | PENDING |
| C2 | `<6>` | TBD | `<路径/ID>`（TBD） | PENDING |

---

## 关联文档

- Agent 行为总则：`CLAUDE.md`（第 6 负结果 / 7 可复现 / 8 冻结测试·回归统计 / 9 代码编辑 / 14 执行效率·哨兵·小批量 / 15 ultracode·Workflow / 17 科研技能）
- 科研纪律细则：`docs/rules/RESEARCH_RULES.md`（证据等级 ↔ 结论强度、反造假、冻结纪律）
- 论文 claim→证据映射：`docs/records/PAPER_NOTES.md` ・ 证据账本：`docs/records/EVIDENCE.md` ・ 实验流水：`docs/records/EXPERIMENT_LOG.md` ・ 结果审计：`docs/records/RESULT_AUDIT.md` ・ 任务简报/条件清单：`docs/records/TASK_BRIEF.md`
- 任务类型配置：`configs/task_types/paper_writing.md`、`configs/task_types/software_engineering.md`
- ARS 技能：`deep-research`（计划环调研/红队）、`academic-paper`（写作环起草/修订/引用核查）、`academic-paper-reviewer`（计划与写作环评审）、`academic-pipeline`（写作环可选总流水）；用法纪律见 `CLAUDE.md` 第 17 节。
