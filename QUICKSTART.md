# QUICKSTART —— 5 分钟上手

> 本文件是**最短上手路径**，不替代规则。完整行为规则见 [`CLAUDE.md`](CLAUDE.md)，模板总览见 [`README.md`](README.md)。
> 本模板于 2026-06-19 创建，初始为空——满屏占位符（`<...>` / TBD / PENDING / NOT VERIFIED / INCOMPLETE）是**正常状态**，不是缺陷。

---

## 1. 派生一个新项目（在模板仓库内）

```bash
scripts/bootstrap_new_project.sh -n <新项目名> -r v0.4.2-template
```

生成在 `../<新项目名>`：剥离模板 git 历史 → 新建独立仓库 → 写入可追溯派生信息。详见 [`README.md`](README.md) 第 5.1 节。

## 2. 首次填写清单（派生后，约 10 分钟）

- [ ] 读 [`CLAUDE.md`](CLAUDE.md) 第 1–5 节，掌握行为规则与证据纪律。
- [ ] 打开 [`docs/records/PROJECT.md`](docs/records/PROJECT.md)，把已知占位符替换为真实值（`<项目名称>`、`<任务类型>`、`<研究目标>`、`<数据集名称>`、`<数据路径>`、`<主要指标>` 等）；**未知的保留占位符，不要猜**。
- [ ] 在 [`configs/task_types/`](configs/task_types/) 选 1 个（或数个）与项目匹配的任务类型，其余忽略。
- [ ] 写 [`docs/records/TASK_BRIEF.md`](docs/records/TASK_BRIEF.md)：本阶段要交付什么、范围、验收标准、预期证据等级。
- [ ] 确认 [`.gitignore`](.gitignore) 覆盖你的数据 / 权重 / 大输出；如装了 codegraph，运行 `codegraph init`。
- [ ] 跑一次自检：`bash scripts/check_template.sh`（应全绿）。
- [ ] 产生真实结果后，先记 [`docs/records/EXPERIMENT_LOG.md`](docs/records/EXPERIMENT_LOG.md)，再把可信结论登记到 [`docs/records/EVIDENCE.md`](docs/records/EVIDENCE.md) 并标证据等级。

## 3. 之后怎么干活

- **以产出论文为终点**的任务 → 按 [`docs/rules/RESEARCH_LOOP.md`](docs/rules/RESEARCH_LOOP.md) 的三环（计划 / 执行 / 写作）迭代。
- **非论文任务**（软件工程 / 数据分析 / 探索）→ 直接按 [`CLAUDE.md`](CLAUDE.md) 第 12 节"新任务流程"执行，不必进 RESEARCH_LOOP。
- 模板升级后同步规则 / 迁移旧项目：`scripts/update_from_template.sh`（见 [`README.md`](README.md) 第 5.3 节）。

---

## 附：填好后"长什么样"（合成示例）

> ⚠️ **以下全部是为演示结构而编造的合成内容，数值 / 路径均不真实，切勿复制进真实记录、切勿当作既成结论。** 它只用来展示"占位符替换后大致的样子"，帮助你理解目标状态。真实项目里每个数字都必须有 artifact 支撑、按证据等级如实标注（见 CLAUDE.md 第 3–4 节）。

**`docs/records/PROJECT.md`（节选，已填）**

| 字段 | 值（合成） |
| --- | --- |
| 项目名称 | demo-肝脏分割（示例，非真实） |
| 任务类型 | segmentation |
| 主要指标 | `<主要指标>`（如 Dice；具体数值不写在 PROJECT.md，进 EVIDENCE.md） |
| 数据路径 | `<数据路径>`（占位，真实路径不入 git） |

**`docs/records/EVIDENCE.md`（一条 claim，已填，合成）**

| claim | 证据等级 | 支持 artifact | 状态 |
| --- | --- | --- | --- |
| 方法在开发集上优于 baseline-A | 4（开发集验证，合成示例） | `outputs/demo/run-0001/metrics.json`（合成路径） | 初步、待内部验证（仍 `NOT VERIFIED` 是否泛化） |

> 注意示例里的安全表达：证据等级只标到 4（开发集），结论只说"开发集上优于"，**没有**说"更鲁棒 / SOTA / 临床可用"——那些需要等级 7–9 的证据。这正是模板要求的口径。
