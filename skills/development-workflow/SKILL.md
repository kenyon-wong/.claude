---
name: development-workflow
description: 提供 Rust 项目的开发流程、构建命令、测试策略和代码质量检查标准。当需要构建项目、运行测试、执行代码质量检查或设置预提交钩子时使用此技能。
---

# 开发流程与命令

本技能提供 Rust 项目的完整开发工作流程指导，包括构建、测试、代码质量检查和预提交设置。

## 构建和测试命令

### 基础构建
```bash
# 开发构建
cargo build

# 发布构建（优化）
cargo build --release

# 项目特定编译命令（示例）
cargo build -p {your-project-cli}
```

### 测试命令
```bash
# 运行所有测试
cargo test --workspace

# 运行特定 crate 测试（示例）
cargo test -p {your-project-core}
cargo test -p {your-project-utils}
cargo test -p {your-project-cli}

# 带输出的测试
cargo test -- --nocapture

# 测试特定函数
cargo test test_function_name

# 包含被忽略的测试
cargo test -- --ignored

# 仅集成测试
cargo test --test integration

# 性能基准测试
cargo bench
```

### 文档生成
```bash
# 生成文档
cargo doc --workspace --no-deps

# 打开文档
cargo doc --workspace --no-deps --open
```

## 代码质量检查

### 格式化
```bash
# 格式化代码（提交前必须运行）
cargo fmt --all

# 检查格式化但不修改文件
cargo fmt --all -- --check
```

### Clippy 检查
```bash
# 运行 Clippy 检查（必须无警告通过）
cargo clippy --workspace --all-targets --all-features -- -D warnings

# 自动修复 Clippy 问题
cargo clippy --fix --workspace --allow-dirty

# 分别修复各个 crate（示例）
cargo fix --lib -p {your-project-utils} --allow-dirty
cargo fix --lib -p {your-project-core} --allow-dirty
cargo fix --bin "{your-project-binary}" --allow-dirty
```

## 项目特定质量检查

### 路径处理检查
```bash
# 检查正确的路径处理（避免 .display()）
python scripts/check_path_display.py
```

### 日志系统检查
```bash
# 检查正确的日志系统使用（使用零成本宏）
python scripts/check_pretty_log.py
```

### 错误处理检查
```bash
# 检查错误处理模式
bash scripts/check_error_handling.sh
```

### 综合质量检查
```bash
# 运行所有质量检查
python scripts/check_path_display.py && \
python scripts/check_pretty_log.py && \
bash scripts/check_error_handling.sh
```

## 预提交设置

### 安装预提交钩子
```bash
# 安装预提交钩子（推荐）
cp scripts/pre-commit-hook-example.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### 预提交检查内容
- 代码格式化检查
- Clippy 警告检查
- 测试通过检查
- 项目特定质量检查

## 测试策略

### 测试结构
- **单元测试**: 在各 crate 的 `src/` 模块中，使用 `#[cfg(test)]`
- **集成测试**: 在 `tests/` 目录中进行跨模块测试
- **基准测试**: 在 `benches/` 目录中进行性能测试
- **测试数据**: 测试数据在 `tests/fixtures/` 中

### 异步测试
```rust
// 主函数
#[tokio::main]
async fn main() -> Result<()> {
    // 异步操作
}

// 测试函数
#[tokio::test]
async fn test_async_function() {
    // 测试异步代码
}
```

## 环境变量

### 开发环境变量
- `RUST_LOG`: 控制日志级别（如 `debug`, `info`）
- 其他项目特定环境变量（根据需要配置）
- `SKIP_PERFORMANCE_TESTS`: 跳过性能基准测试

### 测试配置
- 使用 `config.macos.toml` 进行本地测试
- 忽略 GitHub 网络访问问题

## 部署构建

### 目标平台
项目构建为单个优化二进制文件，支持：
- Linux (x86_64, aarch64)
- macOS (Intel, Apple Silicon)
- Windows (x86_64)

### 优化配置
- 发布构建使用 LTO（链接时优化）
- 支持配置文件引导优化
- 零成本抽象最小化运行时开销
