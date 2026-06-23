# EXPERIMENT_LOG.md —— 实验流水

> 本文件用途：逐次记录实验运行的**过程**——运行前的计划与运行后的实际情况。
> 本文件是**可追加**的流水账：只增不删；失败运行同样保留。
> **临时记录、中间想法、单次运行的过程笔记一律放本文件，而不要放进 `MEMORY.md`。** `MEMORY.md` 仅沉淀长期、稳定、可复用的经验。
> 本模板于 2026-06-19 创建。模板内不含任何真实结果，下方骨架为全占位符示例，整体标 INCOMPLETE。

---

## 0. 与其他文件的分工

- **Agent 行为规则** → `CLAUDE.md`
- **当前项目事实** → `docs/records/PROJECT.md`
- **科研证据（结论账本）** → `docs/records/EVIDENCE.md`
- **实验流水（本文件）** → `docs/records/EXPERIMENT_LOG.md`
- **结果审计** → `docs/records/RESULT_AUDIT.md`
- **长期经验** → `MEMORY.md`（**不要**把临时实验笔记写进这里）

实验产出的可追溯结论登记到 `docs/records/EVIDENCE.md`；本文件保留产生该结论的运行上下文。

---

## 1. 运行前应记录

启动任何实验前，先把下列内容写成一条记录（未知填 TBD，未完成标 INCOMPLETE）：

- **实验目的**：本次运行想回答什么问题。
- **假设**：预期结果是什么（对应证据等级 1–2，参见 `docs/records/EVIDENCE.md` 第 1 节）。
- **命令**：计划执行的完整命令行。
- **配置路径**：所用配置文件（如 `configs/task_types/<任务类型>.md` 或具体 config）。
- **数据划分**：train / validation / test 的划分；是否涉及 holdout / `<外部测试集>`。
- **输出目录**：`<输出目录>`，预期产物落盘位置。
- **预期 artifact**：将生成哪些文件（指标文件 / 日志 / checkpoint / 图）。
- **预计时间**：预估运行时长（TBD 可）。
- **硬件**：计划使用的硬件（GPU/CPU 型号、数量、显存等；未知填 TBD）。

> 冻结测试纪律：若本次涉及 holdout / 外部测试集，须先确认协议/脚本/模型/阈值/配置已冻结，且不在其上调参；否则在记录中显式标注泄漏风险。

---

## 2. 运行后应记录

运行结束（或中断）后补全：

- **实际命令**：真正执行的命令行（与计划不同处要写明）。
- **起止时间**：实际开始 / 结束时间戳。
- **checkpoint 路径**：产出的 `<模型权重路径>`（大文件用 manifest + checksum）。
- **指标文件**：结果指标所在文件路径。
- **日志**：stdout/stderr 或日志文件路径。
- **结果摘要**：一句话结论 + 关键数值（不确定标 PENDING / NOT VERIFIED）。
- **失败模式**：报错、发散、NaN、数据问题、指标不一致等（**负结果必须保留**）。
- **调试假设（实验异常时）**：逐条记 `调试假设 ｜ 技术（二分 / 差分 / 最小复现 / bisect / 溯因）｜ 判定（证实 / 证伪 / 不确定）｜ 证据 file:line`（负结果保留，勿删）。
- **下一步**：后续动作或待办（PENDING）。

> 未完成的运行整条标 **INCOMPLETE**，不要删除；恢复后追加续跑记录。
> 产生了可追溯结论的，记得在 `docs/records/EVIDENCE.md` 追加对应证据行。

---

## 3. 空白实验记录条目骨架（全占位符，复制后填写）

> 下方为模板示例，整体标 **INCOMPLETE**，不代表任何真实运行。

### 实验 ID：`EXP-<编号>`（INCOMPLETE，示例）

**——— 运行前 ———**

- 实验目的：`<研究目标>` 下验证 `<TBD>`（INCOMPLETE）
- 假设：预期 `<主要指标>` 为 `<TBD>`（证据等级 1，参见 docs/records/EVIDENCE.md）（PENDING）
- 计划命令：`<Python解释器> <主脚本> --config <配置路径> --seed <seed> --output <输出目录>`（TBD）
- 配置路径：`<配置路径>`（TBD）
- 数据划分：train / validation / test = `<TBD>`；holdout = `<TBD>`；外部 = `<外部测试集>`（TBD）
- 输出目录：`<输出目录>`（TBD）
- 预期 artifact：`<指标文件>` / `<日志文件>` / `<模型权重路径>`（PENDING）
- 预计时间：`<TBD>`
- 硬件：`<TBD>`

**——— 可复现锚点 ———**

- commit hash：`<commit hash>`（TBD）
- 环境：`<Python解释器>` / `<Conda环境>`（TBD）
- seed：`<seed>`（TBD）
- 数据划分快照：`<数据划分manifest路径>`（TBD）
- 配置：`<配置路径>`（TBD）
- 关键参数：`<TBD>`（学习率/批大小/轮数等，TBD）

**——— 运行后 ———**

- 实际命令：`<TBD>`（INCOMPLETE）
- 起止时间：开始 `<TBD>` / 结束 `<TBD>`（INCOMPLETE）
- checkpoint 路径：`<模型权重路径>`（manifest + checksum：`<TBD>`）（PENDING）
- 指标文件：`<指标文件>`（PENDING）
- 日志：`<日志文件>`（PENDING）
- 结果摘要：`<TBD>`（PENDING / NOT VERIFIED）
- 失败模式：`<TBD>`（保留，勿删）（PENDING）
- 下一步：`<TBD>`（PENDING）
- 是否已登记到 docs/records/EVIDENCE.md：否（INCOMPLETE）

---

## 4. 提醒

- 临时记录放本文件，不放 `MEMORY.md`。
- 失败运行与负结果一律保留，可归档不可删除。
- 任何不可逆操作（删除日志/指标/checkpoint）需明确指令，优先归档。
