# TEMPLATE_CHANGELOG.md —— 模板变更日志

> 用途：记录**本科研项目模板本身**的演进（目录结构、规则、占位文档、配置骨架等），而非某个具体项目的实验进展。
> 项目级的实验流水请记入 `docs/records/EXPERIMENT_LOG.md`；长期经验请记入 `MEMORY.md`。
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
| 2026-06-24 | **RESEARCH_LOOP 重设计为三个异构循环**（post-v0.4.0）：把原"三环同构（同一个产出→评审→修订套子）"改为**各贴合任务本质的内部 workflow ＋ 适配 agent 角色**——① 计划＝多方案 fan-out → 红队对抗 → 评审团择优 → 冻结预注册；② 执行＝原子改动→小批验证→哨兵运行→结果审计→对抗核验（证伪过关才升等级）→ loop-until-dry 饱和；③ 写作＝大纲+证据映射 → 分章并行起草 → 整合 → 证据/引用自检 → 5 视角评审团 → 修订⇄复评。每角色标注委托的真实 ARS 技能/插件 agent/Workflow 模式与"为何适配本任务"；保留三道人审、环间升级、防卡死、证据等级与反造假纪律；新增 §4 环间交接契约。经 3 路对抗式复审（fit-for-task / ARS 名实 / 一致性）定稿。同步更新 `reports/README.md`、`configs/task_types/paper_writing.md` 的引用。 | 用户指出原三环太简单、不贴合"做计划/做实验/做写作"三种任务的差异；要求按各任务特性重设内部 workflow 与 agent 角色。 | 非破坏性：仅重写一份规则文档内容 ＋ 两处引用描述；文件名、三环命名（计划/执行/写作）、CLAUDE §12 接入点不变。 |
| 2026-06-24 | **里程碑 v0.4.0-template**：把含「规则 / 记录分离 + 旧布局迁移」的状态固化为标签；README 派生 / 更新示例统一改用 `v0.4.0-template`。 | 标记新布局的稳定基线，使 `bootstrap -r v0.4.0-template` 直接派生新结构、`update -r v0.4.0-template` 可迁移旧项目。 | 非破坏性：仅版本引用与标签。 |
| 2026-06-24 | **docs/ 规则与记录物理分离（BREAKING）**：把 `docs/` 拆成 `docs/rules/`（**规则文件**：`RESEARCH_RULES.md`、`RESEARCH_LOOP.md`、`TEMPLATE_CHANGELOG.md`——模板拥有、固定、仅经 `update_from_template.sh` 同步）与 `docs/records/`（**记录文件**：`PROJECT.md`、`TASK_BRIEF.md`、`EVIDENCE.md`、`EXPERIMENT_LOG.md`、`RESULT_AUDIT.md`、`PAPER_NOTES.md`——项目自有、随项目更新、同步脚本绝不覆盖）。全仓引用（`CLAUDE.md`、`README.md`、`configs/`、各子目录 README、文档互引）同步改为新路径；`CLAUDE.md` 新增 §1.1、`README.md` 新增 §4.1 阐明该分界；`update_from_template.sh` ALLOW 改为 `docs/rules/*`（并把 `TEMPLATE_CHANGELOG.md` 纳入同步）。 | 用户要求：规则文件在一个项目内固定、只随模板更新；记录文件随项目推进而变——二者物理分开，避免误改规则被同步覆盖、或把项目记录误当模板内容。 | **BREAKING**：目录结构变更。已派生的旧（扁平 `docs/*.md`）项目须用 `update_from_template.sh -r v0.4.0-template` 自动迁移（见下条），或手动 `git mv` 记录入 `docs/records/`、规则入 `docs/rules/`。 |
| 2026-06-24 | **update_from_template.sh 增加旧布局自动迁移**：检测到扁平 `docs/*.md` 时一次性迁移——记录文件 `git mv` 入 `docs/records/`（**保留项目内容**），扁平旧址规则文件 `git rm`（新版本随同步落到 `docs/rules/`）；**幂等**（已迁移则跳过）、**非破坏性**（记录只移动不覆盖）、`--dry-run` 先预览。新增可选 `--rewrite-refs`：迁移后确定性改写项目文件正文里 `docs/<名>.md` → `docs/{rules,records}/<名>.md`（触碰项目内容，默认关闭）。`bootstrap_new_project.sh` 派生信息写入路径改为 `docs/records/PROJECT.md`。 | 让早于 v0.4.0 派生的旧项目能安全、可 review 地迁移到新布局，同时不丢失已填写的记录内容。 | 非破坏性增强（对脚本而言）：默认仅在检测到扁平布局时迁移；新布局项目再次运行为幂等空操作。 |
| 2026-06-21 | **README 增加「建议安装的技能 / 工具」（§5.4）**：列出 ARS（academic-research-skills，科研全流程，CC-BY-NC）与 **codegraph**（代码知识图谱 MCP，MIT，本地 SQLite+FTS5，亚毫秒查询、文件 watcher 增量同步，省 token / 工具调用；需 `codegraph init` 建索引）——含 codegraph 能力要点、主要工具与安装。`CLAUDE.md` 第 9 节加"编辑前先用 codegraph 理解结构 / 影响面"；`.gitignore` 忽略 `.codegraph/`。 | 把项目推荐的增强工具与 codegraph 特点写入文档。 | 非破坏性：仅新增文档与忽略项；工具为可选增强、未装则降级手工。 |
| 2026-06-21 | **里程碑 v0.3.2-template**：固化防卡死监察者规则（§14.2）为标签；README 派生 / 更新示例统一改用 `v0.3.2-template`。 | 标记含监察者规则的稳定基线。 | 非破坏性：仅版本引用与标签。 |
| 2026-06-21 | **哨兵升级为防卡死监察者**：把 `CLAUDE.md` 第 14.2 节从"长任务哨兵"扩为**监察者**角色——定时巡检（默认约 30 分钟、可调），覆盖三类卡死来源（代码/任务逻辑、agent/编排逻辑、网络），每个长步骤设超时上限，停滞即按阶梯快速处置（重试 → 重启/回滚 → 换法 → 上报），不无限等待；`RESEARCH_LOOP.md` 第 4 节挂上"长自主执行须设监察者防卡死"。 | 用户反馈 agent/程序常莫名卡死（代码/代理/网络），需定时监察、尽快处理，不让其长期停滞。 | 非破坏性：扩写既有 §14.2 + 循环一条；复用现有规则。 |
| 2026-06-21 | **里程碑 v0.3.1-template**：将含 `--scaffold` 的最新脚本固化为标签；README 派生 / 更新示例统一改用 `v0.3.1-template`，使 `bootstrap -r v0.3.1-template` 派生的项目直接带 `--scaffold` 能力。 | 把"带 --scaffold 的脚本"固化为可派生的稳定基线。 | 非破坏性：仅版本引用与标签。 |
| 2026-06-21 | **update_from_template 增加 `--scaffold`**：可选补缺新目录脚手架（`src/`、`third_party/`、`results/`、`reports/`、`configs/experiments/`、`data/{raw,processed,validation}/` 的约定文件），语义 = **只新建缺失、绝不覆盖已有**（保护项目已定制内容），幂等；让旧项目也能补上新目录结构。已实测：补缺 10 个、规则同步、项目内容零改动、已定制文件不被覆盖。README §5.3 同步说明。 | 已派生的旧项目无法靠规则同步获得新目录；提供安全的补缺机制。 | 非破坏性：新增可选 flag；默认行为不变。 |
| 2026-06-21 | **目录结构扩展（执行生命周期分类）**：新增 `src/`（自有源码）、`third_party/`（第三方/下载代码，不入 git）、`configs/experiments/`（单次实验配置）、`data/{raw,processed,validation}/`、`results/`（整理后结果/验证结果，轻量入 git）、`reports/`（每轮研究报告 + `archive/` + `SUMMARY.md` 定期归档总结）；规范 `outputs/<实验>/<run>/` 中间产物结构。各新目录配 README 约定；更新 README 目录树/职责表、`.gitignore`（third_party 忽略 + results 轻量入库例外）、`RESEARCH_LOOP.md` ④⑤ 落点、`CLAUDE.md` 第 9/18 节。 | 用户要求把执行过程各产物（代码/第三方/中间结果/验证数据/验证结果/每轮报告/报告归档总结）各归其位，结构更清晰。 | 非破坏性：仅新增目录与登记；既有文件 / 编号不变。 |
| 2026-06-21 | **新增模板规则更新脚本**：`scripts/update_from_template.sh` —— 给"已派生、在做的项目"把模板规则文件（`CLAUDE.md`、`RESEARCH_RULES.md`、`RESEARCH_LOOP.md`、`configs/task_types`、脚手架脚本）更新到指定模板 ref，**只覆盖模板拥有的文件、绝不触碰项目自有内容**（PROJECT/EVIDENCE/实验/数据/结果）；带 `--dry-run`、脏树守卫、不自动提交、写 `.template-sync` 记录来源。配套纪律：项目特异规则写 `docs/PROJECT.md` 而非改 `CLAUDE.md`。已实测：规则更新、项目内容零改动、bash 3.2 空数组兼容。 | 派生项目是独立仓库、不会自动跟随模板；提供安全、可 review 的规则同步机制。 | 非破坏性：新增脚本 + README / scripts 登记。 |
| 2026-06-21 | **RESEARCH_LOOP 扩为三个串联循环**：在原"两环"前拆出独立的**环 1 计划循环**（调研 → 设计计划 → 独立 agent 审查计划找问题 → 修订 → 再审，迭代至过审），与**环 2 执行循环**（执行〔写码·测·跑·查〕→ 结果 → 判断达标 / 是否继续；未达标继续执行，计划不足则回环 1 重规划）、**环 3 写作循环**（初稿〔Workflow〕→ 审稿 ⇄ 修订 → 定稿）串联。三环同构（产出 → 独立评审找问题 → 修订 → 迭代至无 critical ＋ 人审），各有最大轮次（4/8/5）与终止条件，含环间升级回路（执行发现计划不足→回环 1；审稿发现证据缺口→回环 2）；执行细则 / 统计回归 / 假设调试 / 条件覆盖 / 反滥用纪律归入对应环。 | 用户指出"计划阶段本身也应是设计→审查→修订的迭代循环"——整个项目=三个独立循环。 | 非破坏性：重组同一协议文档；文件名与接入点（CLAUDE 第 12/18 节、paper_writing）不变。 |
| 2026-06-21 | **bootstrap 身份检查前移**：把 git 身份校验移到开跑前（经模板仓库查有效身份），未配身份时**快速失败、不再留下半成品目录**（此前在 `git init` 之后才报错，会留下已解压但未提交的目录）。 | 进一步提升一键派生健壮性。 | 非破坏性：仅校验时机提前；对已配身份者行为不变。 |
| 2026-06-21 | **修复 bootstrap 脚本**：① 取值型参数（`-n/-d/-r/-t/--remote`）缺值或误吞下一个 flag 时清晰报错（此前 `-n -r` 会静默把 `-r` 当项目名）；② 派生信息改记 `${REF}^{commit}` 的提交 hash（注解标签也记其指向的 commit，而非标签对象 hash），更直接可追溯。 | 提升一键派生的健壮性与来源可追溯精度。 | 非破坏性：仅脚本健壮性与记录精度改进；对正确用法行为不变。 |
| 2026-06-21 | **RESEARCH_LOOP 重构为显式两环迭代**：把循环重写成可视化的两个串联迭代环——环 A 研究环（① 深度研究 → ② 计划 → ③ 执行〔写码·测数据·运行·检查〕→ ④ 结果 → ⑤ 报告 → ⑥ 判断达标？未达标回 ② 更新计划再迭代，达标出环）、环 B 写作环（⑦ 初稿〔用 Workflow〕→ ⑧ 审稿提问 → ⑨ 修订 → 反复迭代 → ⑩ 定稿），含 ASCII 流程图、两环各自最大轮次（A≤8 / B≤5）与终止条件（PLATEAU/BLOCKED/无改进）、三处人审关卡；原执行细则 / 统计回归 / 假设调试 / 条件覆盖 / 反滥用纪律保留并归入对应阶段。 | 用户指出"看不见迭代"——把迭代过程显式化为可读的阶段流与回环（research→plan→execute→result→report→judge 与 draft→review→revise 两个闭环）。 | 非破坏性：重组同一协议文档；文件名与接入点（CLAUDE 第 12/18 节、paper_writing）不变。 |
| 2026-06-20 | **借鉴 autoresearch 子命令（精选 4 项）**：① 回归统计检验（`CLAUDE.md` 第 8 节 + `RESULT_AUDIT.md` 审计清单：N≥7 采样 + Mann-Whitney U + 效应量 + 噪声带，仅 green→red 计回归，未真实采样标 NOT VERIFIED 不得虚构）；② 假设驱动调试（`RESEARCH_LOOP.md` 第 3 节 + `EXPERIMENT_LOG.md` 加"调试假设｜技术｜判定｜证据"列）；③ 实验条件覆盖清单 + 饱和停止（`RESEARCH_LOOP.md` 第 2 节，未覆盖条件数并入第 4 节）；④ 盲评去偏（第 1 节一句话）。其余 9 个子命令（plan/fix/evals/predict/probe/security/ship/learn/improve）经核查已被模板/ARS 覆盖或属软件交付专用，不采纳。 | 补齐模板此前缺失的统计检验、科学方法式调试与实验条件覆盖；复用现有规则、不新增重型命令。 | 非破坏性：扩写既有文档 + 一处审计项 + 一组日志列；不改编号。 |
| 2026-06-20 | **循环纳入代码工程**：`docs/RESEARCH_LOOP.md` 的"执行"扩展为 调研 / **代码·实验工程（写码·运行·测试）** / 写作 三类，新增「代码 / 实验工程子循环」（改一处 → 小批量先验 → 运行〔算力/哨兵〕→ 测试取机械化指标 → keep/discard〔git 回退〕→ 留痕升级证据），复用 CLAUDE.md 第 6/8/9/14 节纪律；收敛指标纳入"失败实验/测试数"；关联 `software_engineering.md`。 | 多数 claim 的证据来自实验，循环须覆盖代码工程闭环才能驱动 claim 沿证据等级爬升——这正是 autoresearch 原生强项。 | 非破坏性：扩写既有协议，复用现有规则、无重复。 |
| 2026-06-20 | **新增迭代研究循环协议**：新增 `docs/RESEARCH_LOOP.md` —— 借鉴 autoresearch 精华（每轮一处原子改动、"剩余工作量"单调下降的机械化收敛、PLATEAU/BLOCKED/预算上限三种防死循环终止态、降标即作废、人审关卡）的**薄控制层**，把执行/检查/修订委托给 ARS 技能（deep-research/academic-paper/academic-paper-reviewer/academic-pipeline），以"完成论文"为终点；接入 `CLAUDE.md` 第 12/18 节与 `configs/task_types/paper_writing.md`。 | 为"纯学术 → 出论文"任务提供简洁、可收敛、防死循环、守证据纪律的迭代闭环。 | 非破坏性：新增一份协议文档 + 三处引用登记；不改既有编号。 |
| 2026-06-20 | **新增科研技能使用规则**：在 `CLAUDE.md` 增设第 17 节「科研技能的主动使用」——本机用户级安装 `academic-research-skills`（deep-research / academic-paper / academic-paper-reviewer / academic-pipeline），遇文献/写作/评审等任务主动调用相应技能；技能产出仍须过证据与防造假纪律、环境未装则诚实降级；自有技能放 `.claude/skills/`、第三方插件不复制进仓库。原「相关文档索引」顺延为第 18 节，新任务流程加指引。 | 让科研项目主动复用已装的专用技能完成对应任务，同时不破坏证据/许可纪律。 | 非破坏性：新增一节 + 一处流程指引；CLAUDE.md 文档索引 17→18，无交叉引用断链。技能本体不入仓库。 |
| 2026-06-20 | **新增任务类型 foundation model**：经多源调研（DINOv2/v3、MAE、SAM/SAM 2、CLIP/SigLIP 2、I-JEPA、Hiera、ConvNeXt V2、LVD-142M/SA-1B 等）撰写 `configs/task_types/foundation_model.md`（沿用 7 段骨架），覆盖"预训练 FM"与"下游适配/评估"两形态，强调预训练-评测去重防泄漏、frozen vs fine-tune、linear probe/kNN/zero-shot/few-shot 标注效率、鲁棒性/OOD、校准与算力可复现；任务类型配置增至 12 个，同步更新 README 目录树与 `CLAUDE.md` 文档索引。 | 补齐"基础模型"这一主流研究形态的配置骨架，并把其特有的泄漏/协议/过度声称风险固化为纪律。 | 非破坏性：新增一个可选配置 + 两处列表登记；不影响既有配置与编号。 |
| 2026-06-20 | **新增汇报规则**：在 `CLAUDE.md` 增设第 16 节「汇报与沟通方式」——回复 / 汇报先用通俗语言给一句话结论（做了什么 / 状态 / 成败 / 下一步），再分层展开细节；诚实优先、结论绑定证据等级；原「相关文档索引」顺延为第 17 节。 | 让汇报既能快速读懂全局又可深入核对，与防造假 / 安全表达一致。 | 非破坏性：新增一节；CLAUDE.md 文档索引 16→17，无交叉引用断链。 |
| 2026-06-20 | **新增派生脚本**：`scripts/bootstrap_new_project.sh` —— 从模板指定 ref（默认 HEAD，可选 v0-template）导出已提交内容到新目录、重置为全新 git 历史、在 `docs/PROJECT.md` 写入可追溯派生信息（模板 ref + commit hash + 日期 + 项目名）；支持 `-n/-d/-r/-t/--remote/-f`，不编造项目事实、不自动 push；同步在 `scripts/README.md` 说明。 | 让"从模板派生新项目"一键完成且来源可追溯，符合可复现与防造假纪律。 | 非破坏性：仅新增脚本与说明；派生项目默认携带该脚本，可再次派生。 |
| 2026-06-19 | **新增工作强度规则**：在 `CLAUDE.md` 增设第 15 节「工作强度与编排（默认 ultracode）」——默认以 ultracode 强度工作、对实质性任务主动启用 Workflow 多 agent 编排并对抗式验证，琐碎/对话任务仍单线；原「相关文档索引」顺延为第 16 节，新任务流程加指引。 | 固化用户默认工作模式：追求最详尽、最正确的结果，主动并行编排与交叉验证，同时与证据纪律和计算效率一致。 | 非破坏性：新增一节；CLAUDE.md 文档索引 15→16，无交叉引用断链。 |
| 2026-06-19 | **新增执行纪律规则**：在 `CLAUDE.md` 增设第 14 节「执行效率与长任务稳健性」（14.1 最大计算效率原则、14.2 长任务哨兵监控、14.3 小批量先行验证），原「相关文档索引」顺延为第 15 节；在 `docs/RESEARCH_RULES.md` 增设第 15 节「执行前验证与运行监控」镜像要点并交叉引用，避免重复。 | 在不牺牲正确性 / 可复现 / 证据等级前提下提升计算效率，并通过哨兵监控与小批量先行降低长任务与大批量运行的风险与算力浪费。 | 非破坏性：仅新增规则与小节；既有编号变动仅 CLAUDE.md 文档索引 14→15，无交叉引用断链。 |
| 2026-06-19 | **初始化空模板**：建立项目根文件（CLAUDE.md、MEMORY.md、README.md、.gitignore）；建立 `docs/`（PROJECT.md、TASK_BRIEF.md、RESEARCH_RULES.md、EVIDENCE.md、EXPERIMENT_LOG.md、RESULT_AUDIT.md、PAPER_NOTES.md、TEMPLATE_CHANGELOG.md）；建立 `configs/task_types/` 下 11 个任务类型配置骨架（segmentation、completion、detection、tracking、registration、robotics、reinforcement_learning、benchmark、paper_writing、grant_writing、software_engineering）；建立 `scripts/`、`experiments/{records,records_archive}/`、`data/README.md`、`outputs/README.md`；写入基础科研规则、统一证据等级、占位文档与证据/实验记录模板。**未写入任何虚假项目事实、实验结果、数据集信息、指标、baseline 或论文结论**；除"本模板于 2026-06-19 创建"外，全部为占位符。 | 搭建可复现、可追溯、可追加的科研项目起点，统一 Agent 行为规则 / 项目事实 / 科研证据 / 长期经验四类内容的边界 | 模板首次可用；后续具体项目在此基础上填充真实内容。本条为基线，无破坏性变更。 |

---

*后续每次修改模板，请在上表顶部新增一行，遵循"日期 | 变更 | 原因 | 影响"格式。*
