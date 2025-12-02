---
name: git-commands
description: Git 命令操作指南和最佳实践。包括 --no-pager 参数使用、Windows 环境提交方法、分支管理、Git 别名配置、完整工作流程示例。当需要执行 Git 命令、管理分支、查看历史或处理 Git 日常操作时使用。
---

# Git 命令操作指南

本技能提供 Git 日常命令操作的完整指南，包括参数使用、平台兼容性、别名配置和工作流程最佳实践。

---

## 核心规则

### 1. 查看类命令必须使用 --no-pager

**原因**：避免进入交互式分页模式，导致工作流程卡顿

**⚠️ 重要：--no-pager 参数的位置**

`--no-pager` 是 git 命令本身的选项，**必须紧跟在 git 后面**，不能放在子命令的选项后面：

```bash
# ✅ 正确位置：git --no-pager <子命令> [选项]
git --no-pager log --oneline
git --no-pager diff HEAD~1 HEAD
git --no-pager show abc123

# ❌ 错误位置：git <子命令> --no-pager [选项]
git log --no-pager --oneline     # 虽然某些版本可能工作，但不规范
git diff --no-pager HEAD~1       # 不规范的写法
```

**适用命令**：
- `git --no-pager diff` - 查看文件差异
- `git --no-pager show` - 查看提交详情
- `git --no-pager log` - 查看提交历史，推荐使用 `--oneline` 获得简洁输出
- `git --no-pager blame` - 查看文件修改历史
- `git --no-pager branch` - 列出分支（带 `-v` 或 `-vv` 时）
- `git status` - 推荐使用 `--short` 获得简洁输出（status 不需要 --no-pager）

**示例**：

```bash
# ❌ 错误：可能进入交互模式
git log
git diff

# ✅ 正确：直接输出所有内容
git --no-pager log --oneline
git --no-pager diff

# 查看状态（简洁输出，不需要 --no-pager）
git status --short

# 查看最近5次提交
git --no-pager log --oneline -5

# 查看文件差异
git --no-pager diff HEAD~1 HEAD

# 查看特定提交
git --no-pager show abc123

# 查看文件修改历史
git --no-pager blame src/main.rs

# 查看分支详情
git --no-pager branch -vv
```

---

### 2. Windows 环境下提交使用 -F 参数

**原因**：避免空格、换行、引号等特殊字符在 cmd 终端下的兼容性问题

**错误方式**：
```cmd
REM ❌ 错误：引号和换行符可能导致问题
git commit -m "fix: 修复问题"

REM ❌ 错误：多行消息在 cmd 中难以处理
git commit -m "feat: 添加新功能

- 支持新特性
- 优化性能"
```

**正确方式**：

```bash
# 1. 创建 commit.log 文件
echo "feat: 添加新功能

- 支持新特性
- 优化性能" > commit.log

# 2. 使用 -F 参数提交
git commit -F commit.log

# 3. 提交后删除临时文件
rm commit.log
```

**重要注意事项**：
1. ⚠️ **不要将 commit.log 添加到 Git**
2. ⚠️ **提交后必须删除 commit.log**
3. 💡 **建议添加到 .gitignore**：
   ```gitignore
   # 在项目根目录的 .gitignore 中添加
   commit.log
   ```

---

## 常用命令模板

### 查看状态和历史

```bash
# 查看工作区状态（简洁输出）
git status --short

# 查看工作区状态（详细输出）
git status

# 查看最近提交（简洁格式）
git --no-pager log --oneline -10

# 查看分支图
git --no-pager log --graph --oneline --all -20

# 查看文件修改
git --no-pager diff

# 查看暂存区修改
git --no-pager diff --cached
```

---

### 提交代码

```bash
# 1. 添加文件
git add src/main.rs

# 2. 提交（推荐使用 -F 参数）
git commit -F commit.log
rm commit.log

# 修改最近的提交
git commit --amend

# 查看提交历史
git --no-pager log --oneline
```

---

### 分支操作

```bash
# 查看分支
git --no-pager branch

# 创建并切换分支
git checkout -b feature/new-feature

# 切换分支
git checkout main

# 合并分支（保留分支历史）
git merge feature/new-feature --no-ff --no-edit

# 删除已合并的分支
git branch -d feature/new-feature

# 强制删除分支（未合并）
git branch -D feature/new-feature
```

---

### 远程操作

```bash
# 拉取更新
git pull origin main

# 推送代码
git push origin main

# 查看远程仓库
git remote -v
```

---

## Git 别名配置

### 可用的别名

以下是常用的 Git 别名配置：

```gitconfig
[alias]
co = checkout                    # 切换分支
a = add -p                       # 交互式添加
b = branch                       # 分支操作
cp = cherry-pick                 # 挑选提交
d = diff                         # 查看差异
l = log                          # 查看日志
m = merge                        # 合并分支
p = push                         # 推送
pwl = push --force-with-lease    # 安全的强制推送
lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit  # 美化日志
```

### 别名使用示例

```bash
# 切换分支
git co main
git co -b feature/new-feature

# 查看分支
git b

# 查看美化的提交历史（仍需在 git 后添加 --no-pager）
git --no-pager lg -10

# 查看差异（仍需在 git 后添加 --no-pager）
git --no-pager d

# 合并分支
git m feature/branch --no-ff --no-edit

# 推送
git p origin main
```

---

## 分支管理最佳实践

### 合并策略

```bash
# ✅ 正确：使用 --no-ff 保留分支历史
git merge feature/new-feature --no-ff --no-edit

# ❌ 避免：快进合并（丢失分支历史）
git merge feature/new-feature
```

### 合并前检查

1. **运行所有测试**：
   ```bash
   # Rust 项目
   cargo test

   # Java 项目
   mvn test
   ```

2. **检查代码风格**：
   ```bash
   # Rust
   cargo clippy

   # Java
   mvn compile
   ```

3. **确认无冲突**：
   ```bash
   git status --short
   ```

### 合并后清理

```bash
# 合并完成后删除功能分支
git branch -d feature/new-feature

# 推送删除到远程
git push origin --delete feature/new-feature
```

---

## 完整工作流程示例

### 功能分支完整流程

```bash
# 1. 创建功能分支
git checkout -b feature/new-feature

# 2. 开发和提交
git add .
git commit -F commit.log
rm commit.log

# 3. 切换回主分支
git checkout main

# 4. 合并（保留分支历史）
git merge feature/new-feature --no-ff --no-edit

# 5. 运行测试确认
cargo test  # 或 mvn test

# 6. 删除功能分支
git branch -d feature/new-feature

# 7. 推送
git push origin main
```

---

### 使用别名的工作流程

```bash
# 1. 创建并切换分支
git co -b feature/new-feature

# 2. 查看状态
git status --short

# 3. 添加文件
git add src/main.rs

# 4. 提交
git commit -F commit.log
rm commit.log

# 5. 切换回主分支
git co main

# 6. 合并（保留分支历史）
git m feature/new-feature --no-ff --no-edit

# 7. 查看美化的提交历史
git --no-pager lg -5

# 8. 推送
git p origin main

# 9. 删除分支
git b -d feature/new-feature
```

---

## 最佳实践总结

1. **查看命令加 --no-pager**：
   - 避免交互式分页模式
   - `--no-pager` 必须紧跟在 `git` 后面

2. **Windows 提交用 -F**：
   - 避免特殊字符问题
   - 使用 commit.log 文件
   - 提交后删除临时文件

3. **分支管理**：
   - 使用 `--no-ff` 合并保留分支历史
   - 合并前确保通过所有测试
   - 合并后删除已合并的功能分支

4. **别名使用**：
   - 使用别名简化常用命令
   - 查看类命令仍需加 `--no-pager`

5. **小步提交**：
   - 每个提交只包含一个逻辑变更
   - 提交消息遵循 Conventional Commits 规范
   - 提交前确保代码编译通过、测试通过

---

## 参考资料

- 提交规范详见：[git-commit](../git-commit/SKILL.md)
- [Git Book](https://git-scm.com/book/zh/v2)
- [Git Aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)

---

**版本**：1.0.0  
**最后更新**：2025-12-02  
**来源**：提取自 git-standards，专注命令操作
