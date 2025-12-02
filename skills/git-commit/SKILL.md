---
name: git-commit
description: Git 提交规范和标准。定义 Conventional Commits 格式、类型、scope、描述规则，包含代码审查专用类型。当需要创建 Git 提交、编写提交信息或检查提交规范时使用。
---

# Git 提交规范

## 快速入门

### Commit 基本格式

```
<type>(<scope>): <中文描述>

[可选的详细说明]
```

**核心要求**：
- `type` 和 `scope` 使用英文
- `description` 必须使用中文
- 描述要具体，说明改动内容和原因
- **严格禁止添加任何 AI 签名、footer 或 "Co-Authored-By"**

### 常用命令

```bash
# 简短提交
git commit -m "feat(scanner): 添加并行扫描支持"

# 详细提交（使用编辑器）
git commit

# 修改最近的提交
git commit --amend

# 查看提交历史
git log --oneline
```

---

## Commit 类型（Type）

### 通用类型

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(scanner): 添加并行扫描支持` |
| `fix` | 修复 bug | `fix(parser): 修复 JSON 解析错误` |
| `docs` | 文档变更 | `docs(readme): 更新安装说明` |
| `style` | 代码格式 | `style(core): 统一代码缩进格式` |
| `refactor` | 重构 | `refactor(logging): 合并 emoji 模块` |
| `perf` | 性能优化 | `perf(analyzer): 优化算法复杂度` |
| `test` | 测试相关 | `test(scanner): 添加边界条件测试` |
| `chore` | 构建/工具/依赖 | `chore(deps): 更新 tokio 到 1.35.0` |
| `ci` | CI/CD 配置 | `ci(github): 添加自动化测试流程` |

### 代码审查专用类型

| Type | 说明 | 示例 |
|------|------|------|
| `review(security)` | 安全审查报告 | `review(security): 完成 P0 阶段安全漏洞审查` |
| `review(performance)` | 性能审查报告 | `review(performance): 完成算法复杂度评估` |
| `review(architecture)` | 架构审查报告 | `review(architecture): 完成架构设计审查` |

---

## Scope 范围

常见 Scope：`core`, `cli`, `scanner`, `parser`, `analyzer`, `utils`, `config`, `deps`, `docs`, `tests`, `ci`, `security`, `performance`

**规则**：
- 单一 Scope：一个 commit 只影响一个 scope
- 多个 Scope：使用 `*` 或最主要的 scope
- 无 Scope：全局性变更可以省略

---

## 描述规则

1. **使用中文**：描述必须使用简体中文
2. **简洁明了**：一句话说明改动内容
3. **动词开头**：使用动词开头（添加、修复、优化、重构等）
4. **具体化**：说明具体改动了什么
5. **包含原因**：如果有必要，说明为什么改动

### 好的描述示例

✅ **好的描述**：
- `feat(scanner): 添加并行扫描支持，提升大项目扫描速度 3 倍`
- `fix(parser): 修复 JSON 解析时的 Unicode 转义问题`
- `perf(analyzer): 优化算法复杂度从 O(n²) 到 O(n)`

❌ **不好的描述**：
- `fix: 修复 bug`（太泛泛）
- `update`（没说明更新了什么）
- `WIP`（工作进行中，不应提交）

---

## 严格禁止事项

1. **禁止 AI 签名**：
   ```
   ❌ 禁止：Co-Authored-By: AI Assistant
   ```

2. **禁止英文描述**：
   ```
   ❌ 禁止：feat(scanner): Add parallel scanning
   ✅ 正确：feat(scanner): 添加并行扫描支持
   ```

3. **禁止无意义的提交**：
   ```
   ❌ 禁止：fix, update, WIP, test
   ```

---

## 完整示例

### 示例 1：新功能

```
feat(scanner): 添加并行扫描支持，提升大项目扫描速度 3 倍

使用 rayon 实现文件并行扫描，充分利用多核 CPU。
添加并发控制和进度显示，改善用户体验。
```

### 示例 2：Bug 修复

```
fix(parser): 修复 JSON 解析时的 Unicode 转义问题

问题：JSON 中的 Unicode 转义序列（\uXXXX）未正确解析
原因：使用了错误的正则表达式
修复：使用 serde_json 的标准解析器
```

### 示例 3：代码审查报告

```
review(security): 完成 P0 阶段安全漏洞审查，发现 3 个高优先级问题

审查范围：命令注入、路径遍历、依赖漏洞、敏感数据检查

发现问题：
- 🔴 高：命令注入漏洞 (crates/core/src/git/mod.rs:L45)
- 🔴 高：路径遍历漏洞 (crates/core/src/scanner/mod.rs:L78)
- 🟡 中：依赖漏洞 (tokio 1.20.0)

详细报告：.agent/review_security.md
```

---

## 提交最佳实践

1. **原子化提交**：每个提交只做一件事
2. **频繁提交**：完成一个小功能就提交
3. **提交前测试**：确保代码编译通过、测试通过
4. **有意义的提交信息**：描述清晰、具体
5. **关联 Issue**：使用 `#123` 格式引用相关 Issue

---

## 参考资料

详见 [EXAMPLES.md](EXAMPLES.md) 了解更多提交示例和 Git Hooks 配置。

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)

---

**版本**：2.0.0（符合官方 Agent Skills 规范）  
**最后更新**：2025-12-02
