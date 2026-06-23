# 任务类型配置：detection（检测）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"检测"任务时启用；启用方式为在 `docs/records/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD）。
- 任务形式：在 `<数据集名称>` 中定位并分类目标，输出带类别与置信度的检测框/关键点（2D/3D，TBD）。
- 任务边界：明确类别清单、框定义、是否多尺度、IoU 匹配阈值约定（TBD）。
- 评价口径：按 IoU 匹配判定 TP/FP/FN，case-level 先算后 aggregate；区分开发集与冻结测试集。
- 未验证结论标 PENDING/NOT VERIFIED。

## 2. 默认交付物

- 训练/推理脚本：`<主脚本>`（TBD）。
- 配置文件：`configs/`（seed、划分、anchor/匹配设定、超参，TBD）。
- 模型权重：`<模型权重路径>`（默认不入 git，manifest+checksum）。
- 检测输出：`<输出目录>` 下预测框文件（默认不入 git）。
- 评估脚本与结果表：固定脚本 + 指标 manifest（含 IoU 阈值、匹配规则）。
- 实验记录：`experiments/records/`。

## 3. 推荐指标

> 取值留占位，不得填未经真实 artifact 支持的数字。

- 主要指标：mAP（含 IoU 阈值设定，`<主要指标>`=TBD）。
- 召回率（Recall）、精确率（Precision）。
- 辅助指标：按类 AP、PR 曲线、不同尺度/距离分层指标（`<辅助指标>`=TBD）。
- 聚合方式：按类与按 IoU 阈值的平均规则需固定并记录。

精确率/召回率示意：

$$
\mathrm{Precision} = \frac{TP}{TP + FP}, \qquad \mathrm{Recall} = \frac{TP}{TP + FN}
$$

## 4. 常见失败模式

- 匹配协议不一致：IoU 阈值、NMS、置信度截断口径不同导致指标不可比。
- 类别不平衡与小目标漏检，mAP 被主导类掩盖。
- 数据泄漏：近重复图像/同源序列跨 train/test。
- 评估实现差异：不同 mAP 实现（如不同插值方式）数值不可直接比较。
- 置信度未校准：阈值选择在测试集上"偷看"导致高估。
- 标注漏框造成 FP 误判，污染精确率。

## 5. 证据要求

引用统一证据等级（1→9）。

- 每个检测指标结论须可回答：结论是什么 / 哪个 artifact / 在哪 / 何时 / 何命令 / 初步还是最终。
- 默认状态：训练 INCOMPLETE、指标 PENDING、对外结论 NOT VERIFIED。
- 不在 holdout/外部测试集上调置信度阈值、NMS 或架构；测试前冻结匹配协议与脚本。
- 记录 mAP 实现版本与 IoU 阈值；保留负结果与漏检案例。
- 证据不足不得声称"检测更准/更鲁棒/可临床使用/SOTA"，用谨慎措辞。

## 6. 优先查看的文件

1. `docs/records/PROJECT.md`、2. `docs/records/TASK_BRIEF.md`、3. `docs/rules/RESEARCH_RULES.md`、4. `docs/records/EVIDENCE.md` 与 `docs/records/EXPERIMENT_LOG.md`、5. `data/README.md`（标注与划分口径）、6. `CLAUDE.md`。

## 7. 典型输出

- 预测框/置信度文件（默认不入 git，manifest+checksum 记录）。
- 逐 case 与 aggregate 指标表、PR 曲线（取值 TBD/PENDING）。
- 可视化（真值框/预测框叠加，相对路径）。
- 评估运行 manifest：commit hash、环境、seed、划分、命令、checkpoint、时间、IoU 阈值。
- 实验记录条目，标注证据等级与状态。
