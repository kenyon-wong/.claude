# 改进计划

基于 Claude 最佳实践审查报告，本文档提供具体的改进步骤和实施方案。

---

## 📋 改进任务清单

### 🔴 高优先级任务（必须完成）

#### 任务 1：优化 CLAUDE.md 文件

**目标**：使 CLAUDE.md 符合官方最佳实践

**具体步骤**：

1. **添加项目结构图**
   ```markdown
   ## 项目结构
   
   ```
   .claude/
   ├── agents/                    # 专用 AI agents
   │   ├── claude-md-guardian.md  # CLAUDE.md 维护 agent
   │   ├── java-pro.md           # Java 专家 agent
   │   └── rust-pro.md           # Rust 专家 agent
   ├── commands/                  # 自定义 slash commands
   │   └── enhance-claude-md/    # CLAUDE.md 增强命令
   ├── hooks/                     # Git hooks
   │   └── prepare-commit-msg.sh # 提交信息清理
   ├── skills/                    # 可复用 skills（20+ skills）
   │   ├── agent-workflow/       # Agent 执行流程
   │   ├── git-commit/           # Git 提交规范
   │   ├── rust-code-review/     # Rust 代码审查
   │   └── ...                   # 其他 skills
   ├── CLAUDE.md                 # 主配置文件
   ├── README.md                 # 项目说明
   └── settings.json             # 项目设置
   ```
   ```

2. **添加 Setup & Installation 章节**
   ```markdown
   ## 安装与设置
   
   ### 前置条件
   - Claude Code 2.0+
   - Git
   - 对应语言的开发环境（Rust/Java/Python 等）
   
   ### 安装步骤
   
   1. **克隆或复制到项目**
      ```bash
      # 方式 1：克隆整个仓库
      git clone <repo-url> .claude
      
      # 方式 2：复制到现有项目
      cp -r /path/to/.claude /path/to/your/project/
      ```
   
   2. **自定义配置**
      - 编辑 `CLAUDE.md` 以适应你的项目
      - 选择需要的 Skills 和 Agents
      - 配置 `settings.json`
   
   3. **安装 Git Hooks（可选）**
      ```bash
      # 复制 hooks 到 .git/hooks/
      cp hooks/prepare-commit-msg.sh .git/hooks/
      chmod +x .git/hooks/prepare-commit-msg.sh
      ```
   
   4. **验证安装**
      ```bash
      # 在 Claude Code 中运行
      /enhance-claude-md
      ```
   
   ### 快速开始
   
   1. 打开 Claude Code
   2. 运行 `/enhance-claude-md` 初始化或增强 CLAUDE.md
   3. 使用 `#` 键添加项目特定的指令
   4. 开始使用 AI 辅助开发
   ```

3. **添加 Common Commands 章节**
   ```markdown
   ## 常用命令
   
   ### 开发命令
   
   #### Rust 项目
   ```bash
   # 构建
   cargo build --workspace
   
   # 测试
   cargo test --workspace --all-features
   
   # 代码检查
   cargo clippy --workspace --all-targets --all-features -- -D warnings
   
   # 格式化
   cargo fmt --all
   
   # 安全审计
   cargo audit
   ```
   
   #### Java 项目
   ```bash
   # Maven
   mvn clean install
   mvn test
   mvn verify
   
   # Gradle
   ./gradlew build
   ./gradlew test
   ```
   
   ### Git 命令
   ```bash
   # 查看最近提交（禁用分页器）
   git --no-pager log --oneline -10
   
   # 查看变更
   git --no-pager diff
   
   # 查看特定提交
   git --no-pager show HEAD
   
   # 提交（使用文件避免 Windows 兼容性问题）
   git commit -F commit_msg.txt
   ```
   
   ### Claude Code 命令
   ```bash
   # 增强 CLAUDE.md
   /enhance-claude-md
   
   # 调用专用 agent
   /invoke rust-pro
   /invoke java-pro
   ```
   ```

4. **简化文件长度**
   - 将 "Linus 哲学" 部分移到单独的 `docs/philosophy.md`
   - 将详细的工具使用说明移到 `docs/tools.md`
   - CLAUDE.md 只保留核心内容和快速参考

**预期结果**：
- CLAUDE.md 文件长度 < 150 行
- 包含所有必要章节
- 结构清晰，易于理解

**预计耗时**：2 小时

---

#### 任务 2：完善 README.md

**目标**：提供完整的项目介绍和使用指南

**具体内容**：

```markdown
# .claude - Claude Code 配置与扩展集合

一个全面的 Claude Code 配置仓库，包含 Skills、Agents、Commands 和 Hooks，用于提升 AI 辅助开发体验。

## ✨ 特性

- 📚 **20+ Skills**：涵盖代码审查、Git 规范、测试流程等
- 🤖 **专用 Agents**：Rust、Java 专家 agent，CLAUDE.md 维护 agent
- ⚡ **自定义 Commands**：快速初始化和增强 CLAUDE.md
- 🔧 **Git Hooks**：自动清理 AI 签名，保持提交历史整洁
- 🌍 **多语言支持**：Rust、Java、Python 等

## 📦 包含内容

### Skills（可复用技能）
- `agent-workflow` - AI Agent 执行流程规范
- `git-commit` - Git 提交规范（Conventional Commits）
- `rust-code-review` - Rust 代码审查标准（17 个维度）
- `rust-testing` - Rust 测试验证流程
- `java-coding-style` - Java 编码规范
- `progress-tracking` - 进度追踪文件模板
- 更多...（共 20+ skills）

### Agents（专用 AI 助手）
- `rust-pro` - Rust 1.75+ 专家，精通 async、性能优化
- `java-pro` - Java 21+ 专家，精通 Spring Boot、虚拟线程
- `claude-md-guardian` - 自动维护 CLAUDE.md 文件

### Commands（自定义命令）
- `/enhance-claude-md` - 初始化或增强 CLAUDE.md 文件

### Hooks（Git 钩子）
- `prepare-commit-msg` - 自动移除 AI 签名

## 🚀 快速开始

### 安装

```bash
# 克隆到你的项目
git clone <repo-url> .claude

# 或复制到现有项目
cp -r /path/to/.claude /path/to/your/project/
```

### 使用

1. **初始化 CLAUDE.md**
   ```bash
   # 在 Claude Code 中运行
   /enhance-claude-md
   ```

2. **使用 Skills**
   ```markdown
   # 在 prompt 中引用
   参考 `.claude/skills/rust-code-review/SKILL.md` 进行代码审查
   ```

3. **调用 Agents**
   ```bash
   # 在 Claude Code 中
   /invoke rust-pro
   ```

4. **安装 Git Hooks**
   ```bash
   cp hooks/prepare-commit-msg.sh .git/hooks/
   chmod +x .git/hooks/prepare-commit-msg.sh
   ```

## 📖 文档

- [CLAUDE.md](CLAUDE.md) - 主配置文件
- [Skills 索引](skills/README.md) - 所有 Skills 的详细说明
- [Agents 说明](agents/) - 各个 Agent 的使用文档
- [Commands 文档](commands/) - 自定义命令说明

## 🎯 使用场景

### Rust 项目开发
1. 使用 `rust-pro` agent 进行代码审查
2. 参考 `rust-code-review` skill 的审查标准
3. 使用 `rust-testing` skill 的测试流程
4. 遵循 `git-commit` skill 的提交规范

### Java 项目开发
1. 使用 `java-pro` agent 进行代码审查
2. 参考 `java-coding-style` skill 的编码规范
3. 遵循 `git-commit` skill 的提交规范

### 通用开发
1. 使用 `agent-workflow` skill 管理 AI 任务执行
2. 使用 `progress-tracking` skill 追踪任务进度
3. 使用 `git-commit` skill 规范提交信息

## 🔧 自定义

### 添加自己的 Skill

1. 创建目录：`.claude/skills/my-skill/`
2. 创建主文件：`SKILL.md`，包含 YAML front matter
3. 在 `skills/README.md` 中添加索引

### 添加自己的 Agent

1. 创建文件：`.claude/agents/my-agent.md`
2. 包含 YAML front matter（name, description, model, tools）
3. 定义 agent 的能力和行为

### 添加自己的 Command

1. 创建目录：`.claude/commands/my-command/`
2. 创建主文件：`my-command.md`，包含 YAML front matter
3. 定义命令的执行逻辑

## 🤝 贡献

欢迎贡献新的 Skills、Agents 或 Commands！

1. Fork 本仓库
2. 创建特性分支
3. 提交变更（遵循 Conventional Commits）
4. 发起 Pull Request

## 📄 许可证

[MIT License](LICENSE)

## 🙏 致谢

- [Anthropic](https://www.anthropic.com/) - Claude 和 Claude Code
- [Anthropic Skills](https://github.com/anthropics/skills) - Skills 规范参考
- [Anthropic Claude Code](https://github.com/anthropics/claude-code) - 官方示例

---

**版本**：1.0.0  
**最后更新**：2025-12-02  
**维护者**：项目团队
```

**预计耗时**：1 小时

---

#### 任务 3：统一 claudeforge-skill 命名

**目标**：解决命名不一致问题

**方案选择**：

**方案 A：重命名目录**（推荐）
```bash
mv skills/claudeforge-skill skills/claude-md-enhancer
```

**方案 B：修改 YAML front matter**
```yaml
---
name: claudeforge-skill
description: ...
---
```

**推荐**：方案 A，因为 `claude-md-enhancer` 更准确地描述了功能

**需要同步修改的文件**：
- `skills/README.md` - 更新索引
- `commands/enhance-claude-md/enhance-claude-md.md` - 更新引用
- `commands/enhance-claude-md/README.md` - 更新引用
- `agents/claude-md-guardian.md` - 更新引用

**预计耗时**：30 分钟

---

### 🟡 中优先级任务（建议完成）

#### 任务 4：为 Agents 添加使用示例

**目标**：让用户知道如何调用和使用 Agents

**需要修改的文件**：
- `agents/rust-pro.md`
- `agents/java-pro.md`
- `agents/claude-md-guardian.md`

**添加内容模板**：

```markdown
## 使用示例

### 通过聊天调用

```
Hey Claude, 我需要审查这段 Rust 代码的性能问题。请使用 rust-pro agent。
```

### 通过命令调用

```bash
/invoke rust-pro
```

### 典型使用场景

#### 场景 1：代码审查
```
使用 rust-pro 审查 src/main.rs 的内存安全问题
```

#### 场景 2：性能优化
```
rust-pro，帮我优化这个算法的时间复杂度
```

#### 场景 3：架构设计
```
rust-pro，评估这个微服务架构的设计是否合理
```

### 与其他 Agents 协作

- 与 `claude-md-guardian` 协作：完成功能后自动更新 CLAUDE.md
- 与其他开发 agents 协作：分工处理不同模块
```

**预计耗时**：1.5 小时

---

#### 任务 5：添加更多 Commands

**目标**：提供更多实用的自定义命令

**建议添加的 Commands**：

1. **`/code-review`** - 快速代码审查
   ```markdown
   ---
   allowed-tools: Bash, Read, Grep, Skill
   description: 快速代码审查，自动检测语言并应用相应的审查标准
   ---
   
   # Code Review Command
   
   ## Phase 1: Discovery
   - 检测项目语言（Rust/Java/Python）
   - 查找最近修改的文件
   
   ## Phase 2: Analysis
   - 根据语言选择审查标准
   - 确定审查范围
   
   ## Phase 3: Task
   - 调用对应的 agent（rust-pro/java-pro）
   - 应用对应的 skill（rust-code-review/java-coding-style）
   - 生成审查报告
   ```

2. **`/test-coverage`** - 测试覆盖率检查
   ```markdown
   ---
   allowed-tools: Bash, Read
   description: 检查测试覆盖率并生成报告
   ---
   
   # Test Coverage Command
   
   ## Phase 1: Discovery
   - 检测项目类型
   - 查找测试文件
   
   ## Phase 2: Analysis
   - 运行覆盖率工具
   - 分析覆盖率数据
   
   ## Phase 3: Task
   - 生成覆盖率报告
   - 标识未覆盖的代码
   - 提供改进建议
   ```

3. **`/security-scan`** - 安全扫描
   ```markdown
   ---
   allowed-tools: Bash, Read, Grep
   description: 扫描常见安全漏洞
   ---
   
   # Security Scan Command
   
   ## Phase 1: Discovery
   - 检测项目语言和依赖
   
   ## Phase 2: Analysis
   - 运行安全扫描工具（cargo audit, npm audit 等）
   - 搜索常见安全问题模式
   
   ## Phase 3: Task
   - 生成安全报告
   - 提供修复建议
   ```

**预计耗时**：4 小时

---

#### 任务 6：提供 Windows 兼容的 Hooks

**目标**：确保 Hooks 在 Windows 上也能正常工作

**方案**：

1. **创建 PowerShell 版本**
   ```powershell
   # hooks/prepare-commit-msg.ps1
   param(
       [string]$CommitMsgFile,
       [string]$CommitSource
   )
   
   # 只处理常规提交
   if (-not $CommitSource -or $CommitSource -eq "message") {
       # 读取提交信息
       $content = Get-Content $CommitMsgFile -Raw
       
       # 移除 AI 签名
       $content = $content -replace '(?m)^🤖 Generated with.*Claude Code\r?\n?', ''
       $content = $content -replace '(?m)^Co-Authored-By: Claude\r?\n?', ''
       
       # 移除多余空行
       $content = $content -replace '(?m)^\r?\n(\r?\n)+', "`n"
       
       # 写回文件
       Set-Content -Path $CommitMsgFile -Value $content -NoNewline
   }
   ```

2. **创建跨平台安装脚本**
   ```bash
   # hooks/install.sh
   #!/bin/bash
   
   if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
       # Windows
       cp hooks/prepare-commit-msg.ps1 .git/hooks/prepare-commit-msg
   else
       # Linux/Mac
       cp hooks/prepare-commit-msg.sh .git/hooks/prepare-commit-msg
       chmod +x .git/hooks/prepare-commit-msg
   fi
   
   echo "✅ Git hooks installed successfully"
   ```

3. **更新文档**
   - 在 README.md 中说明 Windows 用户的安装方法
   - 在 hooks/README.md 中提供详细说明

**预计耗时**：2 小时

---

### 🟢 低优先级任务（可选优化）

#### 任务 7：简化 Skills README.md

**目标**：将 Skills README.md 简化为索引和快速入门

**方案**：

1. 保留核心内容：
   - Skills 列表表格
   - 快速开始
   - 基本使用方法

2. 移除详细内容：
   - 详细的 Skill 说明（移到各个 Skill 的 SKILL.md）
   - 冗长的示例（移到各个 Skill）

3. 目标长度：< 100 行

**预计耗时**：1 小时

---

#### 任务 8：添加版本变更日志

**目标**：记录项目的版本历史

**创建文件**：`CHANGELOG.md`

**内容模板**：

```markdown
# 变更日志

所有重要的变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [未发布]

### 新增
- 添加项目结构图到 CLAUDE.md
- 添加 Setup & Installation 章节
- 完善 README.md

### 变更
- 重命名 claudeforge-skill 为 claude-md-enhancer
- 简化 CLAUDE.md 文件长度

### 修复
- 修复 Windows 兼容性问题

## [1.0.0] - 2025-12-02

### 新增
- 初始版本发布
- 20+ Skills
- 3 个专用 Agents
- 1 个自定义 Command
- Git Hooks 支持
```

**预计耗时**：30 分钟

---

#### 任务 9：添加配置文档

**目标**：说明 settings.json 的各项配置

**方案 A：在 settings.json 中添加注释**（推荐）

```jsonc
{
  // Git Hooks 配置
  "hooks": {
    // 工具使用后触发的 hooks
    "PostToolUse": [
      {
        // 匹配 Bash 工具
        "matcher": "Bash",
        "hooks": [
          {
            // 执行命令类型的 hook
            "type": "command",
            // 检查并移除 AI 签名
            "command": "bash -c 'if git log -1 --pretty=%B 2>/dev/null | grep -q \"Co-Authored-By: Claude\\|Generated with.*Claude Code\"; then git commit --amend -m \"$(git log -1 --pretty=%B | grep -v \"Co-Authored-By: Claude\" | grep -v \"Generated with.*Claude Code\" | grep -v \"^🤖\" | sed \"/^$/d\")\"; fi'"
          }
        ]
      }
    ]
  }
}
```

**方案 B：创建单独的配置文档**

创建 `docs/configuration.md`：

```markdown
# 配置说明

## settings.json

### hooks

配置 Claude Code 的 hooks。

#### PostToolUse

在工具使用后触发的 hooks。

**示例**：
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "..."
          }
        ]
      }
    ]
  }
}
```

**说明**：
- `matcher`: 匹配的工具类型（Bash, Read, Write 等）
- `type`: Hook 类型（command, message）
- `command`: 要执行的命令

### 其他配置项

（待添加）
```

**预计耗时**：1 小时

---

## 📅 实施时间表

### 第 1 天（今天）
- [x] 完成审查报告
- [ ] 任务 1：优化 CLAUDE.md（2 小时）
- [ ] 任务 2：完善 README.md（1 小时）
- [ ] 任务 3：统一命名（30 分钟）

**预计总耗时**：3.5 小时

### 第 2-3 天
- [ ] 任务 4：为 Agents 添加使用示例（1.5 小时）
- [ ] 任务 6：提供 Windows 兼容的 Hooks（2 小时）

**预计总耗时**：3.5 小时

### 第 4-5 天
- [ ] 任务 5：添加更多 Commands（4 小时）

### 本周末（可选）
- [ ] 任务 7：简化 Skills README.md（1 小时）
- [ ] 任务 8：添加版本变更日志（30 分钟）
- [ ] 任务 9：添加配置文档（1 小时）

---

## ✅ 验收标准

### 高优先级任务
- [ ] CLAUDE.md 包含项目结构图
- [ ] CLAUDE.md 包含 Setup & Installation 章节
- [ ] CLAUDE.md 包含 Common Commands 章节
- [ ] CLAUDE.md 文件长度 < 150 行
- [ ] README.md 内容完整，包含项目介绍、特性、安装、使用
- [ ] claudeforge-skill 命名统一

### 中优先级任务
- [ ] 所有 Agents 都有使用示例
- [ ] 至少添加 2 个新的 Commands
- [ ] 提供 Windows 兼容的 Hooks

### 低优先级任务
- [ ] Skills README.md < 100 行
- [ ] 存在 CHANGELOG.md
- [ ] 存在配置文档

---

## 📊 进度追踪

| 任务 | 优先级 | 状态 | 预计耗时 | 实际耗时 | 完成日期 |
|------|--------|------|---------|---------|---------|
| 任务 1 | 🔴 高 | ⏸️ 未开始 | 2h | - | - |
| 任务 2 | 🔴 高 | ⏸️ 未开始 | 1h | - | - |
| 任务 3 | 🔴 高 | ⏸️ 未开始 | 0.5h | - | - |
| 任务 4 | 🟡 中 | ⏸️ 未开始 | 1.5h | - | - |
| 任务 5 | 🟡 中 | ⏸️ 未开始 | 4h | - | - |
| 任务 6 | 🟡 中 | ⏸️ 未开始 | 2h | - | - |
| 任务 7 | 🟢 低 | ⏸️ 未开始 | 1h | - | - |
| 任务 8 | 🟢 低 | ⏸️ 未开始 | 0.5h | - | - |
| 任务 9 | 🟢 低 | ⏸️ 未开始 | 1h | - | - |

---

**计划创建时间**：2025-12-02
**计划负责人**：项目团队
**下次审查**：2025-12-09
