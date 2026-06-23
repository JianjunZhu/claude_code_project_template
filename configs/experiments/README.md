# configs/experiments/ 单次实验配置目录

> 本目录存放**单次实验的配置**（seed、超参、数据划分、模型 / 优化器设置等）。本模板于 2026-06-19 创建，目录内无真实配置，下文为占位约定。

## 1. 定位（与 task_types 区分）

- [`../task_types/`](../task_types/)：**任务类型**的通用约定（指标、交付物、常见失败模式）。
- `configs/experiments/`：**某一次具体运行**的可复现配置，被 [`../../scripts/`](../../scripts/) 的脚本读取。

## 2. 约定

- 一个实验一个配置文件；命名建议 `exp_<主题>_<变体>.{yaml,json}`，便于检索。
- 必含可复现要素：seed、数据划分（或其 manifest 路径）、关键超参、模型 / 优化器、输出目录。
- 配置**入 git**；每次运行把所用配置路径与 commit hash 记入 [`../../docs/records/EXPERIMENT_LOG.md`](../../docs/records/EXPERIMENT_LOG.md)。
- 不在配置里写死私有绝对路径 / 密钥；路径用占位符（`<数据路径>`、`<输出目录>`）。

## 3. 当前状态

- 实验配置：无（空模板）。
