# outputs/ 输出目录约定

> 本文件描述本项目输出目录的组织与登记规则。本模板于 2026-06-19 创建，**当前目录内没有任何真实输出**，下文具体内容均为占位符或标记为 TBD / PENDING。

本目录用于存放实验产物（checkpoint、训练/评估日志、指标、概率图等）。大体积输出默认**不进入 git**，仅保留轻量、可追溯的 artifact。

---

## 1. git 纳入规则

| 内容类型 | 是否入 git | 替代方案 |
| --- | --- | --- |
| 本 README、目录说明 | 入 git | —— |
| 指标 CSV / JSON（轻量汇总） | 入 git（体积合理时） | —— |
| 输出 manifest（产物清单 + 路径 + 生成信息） | 入 git | —— |
| 模型 checkpoint / 权重 | 不入 git | manifest 记录路径与 checksum |
| 训练 / 评估日志（大文件） | 不入 git | manifest 记录；必要时归档摘要 |
| 概率图 / 预测体数据 / 影像类大输出 | 不入 git | manifest 记录 |
| 其他大体积中间产物 | 不入 git | manifest 记录 |

原则：

- **checkpoint、日志、指标大文件、概率图、其他大输出默认不入 git**，用 manifest 记录其存在、位置、生成命令与完整性。
- 轻量指标文件（CSV/JSON）可入 git，作为结果的可追溯轻 artifact，但其结论是否成立仍依据 `docs/EVIDENCE.md` 的证据等级。

---

## 2. 子目录组织建议

建议在 `outputs/` 下按**实验 / 运行**组织，每次运行一个独立目录，避免互相覆盖：

```
outputs/
  <实验名>/<run-id>/         # run-id 如 2026-06-19_seed0 或 run-001
    checkpoints/             # 模型权重（不入 git）
    logs/                    # 训练/评估日志（不入 git）
    metrics/                 # 指标 CSV/JSON（原始，体积合理时可入 git）
    predictions/             # 概率图/预测产物（不入 git）
    manifest.<格式>          # 本次输出清单（入 git）
    config_snapshot.<格式>   # 本次运行配置快照（入 git）
```

本目录只放**运行中间产物**；整理后、支撑 claim 的**轻量结果与验证结果**另归 [`../results/`](../results/)（入 git）。`<run-id>` 建议含 seed / 日期，便于区分多次运行。

---

## 3. 输出 manifest 与可追溯性

每次产生输出建议写一份 manifest，至少记录：

- 产物清单：文件相对路径、类型、大小、必要的 checksum。
- 生成信息：commit hash、环境（`<Python解释器>` / `<Conda环境>`）、seed、配置文件、命令行参数、生成命令、生成时间。
- 对应实验：在 `docs/EXPERIMENT_LOG.md` 中的记录条目，以及在 `docs/EVIDENCE.md` 中对应的证据等级。

这样每个指标/产物都能回答：结论是什么 / 由哪个 artifact 支持 / artifact 在哪 / 何时生成 / 由什么命令生成 / 属初步还是最终证据。

---

## 4. 纪律

- 指标未经验证标 PENDING；结论未确认标 NOT VERIFIED；运行未完成标 INCOMPLETE。
- 不在 holdout / 外部测试输出上回头调参、调阈值或改架构；测试前冻结协议、脚本、模型、阈值与配置。
- 删除 checkpoint / 日志 / 指标 / 产物属不可逆操作，须明确指令，**优先归档而非删除**；负结果产物同样保留。

---

## 5. 当前状态

- 输出产物：无（空模板）
- manifest：TBD
- 指标：PENDING
