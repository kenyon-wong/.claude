---
name: burp-plugin-structure
description: BurpSuite Java 插件项目结构和目录布局标准。单模块 Maven 项目结构，包含根目录布局、源码结构（src/）、包组织规范（burp.*）、关键架构组件（BurpExtender 入口点、Manager 层、UI 组件）、配置文件位置、命名约定（m 前缀成员变量、s 前缀静态变量）和资源文件。适用于导航代码库、理解架构或定位文件时使用。
---

# BurpSuite Java 插件项目结构

## 标准目录布局

```
burp-plugin/
├── .agent/                 # Agent 分析和计划文档
├── .claude/                # Claude Code skills
├── .git/                   # Git 仓库
├── .kiro/                  # Kiro IDE 配置和 steering
├── docs/                   # 文档目录
│   └── imgs/               # 文档图片
├── src/                    # 源代码目录
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
├── target/                 # 构建输出目录
├── CLAUDE.md               # Claude 开发指南
├── LICENSE                 # 项目许可证
├── pom.xml                 # Maven POM（单模块）
└── README.md               # 用户文档
```

## 源码结构（src/）

```
src/
├── main/
│   ├── java/
│   │   └── burp/                        # 根包
│   │       ├── BurpExtender.java        # 插件入口点
│   │       ├── common/                  # 通用工具和组件
│   │       │   ├── config/              # 配置管理
│   │       │   ├── filter/              # 数据过滤
│   │       │   ├── helper/              # 辅助工具
│   │       │   ├── layout/              # 自定义布局管理器
│   │       │   ├── log/                 # 日志
│   │       │   ├── utils/               # 工具类
│   │       │   └── widget/              # 通用 UI 组件
│   │       └── {plugin}/                # 插件核心功能
│   │           ├── bean/                # 数据模型
│   │           ├── common/              # 插件特定工具
│   │           ├── manager/             # 核心管理器
│   │           └── ui/                  # UI 组件
│   │               ├── base/            # 基础 UI 类
│   │               ├── tab/             # 标签页面板
│   │               └── widget/          # UI 小部件
│   └── resources/
│       ├── i18n/                        # 国际化资源
│       │   ├── messages_zh_CN.properties
│       │   └── messages_en_US.properties
│       ├── config/                      # 配置文件
│       │   └── default_config.yaml
│       └── assets/                      # 静态资源
│           └── icons/                   # 图标
└── test/
    └── java/
        └── burp/                        # 测试类
            ├── common/                  # 通用组件测试
            └── {plugin}/                # 插件功能测试
```

## 包组织规范

### 通用包（burp.common.*）
- **burp.common.config** - 配置上下文和管理
- **burp.common.filter** - 表格过滤和规则
- **burp.common.helper** - 辅助工具（Domain、QPS、UI 等）
- **burp.common.layout** - 自定义布局管理器（VLayout、HLayout）
- **burp.common.log** - 日志工具
- **burp.common.utils** - 通用工具类
- **burp.common.widget** - 可复用 UI 组件

### 插件包（burp.{plugin}.*）
- **burp.BurpExtender** - 插件入口，实现 IBurpExtender 和其他 Burp 接口
- **burp.{plugin}.bean** - 数据传输对象和模型
- **burp.{plugin}.common** - 插件特定工具、常量、辅助类
- **burp.{plugin}.manager** - 业务逻辑管理器
- **burp.{plugin}.ui** - Swing UI 组件和面板

## 关键架构组件

### 入口点
- `burp.BurpExtender` - 实现多个 Burp 接口，管理插件生命周期
  - 实现 `IBurpExtender` - 插件初始化
  - 实现 `IHttpListener` - HTTP 流量监听（可选）
  - 实现 `IProxyListener` - 代理流量监听（可选）
  - 实现 `IExtensionStateListener` - 插件状态监听（可选）

### 核心管理器层
- **Manager 层**：业务逻辑管理器
  - 配置管理器 - 配置加载、保存、验证
  - 数据管理器 - 数据收集、处理、存储
  - 任务管理器 - 任务调度、执行、监控
- **线程池**：异步任务执行
  - 主任务线程池（建议 10-50 线程）
  - 低频任务线程池（建议 5-25 线程）
  - 特定功能线程池（根据需求）

### UI 组件层
- **主面板**：插件主界面
  - 标签页（Tab）- 功能模块分组
  - 配置面板 - 用户配置界面
  - 数据展示面板 - 结果展示
- **通用组件**：
  - 表格（Table）- 数据列表展示
  - 编辑器（Editor）- HTTP 请求/响应编辑
  - 过滤器（Filter）- 数据过滤

## 配置文件位置

插件配置存储优先级：
- **优先级 1**：`{plugin-jar-directory}/{PluginName}/`
- **优先级 2**：`~/.config/{PluginName}/`（Linux/macOS）或 `C:\Users\{user}\.config\{PluginName}\`（Windows）
- **优先级 3**：JAR 包内的默认配置（resources/config/）

## 命名约定

### 变量命名
- **成员变量**：`m` 前缀（例如：`mCallbacks`、`mApi`、`mConfig`）
- **静态变量**：`s` 前缀（例如：`sInstance`、`sConfig`、`sThreadPool`）
- **常量**：UPPER_SNAKE_CASE（例如：`TASK_THREAD_COUNT`、`MAX_RETRY_COUNT`）
- **局部变量**：camelCase（例如：`requestData`、`responseBody`）

### 类命名
- **Manager 类**：`{Function}Manager`（例如：`ConfigManager`、`TaskManager`）
- **UI 类**：
  - 标签页：`{Function}Tab`（例如：`ConfigTab`、`ResultTab`）
  - 面板：`{Function}Panel`（例如：`ConfigPanel`、`FilterPanel`）
  - 表格：`{Function}Table`（例如：`TaskTable`、`ResultTable`）
  - 窗口：`{Function}Window`（例如：`SettingsWindow`）
- **Bean 类**：`{Entity}`（例如：`Task`、`Config`、`Result`）
- **Helper 类**：`{Function}Helper`（例如：`UIHelper`、`HttpHelper`）
- **Utils 类**：`{Function}Utils`（例如：`StringUtils`、`FileUtils`）

### 包命名
- **通用包**：`burp.common.*`
- **插件包**：`burp.{pluginname}.*`（全小写，无下划线）

## 资源文件组织

### 配置文件（resources/config/）
- `default_config.yaml` - 默认配置
- `rules.yaml` - 规则配置（如果需要）
- `settings.properties` - 设置项

### 国际化文件（resources/i18n/）
- `messages_zh_CN.properties` - 中文
- `messages_en_US.properties` - 英文

### 静态资源（resources/assets/）
- `icons/` - 图标文件
- `templates/` - 模板文件

## 最佳实践

### 1. 模块化设计
- 将功能拆分为独立的 Manager
- UI 和业务逻辑分离
- 通用组件放在 common 包

### 2. 线程安全
- Manager 类使用单例模式
- 共享数据使用线程安全集合
- 避免在 UI 线程执行耗时操作

### 3. 资源管理
- 使用 try-with-resources 管理资源
- 插件卸载时清理线程池
- 及时释放大对象

### 4. 错误处理
- 捕获并记录所有异常
- 向用户显示友好的错误信息
- 避免插件崩溃影响 Burp

### 5. 配置管理
- 提供默认配置
- 支持配置导入/导出
- 配置变更及时保存

---

**版本**：1.0.0  
**最后更新**：2025-12-02  
**适用范围**：所有 BurpSuite Java 插件项目
