# 任务类型配置：tracking（跟踪）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"跟踪"任务时启用；启用方式为在 `docs/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD）。
- 任务形式：在 `<数据集名称>` 的序列上对目标进行跨帧关联，输出带稳定身份的轨迹（单目标/多目标，TBD）。
- 任务边界：明确目标定义、是否在线/离线、关联协议与初始化方式（TBD）。
- 评价口径：序列级先算再 aggregate；区分检测质量与关联质量。
- 未验证结论标 PENDING/NOT VERIFIED。

## 2. 默认交付物

- 跟踪/推理脚本：`<主脚本>`（TBD）。
- 配置文件：`configs/`（seed、关联阈值、检测来源、超参，TBD）。
- 模型/参数：`<模型权重路径>`（默认不入 git，manifest+checksum）。
- 轨迹输出：`<输出目录>` 下轨迹文件（默认不入 git）。
- 评估脚本与结果表：固定脚本 + 指标 manifest（含匹配距离阈值）。
- 实验记录：`experiments/records/`。

## 3. 推荐指标

> 取值留占位，不得填未经真实 artifact 支持的数字。

- 主要指标：MOTA、IDF1（`<主要指标>`=TBD）。
- 关联/身份指标：ID switches、HOTA（若适用）。
- 单目标场景：成功率（Success/AUC）、精度（Precision plot）。
- 辅助指标：MOTP、FP/FN/碎片数（`<辅助指标>`=TBD）。
- 聚合方式：按序列加权或简单平均需固定并记录。

## 4. 常见失败模式

- 检测质量与关联质量混淆：MOTA 受检测器主导，掩盖关联问题。
- 身份切换在遮挡/交叉处集中，IDF1 下降。
- 数据泄漏：同源序列或相邻片段跨 train/test。
- 评估协议差异：匹配阈值、插值、缺失帧处理不一致致指标不可比。
- 在线/离线设定混用，结果不可直接对比。
- 在测试序列上调关联阈值导致高估。

## 5. 证据要求

引用统一证据等级（1→9）。

- 每个跟踪指标结论须可回答：结论是什么 / 哪个 artifact / 在哪 / 何时 / 何命令 / 初步还是最终。
- 默认状态：实现 INCOMPLETE、指标 PENDING、对外结论 NOT VERIFIED。
- 不在 holdout/外部测试序列上调关联阈值或架构；测试前冻结协议与脚本。
- 记录检测来源与评估实现版本；保留身份切换/失败片段等负结果。
- 证据不足不得声称"跟踪更稳/更鲁棒/可临床使用/SOTA"，用谨慎措辞。

## 6. 优先查看的文件

1. `docs/PROJECT.md`、2. `docs/TASK_BRIEF.md`、3. `docs/RESEARCH_RULES.md`、4. `docs/EVIDENCE.md` 与 `docs/EXPERIMENT_LOG.md`、5. `data/README.md`（序列划分与标注口径）、6. `CLAUDE.md`。

## 7. 典型输出

- 轨迹文件（默认不入 git，manifest+checksum 记录）。
- 序列级与 aggregate 指标表（MOTA/IDF1 等，取值 TBD/PENDING）。
- 轨迹可视化/身份切换标注（相对路径）。
- 评估运行 manifest：commit hash、环境、seed、划分、命令、参数、时间、匹配阈值。
- 实验记录条目，标注证据等级与状态。
