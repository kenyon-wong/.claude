---
name: rust-code-review
description: Rust 项目代码审查标准和检查清单。包含 17 个审查维度（安全、性能、架构等），适用于所有 Rust 项目的代码质量评估。当需要审查 Rust 代码、评估代码质量或识别技术债务时使用。
---

# Rust 代码审查标准

本 Skill 提供 Rust 项目代码审查的完整标准和检查清单。

---

## 快速入门

### 基本用法

对 Rust 项目进行代码审查时，按以下优先级执行：

1. **P0（必须）**：安全漏洞、内存安全、错误处理、并发安全
2. **P1（重要）**：逻辑错误、算法复杂度、架构设计、数据流
3. **P2（改进）**：冗余代码、可读性、API 设计、最佳实践
4. **P3（可选）**：技术债务、过度设计、用户体验、可观测性

### 审查工具

```bash
# 静态分析
cargo clippy --workspace --all-targets --all-features -- -D warnings

# 安全检查
cargo audit

# 测试覆盖率
cargo tarpaulin --workspace --out Html
```

---

## 审查维度详解

### 🔴 P0 阶段：核心安全与正确性

#### 1. 安全漏洞审查

**检查要点**：
- **命令注入**：验证 `Command` 使用 `.arg()` 而非字符串拼接
- **路径遍历**：检查路径规范化和边界验证
- **依赖漏洞**：运行 `cargo audit`
- **敏感数据**：搜索硬编码密钥、密码
- **Unsafe 代码**：严格审查所有 unsafe 块
- **整数溢出**：使用 `checked_*`, `saturating_*` 方法

**示例**：
```bash
# 查找硬编码密钥
rg -i "password|secret|api_key|token" crates/ --type rust

# 检查 unsafe 代码
rg "unsafe" crates/ --type rust
```

#### 2. 内存安全与资源管理

**检查要点**：
- **所有权和借用**：避免不必要的 `clone()`
- **生命周期标注**：验证无悬垂引用
- **智能指针**：Box/Rc/Arc 使用合理性
- **资源 RAII**：文件句柄、网络连接自动清理
- **内存泄漏**：使用 `Weak` 打破循环引用

#### 3. 错误处理与边界条件

**检查要点**：
- **Result 传播**：优先使用 `?` 操作符
- **错误类型**：使用 `thiserror` 定义错误
- **panic 避免**：检查不必要的 `unwrap()`/`expect()`
- **Option 处理**：使用组合子（map, and_then）
- **错误上下文**：使用 `anyhow::Context`

**示例**：
```bash
# 检查 unwrap/expect
rg "\.unwrap\(\)|\.expect\(" crates/ --type rust --glob '!**/tests/**'
```

#### 4. 并发安全审查

**检查要点**：
- **tokio 异步**：验证 async/await 正确性
- **竞态条件**：检查 Arc/Mutex/RwLock 使用
- **Send/Sync**：评估跨线程传递安全性
- **await_holding_lock**：避免持锁等待

---

### 🟡 P1 阶段：重要优化

#### 5. 逻辑错误

识别程序行为异常的逻辑缺陷，提供代码位置和影响分析。

#### 6. 算法复杂度评估

**检查要点**：
- 分析时间复杂度（Big O）
- 识别可优化的嵌套循环
- 标记 O(n²) 及以上的算法
- 评估 `rayon` 并行计算使用

#### 7. 架构设计审查

**检查要点**：
- 评估 crate 间耦合度
- 识别"上帝模块"
- 分析 trait 设计合理性
- 验证单一职责原则

#### 8. 数据流分析

追踪数据流转路径，检查验证和清洗完整性。

---

### 🟢 P2 阶段：改进提升

#### 9. 冗余代码

**检查工具**：
```bash
# 使用 Clippy 检测
cargo clippy --workspace

# 检查未使用依赖
cargo machete
```

#### 10. 代码可读性

**命名规范**：
- `snake_case`：函数、变量、模块
- `CamelCase`：类型、trait
- `SCREAMING_SNAKE_CASE`：常量

**检查要点**：
- 函数长度 < 50 行
- 文档注释完整（`///`）
- 无魔法数字

#### 11. API 设计

**检查要点**：
- 充分利用类型系统
- 复杂配置使用 Builder 模式
- 优先使用迭代器
- 确保零成本抽象

#### 12. 最佳实践

遵循 [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)。

---

### ⚪ P3 阶段：可选优化

#### 13-16. 技术债务、过度设计、用户体验、可观测性

详见 [ADVANCED.md](ADVANCED.md) 了解高级审查维度。

---

## 审查检查清单

### P0 阶段
- [ ] 无安全漏洞（命令注入、路径遍历）
- [ ] 无依赖安全漏洞（`cargo audit` 通过）
- [ ] 无内存安全问题
- [ ] 错误处理完整
- [ ] 并发安全

### P1 阶段
- [ ] 无明显逻辑错误
- [ ] 无性能瓶颈
- [ ] 架构设计合理
- [ ] 数据流清晰

### P2 阶段
- [ ] 无冗余代码
- [ ] 代码可读性好
- [ ] API 设计合理
- [ ] 遵循最佳实践

---

## 参考资料

- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [Rust Performance Book](https://nnethercote.github.io/perf-book/)
- [Rust Security Guidelines](https://anssi-fr.github.io/rust-guide/)
- [Effective Rust](https://www.lurklurk.org/effective-rust/)

---

**版本**：2.0.0  
**最后更新**：2025-12-02
