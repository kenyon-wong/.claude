---
name: rust-testing
description: Rust 项目测试验证流程和质量检查标准。包含编译验证、单元测试、代码质量检查、性能基准测试、安全验证等完整测试流程。当需要运行测试、验证代码质量或检查项目健康状态时使用。
---

# Rust 项目测试验证流程

## 快速入门

### 基础测试命令

```bash
# 清理并编译
cargo clean
cargo build --release

# 运行所有测试
cargo test --workspace --all-features

# 代码质量检查
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo fmt --all -- --check

# 依赖安全检查
cargo audit
```

### 验证标准

- ✅ 所有测试通过
- ✅ 无编译警告
- ✅ Clippy 检查通过
- ✅ 测试覆盖率 ≥ 80%
- ✅ 无依赖安全漏洞

---

## 1️⃣ 基础编译与构建验证

### 清理并编译

```bash
# 清理构建缓存
cargo clean

# 编译项目（检查编译错误）
cargo build --release

# 检查所有 targets（包括 tests, benches, examples）
cargo check --all-targets --all-features
```

**验证标准**：
- ✅ 无编译错误
- ✅ 无编译警告
- ✅ 构建时间合理（大型项目 < 5 分钟）

---

### 运行单元测试

```bash
# 运行所有单元测试
cargo test --workspace

# 运行所有测试（包括文档测试）
cargo test --workspace --all-features

# 显示测试输出（包括 println!）
cargo test -- --nocapture

# 串行运行测试（避免资源冲突）
cargo test -- --test-threads=1
```

**验证标准**：
- ✅ 所有测试通过
- ✅ 无测试失败或 panic
- ✅ 测试覆盖关键功能

---

### 生成测试覆盖率报告

```bash
# 使用 tarpaulin 生成覆盖率报告
cargo tarpaulin --workspace --out Html --output-dir coverage

# 检查测试覆盖率是否达标（目标：80%+）
cargo tarpaulin --workspace --fail-under 80
```

**验证标准**：
- ✅ 总体覆盖率 ≥ 80%
- ✅ 关键模块覆盖率 ≥ 90%
- ✅ 公共 API 覆盖率 = 100%

---

## 2️⃣ 代码质量检查

### Clippy 静态代码分析

```bash
# Clippy 静态代码分析（Rust 官方 linter）
cargo clippy --workspace --all-targets --all-features -- -D warnings

# 检查 pedantic 规则（更严格）
cargo clippy --workspace --all-targets --all-features -- -W clippy::pedantic
```

**常见 Clippy 规则**：
- `clippy::unwrap_used`：禁止使用 `unwrap()`
- `clippy::expect_used`：禁止使用 `expect()`
- `clippy::panic`：禁止使用 `panic!()`
- `clippy::cognitive_complexity`：检查认知复杂度

**验证标准**：
- ✅ 无 Clippy 警告（`-D warnings` 模式）
- ✅ 无代码异味（code smells）
- ✅ 遵循 Rust 最佳实践

---

### 代码格式检查

```bash
# 代码格式检查
cargo fmt --all -- --check

# 自动格式化代码
cargo fmt --all
```

**验证标准**：
- ✅ 所有代码符合 rustfmt 标准
- ✅ 无格式不一致

---

### 依赖安全漏洞扫描

```bash
# cargo-audit 依赖安全检查
cargo audit

# 生成 JSON 格式报告
cargo audit --json
```

**验证标准**：
- ✅ 无高危漏洞
- ✅ 无中危漏洞（或已评估风险）
- ✅ 定期更新依赖

---

### 检查未使用的依赖

```bash
# 使用 cargo-machete 检查未使用的依赖
cargo machete

# 使用 cargo-udeps 检查未使用的依赖（需要 nightly）
cargo +nightly udeps --workspace
```

**验证标准**：
- ✅ 无未使用的依赖
- ✅ Cargo.toml 中的依赖都被实际使用

---

## 3️⃣ 性能基准测试

### Criterion 性能基准测试

```bash
# 运行所有基准测试
cargo bench --workspace

# 保存基线（用于对比）
cargo bench --workspace -- --save-baseline main

# 对比性能基准
cargo bench --workspace -- --baseline main
```

**验证标准**：
- ✅ 关键函数性能符合预期
- ✅ 无性能回归（与基线对比）
- ✅ 性能提升符合预期

---

### 性能验证标准（项目特定）

| 项目规模 | 代码行数 | 文件数 | 构建时间 | 扫描时间 | 内存使用 |
|---------|---------|--------|---------|---------|---------|
| 小型    | < 10K   | < 100  | < 1分钟 | < 30秒  | < 500MB |
| 中型    | 10K-50K | 100-500| < 5分钟 | < 2分钟 | < 2GB   |
| 大型    | > 50K   | > 500  | < 15分钟| < 5分钟 | < 4GB   |

---

## 4️⃣ 安全验证

### 查找硬编码密钥/密码

```bash
# 使用 ripgrep 查找敏感信息
rg -i "password|secret|api_key|token|private_key" crates/ --type rust

# 排除测试文件
rg -i "password|secret" crates/ --type rust --glob '!**/tests/**'
```

**验证标准**：
- ✅ 无硬编码的密码、密钥、token
- ✅ 敏感信息使用环境变量或配置文件
- ✅ 敏感信息不出现在日志中

---

### 检查 unsafe 代码块

```bash
# 查找所有 unsafe 代码块
rg "unsafe" crates/ --type rust

# 统计 unsafe 代码块数量
rg "unsafe" crates/ --type rust --count
```

**验证标准**：
- ✅ unsafe 代码块有详细的安全性注释
- ✅ unsafe 代码块经过严格审查
- ✅ 优先使用安全的替代方案

---

### 检查 unwrap/expect 使用

```bash
# 查找所有 unwrap() 和 expect()
rg "\.unwrap\(\)|\.expect\(" crates/ --type rust

# 排除测试文件
rg "\.unwrap\(\)|\.expect\(" crates/ --type rust --glob '!**/tests/**'
```

**验证标准**：
- ✅ 生产代码中无不必要的 `unwrap()`/`expect()`
- ✅ 优先使用 `?` 或 `match` 处理错误
- ✅ 仅在逻辑上不可能失败时使用 `unwrap()`

---

## 5️⃣ 集成测试与端到端测试

### 运行集成测试

```bash
# 运行所有集成测试
cargo test --workspace --test '*'

# 运行特定集成测试
cargo test --workspace --test integration_test

# 运行集成测试并显示输出
cargo test --workspace --test '*' -- --nocapture
```

**验证标准**：
- ✅ 所有集成测试通过
- ✅ 测试覆盖主要业务流程
- ✅ 测试数据清理正确

---

## 6️⃣ 验证检查清单

每次修改后必须确认以下检查清单：

### 基础验证
- [ ] ✅ 所有单元测试通过（`cargo test --workspace`）
- [ ] ✅ 测试覆盖率 ≥ 80%（关键模块 ≥ 90%）
- [ ] ✅ 无编译警告（`cargo build --release`）
- [ ] ✅ Clippy 检查通过（`cargo clippy -- -D warnings`）
- [ ] ✅ 代码格式化检查通过（`cargo fmt --check`）

### 安全验证
- [ ] ✅ 无依赖安全漏洞（`cargo audit`）
- [ ] ✅ 无硬编码密钥/密码
- [ ] ✅ unsafe 代码已充分审查
- [ ] ✅ 无不必要的 `unwrap()`/`expect()`

### 性能验证
- [ ] ✅ 性能无回归（基准测试不下降）
- [ ] ✅ 内存使用合理
- [ ] ✅ 并发性能符合预期

### 集成验证
- [ ] ✅ 集成测试通过
- [ ] ✅ 端到端测试通过
- [ ] ✅ 示例程序正常运行

---

## 7️⃣ 测试失败处理流程

### 记录失败信息

如果测试失败，记录到 `.agent/test_failures.log`：

```
[时间戳] 测试失败
文件：[修改的文件]
测试：[失败的测试名称]
错误：[错误信息]
堆栈：[堆栈跟踪]
```

### 回滚或修复

```bash
# 如果是代码问题，回滚变更
git reset --hard HEAD~1

# 或者修复问题后重新测试
cargo test --workspace --all-features
```

---

## 参考资料

详见 [PERFORMANCE.md](PERFORMANCE.md) 了解性能监控和分析工具。
详见 [SECURITY.md](SECURITY.md) 了解安全验证的详细说明。

---

**版本**：2.0.0（符合官方 Agent Skills 规范）  
**最后更新**：2025-12-02
