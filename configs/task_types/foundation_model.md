# 任务类型配置：foundation model（图像基础模型）

> 配置可选，基础模板不依赖任何单一任务类型。
> 本文件仅在当前项目确属"图像基础模型（预训练或下游适配/评估）"任务时启用；启用方式为在 `docs/PROJECT.md` 标注任务类型并按需引用本文件。所有具体取值用占位符表达，未知=TBD、未验证=PENDING、未确认=NOT VERIFIED、未完成=INCOMPLETE。

## 1. 任务目标

- 研究目标：`<研究目标>`（TBD）。
- 任务形态（二选一或并存，TBD）：
  - 形态 a｜预训练一个图像 foundation model：在 `<预训练语料>` 上以 SSL（MIM 如 MAE/SimMIM/BEiT、自蒸馏如 DINO/DINOv2/iBOT、对比如 SimCLR/MoCo、潜空间预测如 I-JEPA）、视觉-语言对齐（CLIP/SigLIP）或可提示分割（SAM/SAM 2）目标，训练可迁移的通用 backbone/checkpoint。
  - 形态 b｜适配/评估一个预训练 FM：把 `<MODEL_ID>` 适配到下游任务 `<下游任务>`，并以下游协议量化"接得好不好"。
- 任务边界：明确主干架构（ViT/Swin/Hiera/ConvNeXt 等，TBD）、预训练范式与目标函数、适配方式（frozen + linear probe/kNN、few-shot、zero-shot、prompt、PEFT、全量 fine-tune），以及下游任务族与评测维度。
- 评价口径：下游驱动评估——预训练代理损失（对比/重建/自蒸馏损失）仅作训练监控，**不是终点指标**；终点指标须在与预训练严格隔离的数据上度量。严格区分预训练数据 / 开发集 / 冻结测试集结果，不混用。
- frozen vs fine-tune 不混淆：每个数字须注明取自冻结特征还是微调后；二者度量不同能力，不可混报。
- 本任务的所有结论默认证据等级见各结论旁标注；未验证结论标 PENDING/NOT VERIFIED。

## 2. 默认交付物

- 预训练/适配/评估脚本：`<主脚本>`（路径 TBD），含 probing recipe（linear probe 的 $lr$/$wd$/epoch/归一化、kNN 的 $k$ 与距离度量、zero-shot 的 prompt 模板集合）。
- 配置文件：`configs/` 下对应实验配置（含 seed、数据划分、超参、预训练范式与目标、适配方式，TBD）。
- 模型权重/checkpoint：`<checkpoint路径>`（默认不入 git，用 manifest+checksum 记录）；区分预训练 backbone 与下游 head/PEFT 模块。
- 数据 manifest：`<data_manifest_path>`（来源、规模、过滤/去重规则与版本、checksum）。
- 去重/泄漏检测报告：`<leakage_check_report>`（预训练语料 × `<holdout_set>`/`<external_eval_set>` 的重叠率与方法，PENDING）。
- 评估脚本与结果表：固定评估脚本 + 指标 manifest（记录命令、commit hash、seed、协议、生成时间）。
- 实验记录：`experiments/records/` 下逐次运行记录。

## 3. 推荐指标

> 取值一律留占位，不得填入未经真实 artifact 支持的数字；模型规模、数据规模、batch size、遮挡率、baseline 与结果一律 PENDING/TBD/NOT VERIFIED。

- 表征质量（冻结特征）：linear probe top-1（`<METRIC>`=PENDING，记录 probing recipe）、kNN accuracy（记 $k$ 与距离度量，对协议更鲁棒）。
- zero-shot（视觉-语言模型）：zero-shot 分类/检索（Recall@K），须记录 prompt 模板集合与是否 ensemble。
- 适配后指标：fine-tune 或 PEFT（LoRA/adapter/BitFit/prefix）后的下游指标，须与 frozen 分开报告并披露可训练参数量。
- few-shot / 标注效率曲线：按 $K\in\{1,2,4,8,16\}$ 或 1%/10% 标注比例绘曲线，报均值±方差并固定 episode/seed。
- 稠密下游迁移：检测 mAP、分割 mIoU/Dice、深度估计误差（注明 frozen 还是 fine-tune，固定 head 与协议）。
- 鲁棒性 / OOD：分布偏移下掉点（如 ImageNet-C/R/A 思路），单列而非并入主指标，对应证据等级 8 外部验证。
- 校准：ECE、reliability diagram、Brier score，与准确率分别报告（高准确率不蕴含好校准）。
- 效率：可训练参数量、占比、峰值显存、吞吐、checkpoint 体积（用于 PEFT vs 全量 fine-tune 公平比较）。
- 泄漏排查：预训练 × 评测集近重复/语义重叠比例（artifact，未做标 NOT VERIFIED）。

对比预训练目标（InfoNCE，仅作示意，取值 TBD）：

$$
\mathcal{L}_{\mathrm{InfoNCE}} = -\log \frac{\exp(\mathrm{sim}(z_i, z_i^{+})/\tau)}{\sum_{j=1}^{N}\exp(\mathrm{sim}(z_i, z_j)/\tau)}
$$

其中 $z_i$ 为锚样本表征、$z_i^{+}$ 为正样本表征、$\tau$ 为温度、$\mathrm{sim}(\cdot,\cdot)$ 为相似度（如余弦）。此式仅示意训练监控的代理损失，**非终点业绩指标**，$\tau$、$N$ 等取值 TBD。

## 4. 常见失败模式

- 预训练-评测泄漏（contamination）：下游 benchmark 图像或 near-duplicate 进入预训练集，使 linear probe/zero-shot 虚高、把"记忆"误判为"泛化"；仅做精确去重会漏掉感知近重复，须用感知/嵌入级 copy-detection 并报告去污前后差。
- 范式与评估协议错配：MIM/重建式偏 fine-tune，自蒸馏/对比偏冻结 linear probe 与 kNN；错配（如用 linear probe 评 MAE）易得误导性结论。
- frozen vs fine-tune 混淆：两种协议度量不同能力，混报会误导；弱 linear probe ≠ 弱表征（对协议超参高度敏感），应至少配 kNN 作低自由度佐证。
- 表征坍塌（collapse）：所有样本映射到平凡解；须监控特征 rank/奇异值谱/方差，依赖 stop-gradient、momentum teacher、prototype/Sinkhorn、uniformity 正则等防护；dense 特征长训练下可能退化。
- protocol overfitting：在 holdout/外部测试集上调适配协议、超参、zero-shot prompt 或按测试指标 early-stop/选 checkpoint，等同于在测试集上训练。
- cherry-picking：只报占优任务/数据集高估"通用性"；SSL 常在 few-shot/检测/dense prediction 偏弱，应预登记多样任务套件并全报。
- 比较不公平（apples-to-oranges）：未对齐预处理、分辨率、特征层、超参搜索预算、few-shot 的 $K$、prompt 模板、split 与 seed；不一致项未标注即下结论。
- 过度声称"通用/foundation/SOTA/临床可用"：单 benchmark 高分不足以支撑通用性，跨域（医学/遥感等）可能失效；此类强主张在跨 7 锁定 holdout / 8 外部验证前一律 NOT VERIFIED。
- 把代理损失当终点指标：对比/重建/自蒸馏损失下降与下游能力非单调对应（低 reconstruction loss ≠ 好表征）。
- 算力与可复现：旗舰 FM 重训成本高、随机源多（数据顺序、分布式、混合精度、硬件）；缺 checkpoint/manifest/checksum/多 seed 方差则难复现。
- 编造数字：任何规模、重叠率、去重移除率、baseline、结果在未验证前保持占位并标 PENDING/TBD/NOT VERIFIED。

## 5. 证据要求

引用统一证据等级（1 假设 → 2 设计方案 → 3 实现正确性检查 → 4 开发集验证 → 5 内部验证 → 6 冻结内部测试 → 7 锁定 holdout 测试 → 8 外部验证 → 9 独立复现）。

- 每个指标结论须可回答：结论是什么 / 由哪个 artifact 支持 / artifact 在哪 / 何时生成 / 由什么命令生成 / 初步还是最终。
- 当前默认状态：预训练/适配 INCOMPLETE、指标 PENDING、对外结论 NOT VERIFIED，直至有真实 artifact。
- 主张强度随证据等级单调上升：等级 1 仅为"预期表征具通用性"的假设；等级 2 已定义适配方法与评估协议；等级 3 通过去污 pipeline、collapse 监控、协议一致性、checksum/manifest 自检（非性能证据）；等级 4 开发集结果仅供内部迭代；等级 5 多 split/多 seed 内部稳定；等级 6 协议冻结后内部保留集评估；等级 7 一次性解锁 holdout 得首个可引用证据；等级 8 跨域/外部 benchmark 验证；等级 9 第三方用公开 checkpoint+manifest 独立复现。
- "通用 foundation 表征"至少需到等级 7，跨域"通用性"宜到等级 8，"稳健可复现"到等级 9；未达项标 PENDING/TBD/INCOMPLETE，禁止越级声明。
- 防泄漏强制要求：预训练语料须与 `<holdout_set>`/`<external_eval_set>` 去重并记录重叠率；去重规则版本化、可复现；冻结 holdout 后任何预训练数据改动须重跑泄漏检测并更新 artifact 版本号。
- 不在 holdout/外部测试集上调协议、超参、prompt、head 或选 checkpoint；测试前冻结协议、脚本、模型、prompt 模板、配置、seed。
- 数据合规与公平性须记录：`<license>`、`<data_source_provenance>`、`<pii_handling>`、`<removal_process>`（TBD）；OOD/外部验证阶段单列偏倚与分组（subgroup）评估，不把"更多数据=更公平"当默认假设。
- 负结果（失败运行、泄漏风险、collapse、指标不一致）必须保留并归档，不删除。
- 证据不足时不得声称"通用/foundation/SOTA/可临床使用/更鲁棒"，改用"当前证据仅支持……仍需验证"。

## 6. 优先查看的文件

1. `docs/PROJECT.md`：当前项目事实、任务类型、数据与目标。
2. `docs/TASK_BRIEF.md`：本次任务的具体范围与约束。
3. `docs/RESEARCH_RULES.md`：科研纪律、冻结测试与防泄漏规则。
4. `docs/EVIDENCE.md` 与 `docs/EXPERIMENT_LOG.md`：已有证据与运行记录。
5. `data/README.md`：预训练语料、下游划分、去重口径、holdout 锁定、路径约定。
6. `CLAUDE.md`：Agent 行为规则。

## 7. 典型输出

- 预训练 backbone / 下游 head / PEFT 模块 checkpoint（默认不入 git，仅以 manifest+checksum 记录）。
- 表征质量表：linear probe、kNN、zero-shot 结果（含 probing recipe 与 prompt 协议，取值 TBD/PENDING）。
- 适配对比表：frozen vs PEFT vs 全量 fine-tune，附可训练参数量与算力成本（取值 PENDING）。
- 标注效率曲线、稠密下游迁移、鲁棒性/OOD 与校准结果（相对路径引用可视化，如 `images/<图名>.png`）。
- 数据 manifest 与去重/泄漏检测报告：来源、规模、过滤/去重规则与版本、重叠率（PENDING）。
- 评估运行 manifest：commit hash、环境、seed、数据划分、协议、命令、checkpoint 路径、生成时间。
- 实验记录条目，标注证据等级与状态（PENDING/NOT VERIFIED/INCOMPLETE）。
