---
name: rust-code-quality
description: 定义 Rust 代码质量标准，包括 Clippy 规则配置、快速修复工具和基础性能优化指南。当需要修复代码质量问题、运行 Clippy 检查或优化 Rust 代码性能时使用此技能。
---

# Rust 代码质量规范

本技能定义 CodeQL Scanner 项目的 Rust 代码质量标准和最佳实践。

## 快速修复工具

使用以下命令快速修复常见的语法和风格问题：

```bash
cargo clippy --fix --workspace --allow-dirty
```

## Clippy 规则配置

项目已配置严格的 Clippy 规则，包括：

- **性能关键规则**：禁止不必要的克隆和类型转换
- **安全规则**：禁止使用 `unwrap()`, `expect()`, `panic!()`
- **异步编程检查**：避免在锁中使用 await

## 代码规范要点

- 使用 `anyhow::Result` 进行错误处理，避免 panic
- 优先使用 `?` 操作符传播错误
- 异步代码中避免持有锁跨越 await 点
- 使用 `normpath` 原生 API 处理路径，避免过度包装
- 保持代码简洁，避免不必要的复杂度

## 基础性能优化

- 避免不必要的内存分配和克隆
- 使用 `rayon` 进行并行计算
- 合理使用缓存机制（如 `lru` crate）
- 在 release 模式下启用 LTO 优化

## 详细规范参考

详细的性能优化和错误处理规范请参考项目文档中的性能与错误处理章节。
