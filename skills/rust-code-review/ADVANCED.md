# 高级审查维度（P3 阶段）

本文档包含 P3 阶段的可选优化审查维度。

---

## 13. 技术债务

### 检查要点

- 不符合 Rust 代码规范的实现
- 性能瓶颈和资源使用效率低下
- 缺乏适当错误处理的代码段
- 测试覆盖率不足的关键功能
- 过多的 `clone()` 调用

### 示例

```rust
// ❌ 技术债务：过多的 clone()
fn process_data(data: Vec<String>) -> Vec<String> {
    let cloned = data.clone();  // 不必要的克隆
    cloned.iter().map(|s| s.to_uppercase()).collect()
}

// ✅ 优化：使用借用
fn process_data(data: &[String]) -> Vec<String> {
    data.iter().map(|s| s.to_uppercase()).collect()
}
```

---

## 14. 过度设计与简洁性（YAGNI 原则）

### 检查要点

- **过度抽象**：不必要的 trait 和泛型
- **未使用的功能**：实现了但从未被调用的代码
- **过早优化**：没有性能瓶颈时的复杂优化
- **配置过度**：过多的可配置项
- **依赖膨胀**：不必要的依赖

### 示例

```rust
// ❌ 过度设计：不必要的泛型
trait DataProcessor<T, U, V> {
    fn process(&self, input: T) -> Result<U, V>;
}

// ✅ 简洁：具体类型
trait DataProcessor {
    fn process(&self, input: &str) -> Result<String, Error>;
}
```

---

## 15. 用户体验与直觉性（CLI 工具设计）

### CLI 参数设计

**检查要点**：
- 参数命名清晰
- 提供简短和完整形式（`-h` / `--help`）
- 默认值合理

**示例**：
```rust
use clap::Parser;

#[derive(Parser)]
struct Cli {
    /// 扫描目标目录
    #[arg(short, long, default_value = ".")]
    path: String,
    
    /// 输出格式 [json, text, html]
    #[arg(short, long, default_value = "text")]
    format: String,
}
```

### 错误提示

**检查要点**：
- 错误消息清晰、可操作
- 提供具体的错误原因
- 提供解决建议

**示例**：
```rust
// ❌ 不好的错误提示
return Err("配置错误".into());

// ✅ 好的错误提示
return Err(format!(
    "配置文件 '{}' 不存在。请运行 'init' 命令创建配置文件。",
    config_path.display()
).into());
```

### 进度反馈

使用 `indicatif` 显示进度条：

```rust
use indicatif::{ProgressBar, ProgressStyle};

let pb = ProgressBar::new(files.len() as u64);
pb.set_style(ProgressStyle::default_bar()
    .template("[{elapsed_precise}] {bar:40.cyan/blue} {pos}/{len} {msg}")
    .unwrap());

for file in files {
    pb.set_message(format!("处理: {}", file.display()));
    // 处理文件
    pb.inc(1);
}
pb.finish_with_message("完成");
```

### 跨平台兼容性

**检查要点**：
- 路径分隔符（使用 `std::path::Path`）
- 换行符（使用 `\n`，让系统处理）
- 文件权限（Windows 不支持 Unix 权限）

---

## 16. 可观测性与调试性（tracing 框架）

### 日志规范

**日志级别使用**：
```rust
use tracing::{error, warn, info, debug, trace};

// error!：错误，需要立即关注
error!("数据库连接失败: {}", err);

// warn!：警告，可能的问题
warn!("配置文件缺少可选字段: {}", field);

// info!：重要信息
info!("开始扫描目录: {}", path.display());

// debug!：调试信息
debug!("解析配置: {:?}", config);

// trace!：详细追踪
trace!("处理文件: {}", file.display());
```

### 结构化日志

使用 `tracing::span!` 和 `tracing::event!`：

```rust
use tracing::{info_span, info};

let span = info_span!("scan_repository", repo = %repo_path);
let _enter = span.enter();

info!(files = files.len(), "开始扫描");
// 扫描逻辑
info!(issues = issues.len(), "扫描完成");
```

### 性能指标

暴露关键性能指标：

```rust
use std::time::Instant;

let start = Instant::now();
// 执行操作
let duration = start.elapsed();

info!(
    duration_ms = duration.as_millis(),
    "操作完成"
);
```

### 错误追踪

使用 `anyhow` 或 `eyre` 提供错误链：

```rust
use anyhow::{Context, Result};

fn read_config() -> Result<Config> {
    let content = std::fs::read_to_string("config.toml")
        .context("读取配置文件失败")?;
    
    toml::from_str(&content)
        .context("解析配置文件失败")
}
```

---

## 审查工具

### 代码复杂度分析

```bash
# 使用 tokei 统计代码行数
tokei

# 使用 scc 分析代码复杂度
scc
```

### 性能分析

```bash
# 生成火焰图
cargo flamegraph --bin codeql-scanner

# 使用 perf（Linux）
perf record -g ./target/release/codeql-scanner
perf report
```

---

**版本**：2.0.0  
**最后更新**：2025-12-02
