---
name: rust-standards
description: Rust 项目代码标准和规范，包括代码约定、质量标准、Clippy 规则配置、路径处理约定、性能优化和最佳实践。当需要规范 Rust 代码风格、修复代码质量问题或优化性能时使用此技能。
---

# Rust 代码标准

本技能定义 Rust 项目的代码标准和最佳实践，整合代码约定、质量规范和性能优化指南。

---

## 代码约定规范

### 路径处理约定

- **直接使用 normpath 原生 API，严禁过度包装**
- 使用 `normalized_display()` 进行路径显示
- 使用 `log_info_with_path!()` 宏记录路径信息
- Clippy 规则会自动检查不当的 `display()` 使用

### 代码风格约定

- 保持代码简洁，避免不必要的复杂度
- 优先使用标准库和成熟的第三方库
- 避免过度抽象和包装

---

## 代码质量规范

### 快速修复工具

使用以下命令快速修复常见的语法和风格问题：

```bash
cargo clippy --fix --workspace --allow-dirty
```

### Clippy 规则配置

项目应配置严格的 Clippy 规则，包括：

- **性能关键规则**：禁止不必要的克隆和类型转换
- **安全规则**：禁止使用 `unwrap()`, `expect()`, `panic!()`
- **异步编程检查**：避免在锁中使用 await

### 代码规范要点

- 使用 `anyhow::Result` 进行错误处理，避免 panic
- 优先使用 `?` 操作符传播错误
- 异步代码中避免持有锁跨越 await 点
- 使用 `normpath` 原生 API 处理路径，避免过度包装
- 保持代码简洁，避免不必要的复杂度

### 基础性能优化

- 避免不必要的内存分配和克隆
- 使用 `rayon` 进行并行计算
- 合理使用缓存机制（如 `lru` crate）
- 在 release 模式下启用 LTO 优化

---

## 命名规范

### 标准命名风格

- `snake_case`：函数、变量、模块
- `CamelCase`：类型、trait、枚举
- `SCREAMING_SNAKE_CASE`：常量

### 命名最佳实践

- 函数名应该是动词或动词短语
- 类型名应该是名词或名词短语
- 避免使用缩写（除非是广泛认可的）
- 布尔变量使用 `is_`, `has_`, `should_` 等前缀

---

## 详细规范参考

更详细的性能优化和错误处理规范请参考：
- 项目文档中的性能与错误处理章节
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [Rust Performance Book](https://nnethercote.github.io/perf-book/)
- [Effective Rust](https://www.lurklurk.org/effective-rust/)

---

**版本**：1.0.0  
**最后更新**：2025-12-02  
**替代**：合并自 code-conventions v1.0.0 和 rust-code-quality v1.0.0
