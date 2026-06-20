# 任务类型配置：paper_writing（论文写作）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"论文写作"任务时启用；启用方式为在 `docs/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD），目标期刊/会议：`<目标期刊>`（TBD）。
- 任务形式：将已验证的科研证据组织为论文，核心是建立 claim → 证据映射，确保每条主张都有可追溯 artifact 支撑。
- 任务边界：明确论文范围、贡献点清单、可公开的结果边界（TBD）。
- 评价口径：以 claim 是否被证据支持、是否过度声称为审稿口径。
- 未验证结论标 PENDING/NOT VERIFIED，不得写入正文作为已确立结论。

## 2. 默认交付物

- 论文草稿与小节：`docs/PAPER_NOTES.md` 及稿件（路径 TBD）。
- claim → 证据映射表：每条 claim 链接到 `docs/EVIDENCE.md` 中具体条目与 artifact。
- 图表与其生成脚本/数据来源（图片相对路径引用）。
- 结果审计：`docs/RESULT_AUDIT.md` 中对论文数字的逐项核验。
- 参考文献与引用清单。
- 实验记录：`experiments/records/` 中被引用结果的来源。

## 3. 推荐指标

> 论文写作以"映射完备性"为核心，数值结果一律引用证据文件，不在本文件填具体值。

- claim 覆盖率：有证据支撑的 claim 占比（目标=每条 claim 均有 artifact）。
- 证据等级标注完整性：每条结果标明 1→9 中的等级。
- 数字一致性：正文/图/表/附录中同一指标取值一致（取值 TBD/PENDING，源自 `docs/EVIDENCE.md`）。
- 过度声称检查：是否存在超出证据等级的措辞。

## 4. 常见失败模式

- claim 与证据脱节：正文结论无对应 artifact 或引用错误条目。
- 过度声称：用开发集结果（等级 4）描述为外部验证（等级 8）或 SOTA。
- 数字漂移：不同小节/图表对同一指标给出不一致取值。
- 选择性报告：隐藏负结果或失败设置。
- 引用与图片来源不可追溯（缺生成脚本/commit hash）。
- 把 PENDING/NOT VERIFIED 结论当作已确立写入正文。

## 5. 证据要求

引用统一证据等级（1→9）。

- 每条 claim 须可回答：结论是什么 / 哪个 artifact 支持 / 在哪 / 何时生成 / 何命令 / 等级是几。
- 论文中报告的等级不得高于证据实际等级。
- 默认状态：未核验数字标 PENDING，未确认结论标 NOT VERIFIED，不写入正文。
- 负结果与局限须在论文中如实呈现。
- 不得声称"临床有效/诊断更优/泛化强/鲁棒/SOTA/可临床使用"，除非证据等级与措辞匹配。

## 6. 优先查看的文件

1. `docs/EVIDENCE.md`（claim 的证据来源，最优先）。
2. `docs/RESULT_AUDIT.md`（数字核验）。
3. `docs/PAPER_NOTES.md`（写作笔记与贡献点）。
4. `docs/PROJECT.md` 与 `docs/TASK_BRIEF.md`（项目事实与范围）。
5. `docs/RESEARCH_RULES.md`（科研安全表达纪律）。
6. `docs/RESEARCH_LOOP.md`（迭代研究循环协议：以"完成论文"为终点的执行 / 检查 / 修订闭环）。
7. `CLAUDE.md`（Agent 行为规则）。

## 7. 典型输出

- 论文草稿/小节（含证据等级标注，结论状态 TBD/PENDING/NOT VERIFIED）。
- claim → 证据映射表（每条 claim 链接 artifact 与等级）。
- 图表 + 生成脚本与数据来源记录（相对路径）。
- 数字一致性核验清单（引用 `docs/RESULT_AUDIT.md`）。
- 局限与负结果小节。
