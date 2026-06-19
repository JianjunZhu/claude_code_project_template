# 任务类型配置：completion（补全/重建）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"补全/重建"任务时启用；启用方式为在 `docs/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD）。
- 任务形式：在 `<数据集名称>` 上，从不完整/降质/缺失的输入恢复完整目标（如缺失区域补全、形状补全、信号/图像重建），输出与目标空间一致的重建结果。
- 任务边界：明确缺失/降质模型、输入输出表示（点云/体素/网格/图像/序列，TBD）、是否条件生成。
- 评价口径：区分保真度（与真值差异）与合理性（结构/分布一致）；case-level 先算再 aggregate。
- 未验证结论标 PENDING/NOT VERIFIED。

## 2. 默认交付物

- 训练/推理脚本：`<主脚本>`（TBD）。
- 配置文件：`configs/` 下实验配置（seed、划分、超参、降质设定，TBD）。
- 模型权重：`<模型权重路径>`（默认不入 git，manifest+checksum）。
- 重建输出：`<输出目录>` 下补全结果（默认不入 git）。
- 评估脚本与结果表：固定脚本 + 指标 manifest。
- 实验记录：`experiments/records/`。

## 3. 推荐指标

> 取值留占位，不得填未经真实 artifact 支持的数字。

- 保真度指标（按模态选择，`<主要指标>`=TBD）：
  - 图像/信号：PSNR、SSIM、MAE、RMSE。
  - 点云/形状：Chamfer Distance、Earth Mover's Distance、F-Score。
- 分布/感知指标（辅助，`<辅助指标>`=TBD）：FID、LPIPS（若适用）。
- 聚合方式：先 case-level 后 aggregate，需说明降质强度分层。
- 指标实现与降质协议固定并记录，跨实验一致。

误差示意：

$$
\mathrm{RMSE} = \sqrt{\frac{1}{N}\sum_{i=1}^{N}\left(\hat{y}_i - y_i\right)^2}
$$

## 4. 常见失败模式

- 降质/缺失模型与真实场景不符，离线指标好但实用差。
- 过度平滑：保真度指标偏好模糊解，结构细节丢失。
- 数据泄漏：测试样本的完整版本在训练中出现；归一化统计量用到测试集。
- 指标取舍冲突：保真度与感知/分布指标方向相反，单看一项误导。
- 评估区域不一致：仅在缺失区域还是全图计算未统一。
- 过拟合特定降质强度，未在分层下评估泛化。

## 5. 证据要求

引用统一证据等级（1→9，同 segmentation 配置所述）。

- 每个重建指标结论须可回答：结论是什么 / 哪个 artifact / 在哪 / 何时 / 何命令 / 初步还是最终。
- 默认状态：训练 INCOMPLETE、指标 PENDING、对外结论 NOT VERIFIED。
- 不在 holdout/外部测试集上调降质设定、阈值或架构；测试前冻结协议与脚本。
- 保真度与分布指标须同时报告并保留负结果。
- 证据不足不得声称"重建更真/更通用/可临床使用/SOTA"，改用谨慎措辞。

## 6. 优先查看的文件

1. `docs/PROJECT.md`、2. `docs/TASK_BRIEF.md`、3. `docs/RESEARCH_RULES.md`、4. `docs/EVIDENCE.md` 与 `docs/EXPERIMENT_LOG.md`、5. `data/README.md`（含降质/缺失约定）、6. `CLAUDE.md`。

## 7. 典型输出

- 重建结果文件（默认不入 git，manifest+checksum 记录）。
- 逐 case 与 aggregate 指标表（保真度 + 分布/感知，取值 TBD/PENDING）。
- 对比可视化（输入降质/真值/重建，相对路径）。
- 评估运行 manifest：commit hash、环境、seed、划分、命令、checkpoint、时间。
- 实验记录条目，标注证据等级与状态。
