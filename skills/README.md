# Skill 文件索引

本目录包含项目级别的可复用 Skill 文件（符合 Anthropic 官方 Agent Skills 规范）。

---

## 📚 Skill 文件列表

| Skill 目录 | 用途 | 适用范围 | 版本 |
|-----------|------|---------|------|
| `claude-md-enhancer/` | CLAUDE.md 文件生成与增强 | 所有项目 | v1.0.0 |
| `rust-standards/` | Rust 代码标准和规范 | 所有 Rust 项目 | v1.0.0 |
| `rust-code-review/` | Rust 代码审查标准 | 所有 Rust 项目 | v2.0.0 |
| `report-templates/` | 代码审查报告模板 | 所有代码审查任务 | v2.0.0 |
| `rust-testing/` | Rust 测试验证流程 | 所有 Rust 项目 | v2.0.0 |
| `development-workflow/` | Rust 项目开发流程 | 所有 Rust 项目 | v1.0.0 |
| `git-commit/` | Git 提交规范 | 所有项目 | v2.0.0 |
| `agent-workflow/` | AI Agent 执行流程 | 所有 AI 自动化任务 | v2.0.0 |
| `progress-tracking/` | 进度追踪文件模板 | 所有 AI 自动化任务 | v2.0.0 |

**重要变更**：所有 Skill 已优化为符合 Anthropic 官方 Agent Skills 规范（v2.0.0）：
- ✅ 添加 YAML 前置数据（`name` 和 `description`）
- ✅ 使用 `SKILL.md` 作为主文件名
- ✅ 采用渐进式披露结构（主文件 + 补充文件）
- ✅ 节省约 60% 的上下文窗口

---

## 🎯 Skill 使用指南

### 在 `prompt.md` 中引用 Skill

在 `prompt.md` 中添加以下内容，引用相关 Skill：

```markdown
## 执行规则

**请严格遵循以下 Skill 中定义的规范**：

- 📋 **执行流程**：参考 `.claude/skills/agent-workflow/SKILL.md`
- 🧪 **测试验证**：参考 `.claude/skills/rust-testing/SKILL.md`
- 📝 **报告格式**：参考 `.claude/skills/report-templates/SKILL.md`
- 🔖 **Git 规范**：参考 `.claude/skills/git-commit/SKILL.md`
- 📊 **进度追踪**：参考 `.claude/skills/progress-tracking/SKILL.md`
- ✅ **审查标准**：参考 `.claude/skills/rust-code-review/SKILL.md`
```

### 在代码审查任务中使用

```markdown
## TODO list:

请按照以下 Skill 中定义的标准执行代码审查：

1. **审查标准**：参考 `.claude/skills/rust-code-review/SKILL.md`
2. **报告格式**：参考 `.claude/skills/report-templates/SKILL.md`
3. **测试验证**：参考 `.claude/skills/rust-testing/SKILL.md`
4. **Git 提交**：参考 `.claude/skills/git-commit/SKILL.md`
```

---

## 📖 Skill 详细说明

### 1. Rust 代码审查标准

**目录**：`rust-code-review/`

**文件结构**：
- `SKILL.md`：主文件（快速入门 + 核心审查维度）
- `ADVANCED.md`：补充文件（P3 阶段高级审查维度）

**内容**：
- 17 个代码审查维度（P0/P1/P2/P3）
- 每个维度的检查要点
- Rust 特定的最佳实践
- 审查工具列表
- 参考资料

**适用场景**：
- Rust 项目代码审查
- 代码质量评估
- 技术债务识别

---

### 2. 代码审查报告模板

**目录**：`report-templates/`

**文件结构**：
- `SKILL.md`：主文件（快速入门 + 阶段性报告格式）
- `FINAL_REPORT.md`：补充文件（最终完整报告模板）

**内容**：
- 阶段性报告格式（快速报告）
- 最终完整报告格式
- 报告风格要求
- Mermaid 图表示例

**适用场景**：
- 生成代码审查报告
- 统一报告格式
- 提高报告质量

---

### 3. Rust 测试验证流程

**目录**：`rust-testing/`

**文件结构**：
- `SKILL.md`：主文件（快速入门 + 核心测试流程）
- `PERFORMANCE.md`：补充文件（性能监控和分析工具）

**内容**：
- 基础编译与构建验证
- 代码质量检查（clippy, fmt, audit）
- 性能基准测试
- 安全验证
- 集成测试与端到端测试
- 验证检查清单

**适用场景**：
- Rust 项目测试
- CI/CD 集成
- 质量保证

---

### 4. Git 提交规范

**目录**：`git-commit/`

**文件结构**：
- `SKILL.md`：主文件（快速入门 + 核心规范）
- `EXAMPLES.md`：补充文件（详细示例和 Git Hooks）

**内容**：
- Commit 格式规范
- 类型定义（feat, fix, review 等）
- Scope 范围
- 描述规则
- 完整示例
- Git Hooks

**适用场景**：
- 所有项目的 Git 提交
- 代码审查任务的提交
- 统一提交历史

---

### 5. AI Agent 执行流程

**目录**：`agent-workflow/`

**文件结构**：
- `SKILL.md`：主文件（快速入门 + 核心执行流程）

**内容**：
- 执行流程（检查 → 思考 → 拆分 → 执行 → 完成）
- 深度思考阶段
- 任务拆分决策
- 阶段性执行
- `.agent/` 目录管理
- 工作规范
- 错误处理

**适用场景**：
- AI Agent 自动化任务
- 无人值守执行
- 任务编排

---

### 6. 进度追踪文件模板

**目录**：`progress-tracking/`

**文件结构**：
- `SKILL.md`：主文件（快速入门 + 所有模板格式）

**内容**：
- `task.md` 格式（任务进度追踪）
- `thinking.md` 格式（深度思考记录）
- `task_plan.md` 格式（任务执行计划）
- `test_report.md` 格式（测试报告）
- 日志文件格式

**适用场景**：
- 任务进度追踪
- 执行状态记录
- 问题追踪

---

## 🔄 Skill 更新流程

### 1. 识别需要更新的 Skill

- 发现 Skill 内容过时
- 发现 Skill 内容不完整
- 发现 Skill 内容有错误

### 2. 更新 Skill 文件

- 修改对应的 Skill 文件
- 更新版本号
- 更新最后更新时间

### 3. 测试 Skill 更新

- 在实际任务中测试更新后的 Skill
- 验证 Skill 的正确性和完整性

### 4. 提交 Skill 更新

```bash
git add .claude/skills/[skill_file].md
git commit -m "docs(skills): 更新 [skill_name] Skill"
git push
```

---

## 📝 Skill 开发最佳实践

### 1. 保持 Skill 的独立性

- 每个 Skill 应该是独立的
- 避免 Skill 之间的循环依赖
- 使用引用而非复制内容

### 2. 保持 Skill 的通用性

- Skill 应该适用于多个项目
- 避免项目特定的内容
- 使用参数化和模板

### 3. 保持 Skill 的可维护性

- 使用清晰的结构
- 添加详细的说明
- 提供完整的示例

### 4. 保持 Skill 的版本化

- 每个 Skill 都有版本号
- 记录最后更新时间
- 记录变更历史

---

## 🚀 快速开始

### 1. 查看 Skill 列表

```bash
ls -la .claude/skills/
```

### 2. 阅读 Skill 内容

```bash
cat .claude/skills/rust-code-review/SKILL.md
```

### 3. 在 prompt.md 中引用 Skill

```markdown
## 执行规则

参考 `.claude/skills/agent-workflow/SKILL.md` 中定义的执行流程。
```

### 4. 执行任务

按照 Skill 中定义的规范执行任务。

---

**版本**：1.0.0  
**最后更新**：2025-12-02  
**维护者**：项目团队
