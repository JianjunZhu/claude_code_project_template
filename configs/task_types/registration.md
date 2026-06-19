# 任务类型配置：registration（配准）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"配准"任务时启用；启用方式为在 `docs/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD）。
- 任务形式：在 `<数据集名称>` 上估计将移动图像/形状对齐到固定参考的空间变换（刚性/仿射/形变，TBD），输出变换场或参数。
- 任务边界：明确变换模型、单模/多模、是否需保拓扑、评估解剖标志点来源（TBD）。
- 评价口径：基于标志点与重叠区域评估，case-level 先算后 aggregate。
- 未验证结论标 PENDING/NOT VERIFIED。

## 2. 默认交付物

- 配准/推理脚本：`<主脚本>`（TBD）。
- 配置文件：`configs/`（seed、变换模型、正则项、超参，TBD）。
- 模型/参数：`<模型权重路径>`（默认不入 git，manifest+checksum）。
- 变换场/对齐结果：`<输出目录>`（默认不入 git）。
- 评估脚本与结果表：固定脚本 + 指标 manifest（含标志点定义）。
- 实验记录：`experiments/records/`。

## 3. 推荐指标

> 取值留占位，不得填未经真实 artifact 支持的数字。

- 主要指标：TRE（目标配准误差）、配准后 Dice（`<主要指标>`=TBD）。
- 形变正则性：雅可比行列式负值比例、形变平滑度。
- 辅助指标：HD95、标志点误差分布（`<辅助指标>`=TBD）。
- 聚合方式：按 case 与按标志点的统计口径需固定并记录。

TRE 示意：

$$
\mathrm{TRE} = \frac{1}{M}\sum_{j=1}^{M}\left\lVert T(p_j) - q_j \right\rVert_2
$$

其中 $T$ 为估计变换，$p_j$、$q_j$ 为对应标志点。

## 4. 常见失败模式

- 折叠/非物理形变：雅可比出现负值但 Dice 仍偏高，掩盖问题。
- 标志点稀疏或定位误差大，TRE 不可靠。
- 数据泄漏：同受试者多时相跨 train/test。
- 评估口径不一致：重采样、掩膜范围、坐标系不同致指标不可比。
- 仅看重叠指标忽略形变正则性，导致解剖不合理。
- 在测试集上调正则权重导致高估。

## 5. 证据要求

引用统一证据等级（1→9）。

- 每个配准指标结论须可回答：结论是什么 / 哪个 artifact / 在哪 / 何时 / 何命令 / 初步还是最终。
- 默认状态：实现 INCOMPLETE、指标 PENDING、对外结论 NOT VERIFIED。
- 不在 holdout/外部测试集上调正则权重或变换模型；测试前冻结协议与脚本。
- 同时报告重叠指标与形变正则性；保留折叠/失败案例等负结果。
- 证据不足不得声称"配准更准/更鲁棒/可临床使用/SOTA"，用谨慎措辞。

## 6. 优先查看的文件

1. `docs/PROJECT.md`、2. `docs/TASK_BRIEF.md`、3. `docs/RESEARCH_RULES.md`、4. `docs/EVIDENCE.md` 与 `docs/EXPERIMENT_LOG.md`、5. `data/README.md`（标志点与划分口径）、6. `CLAUDE.md`。

## 7. 典型输出

- 变换场/对齐后图像（默认不入 git，manifest+checksum 记录）。
- 逐 case 与 aggregate 指标表（TRE/Dice/雅可比等，取值 TBD/PENDING）。
- 配准前后叠加可视化与形变栅格图（相对路径）。
- 评估运行 manifest：commit hash、环境、seed、划分、命令、参数、时间。
- 实验记录条目，标注证据等级与状态。
