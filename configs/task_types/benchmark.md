# 任务类型配置：benchmark（基准评测）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"基准评测"任务时启用；启用方式为在 `docs/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD）。
- 任务形式：在 `<数据集名称>` 上以统一协议公平比较多种方法，输出可复现、防泄漏的 leaderboard 与评测报告。
- 任务边界：明确参评方法集合、评测维度、固定评估脚本与提交规则（TBD）。
- 评价口径：所有方法共用同一划分、同一指标实现、同一固定评估脚本；先 case-level 后 aggregate。
- 未验证结论标 PENDING/NOT VERIFIED。

## 2. 默认交付物

- 固定评估脚本：`<主脚本>`（版本锁定，TBD）。
- 划分与协议文件：`configs/`（train/validation/test 与 holdout 划分、seed、提交格式，TBD）。
- 参评提交：各方法预测结果（默认不入 git，manifest+checksum）。
- leaderboard：结果表 + 规则文档。
- 评测 manifest：每条结果的 commit hash、命令、生成时间、提交方。
- 实验记录：`experiments/records/`。

## 3. 推荐指标

> 取值留占位，不得填未经真实 artifact 支持的数字。

- 主要指标：按任务族选定的统一主指标（`<主要指标>`=TBD）。
- 辅助指标：覆盖多维度（鲁棒性、效率、分层子集，`<辅助指标>`=TBD）。
- 聚合与排名规则：排名口径（单指标/综合/秩平均）需事先固定并公开。
- 指标实现版本锁定，禁止各方法各自实现导致不可比。

## 4. 常见失败模式

- 数据泄漏：测试/holdout 标签或同源样本进入训练；预处理统计量跨划分。
- 划分不公平：不同方法用了不同划分或额外数据未声明。
- 评估脚本漂移：脚本/指标实现在评测期间变动，历史结果不可比。
- 在 holdout 上反复提交调优，等同于在测试集上训练。
- 排名规则事后更改以迎合特定方法。
- leaderboard 缺乏 manifest，结果不可追溯、不可复现。

## 5. 证据要求

引用统一证据等级（1→9），benchmark 结果通常对应等级 6（冻结内部测试）至 7（锁定 holdout 测试）。

- 每条 leaderboard 结果须可回答：结论是什么 / 哪个 artifact / 在哪 / 何时 / 何命令 / 初步还是最终。
- 强制要求：公平划分 + 防泄漏 + 固定评估脚本 + 公开 leaderboard 规则。
- holdout 提交次数受限并记录；测试前冻结协议、划分、脚本、指标实现。
- 保留无效/泄漏/撤回提交记录等负结果，归档不删除。
- 证据不足不得声称某方法"最优/SOTA/可临床使用"，仅陈述在本协议下的相对表现并标注局限。

## 6. 优先查看的文件

1. `docs/PROJECT.md`、2. `docs/TASK_BRIEF.md`、3. `docs/RESEARCH_RULES.md`（冻结测试与防泄漏纪律）、4. `docs/EVIDENCE.md` 与 `docs/EXPERIMENT_LOG.md`、5. `data/README.md`（划分与提交格式）、6. `CLAUDE.md`。

## 7. 典型输出

- 各方法预测结果与提交包（默认不入 git，manifest+checksum 记录）。
- leaderboard 表与排名规则文档（取值 TBD/PENDING）。
- 防泄漏与划分核验报告。
- 评测 manifest：commit hash、固定脚本版本、划分、命令、提交时间与提交方。
- 实验记录条目，标注证据等级与状态。
