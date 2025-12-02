# Git 提交示例和 Hooks 配置

本文档提供详细的提交示例和 Git Hooks 配置。

---

## 详细提交示例

### 性能优化示例

```
perf(analyzer): 优化算法复杂度从 O(n²) 到 O(n)

问题：嵌套循环导致大数据量时性能急剧下降
优化：使用 HashSet 替代嵌套循环查找
效果：1000 个文件从 5s → 50ms（100 倍提升）
```

### 重构示例

```
refactor(logging): 合并 emoji 模块，减少文件碎片化

将分散的 emoji 相关代码合并到单一模块。
删除未使用的导入和函数。
提升代码可维护性。
```

### 修复安全问题示例

```
fix(security): 修复命令注入漏洞 (crates/core/src/git/mod.rs:L45)

问题：使用字符串拼接构建 git 命令，存在命令注入风险
修复：使用 Command::arg() 方法，避免 shell 解析
验证：添加单元测试，确保特殊字符被正确转义

风险等级：🔴 高
影响范围：所有使用 git 命令的功能
```

### 依赖更新示例

```
chore(deps): 更新 tokio 到 1.35.0，修复安全漏洞

更新原因：tokio 1.20.0 存在安全漏洞 (RUSTSEC-2023-0001)
更新内容：tokio 1.20.0 → 1.35.0
影响：无 API 变更，向后兼容
验证：所有测试通过
```

---

## Git Hooks 配置

### Pre-commit Hook

在 `.git/hooks/pre-commit` 中添加：

```bash
#!/bin/bash

# 运行代码格式检查
cargo fmt --all -- --check
if [ $? -ne 0 ]; then
    echo "❌ 代码格式检查失败，请运行 cargo fmt"
    exit 1
fi

# 运行 Clippy 检查
cargo clippy --workspace --all-targets --all-features -- -D warnings
if [ $? -ne 0 ]; then
    echo "❌ Clippy 检查失败"
    exit 1
fi

echo "✅ Pre-commit 检查通过"
```

### Commit-msg Hook

在 `.git/hooks/commit-msg` 中添加：

```bash
#!/bin/bash

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# 检查提交信息格式
if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert|review)\(.+\): .+"; then
    echo "❌ 提交信息格式错误"
    echo "格式：<type>(<scope>): <中文描述>"
    echo "示例：feat(scanner): 添加并行扫描支持"
    exit 1
fi

# 检查是否使用中文描述
if ! echo "$commit_msg" | grep -qP "[\p{Han}]"; then
    echo "❌ 描述必须使用中文"
    exit 1
fi

# 检查是否包含禁止的内容
if echo "$commit_msg" | grep -qE "(Co-Authored-By|Generated-By|Signed-off-by)"; then
    echo "❌ 禁止添加 AI 签名或无意义的 footer"
    exit 1
fi

echo "✅ 提交信息格式正确"
```

---

## 提交流程

### 1. 提交前检查

```bash
# 查看变更
git status
git diff

# 暂存变更
git add <files>

# 检查暂存的变更
git diff --staged
```

### 2. 编写提交信息

```bash
# 使用编辑器编写详细的提交信息
git commit

# 或者简短的提交信息
git commit -m "feat(scanner): 添加并行扫描支持"
```

### 3. 提交后检查

```bash
# 查看最近的提交
git log -1

# 查看提交详情
git show HEAD

# 如果需要修改提交信息
git commit --amend
```

---

**版本**：2.0.0  
**最后更新**：2025-12-02
