# 性能监控和分析工具

本文档提供详细的性能监控和分析工具使用说明。

---

## 使用 cargo-flamegraph 生成火焰图

```bash
# 安装 cargo-flamegraph
cargo install flamegraph

# 生成火焰图（Linux/macOS）
cargo flamegraph --bin codeql-scanner -- scan /path/to/project

# 生成火焰图（Windows，需要 WPA）
cargo flamegraph --bin codeql-scanner -- scan /path/to/project
```

---

## 使用 valgrind/callgrind 进行性能分析（Linux）

```bash
# 构建 release 版本
cargo build --release

# 使用 callgrind 分析性能
valgrind --tool=callgrind ./target/release/codeql-scanner scan /path/to/project

# 查看 callgrind 结果
kcachegrind callgrind.out.*
```

---

## 使用 perf 进行性能分析（Linux）

```bash
# 记录性能数据
perf record -g ./target/release/codeql-scanner scan /path/to/project

# 查看性能报告
perf report

# 生成火焰图
perf script | stackcollapse-perf.pl | flamegraph.pl > flamegraph.svg
```

---

## 内存使用分析

```bash
# 使用 valgrind massif 分析内存使用
valgrind --tool=massif ./target/release/codeql-scanner scan /path/to/project

# 查看 massif 结果
ms_print massif.out.*

# 使用 heaptrack 分析内存（Linux）
heaptrack ./target/release/codeql-scanner scan /path/to/project
heaptrack_gui heaptrack.codeql-scanner.*.gz
```

---

## 自动化测试报告

测试完成后生成报告：`.agent/test_report.md`

```markdown
# 测试报告

**测试时间**：[时间戳]
**提交哈希**：[Git commit hash]

## 测试结果摘要
- ✅ 单元测试：XX/XX 通过
- ✅ 集成测试：XX/XX 通过
- ✅ 覆盖率：XX%
- ✅ 性能测试：通过

## 详细结果

### 单元测试
[详细测试结果]

### 集成测试
[详细测试结果]

### 性能测试
[性能基准对比]

## 问题列表
[如果有失败的测试]

## 建议
[改进建议]
```

---

**版本**：2.0.0  
**最后更新**：2025-12-02
