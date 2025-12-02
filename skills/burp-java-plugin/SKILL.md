---
name: burp-java-plugin
description: BurpSuite Java 插件开发完整指南。涵盖项目结构、技术栈、构建系统、插件类型、核心功能、错误处理、测试策略、性能优化、最佳实践。适用于 BurpSuite Java 插件开发的所有场景，包括架构设计、编码实现、测试验证、性能优化。
---

# BurpSuite Java 插件开发完整指南

本 Skill 提供 BurpSuite Java 插件开发的完整规范和最佳实践。

---

## 快速导航

- [项目结构](#项目结构)
- [技术栈与构建](#技术栈与构建)
- [插件开发](#插件开发)
- [错误处理](#错误处理)
- [测试策略](#测试策略)

---

## 项目结构

### 标准目录布局

```
burp-plugin/
├── .agent/                 # Agent 分析和计划文档
├── .claude/                # Claude Code skills
├── .git/                   # Git 仓库
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

### 源码结构

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

### 包组织规范

#### 通用包（burp.common.*）
- **burp.common.config** - 配置上下文和管理
- **burp.common.filter** - 表格过滤和规则
- **burp.common.helper** - 辅助工具（Domain、QPS、UI 等）
- **burp.common.layout** - 自定义布局管理器
- **burp.common.log** - 日志工具
- **burp.common.utils** - 通用工具类
- **burp.common.widget** - 可复用 UI 组件

#### 插件包（burp.{plugin}.*）
- **burp.BurpExtender** - 插件入口，实现 IBurpExtender 和其他 Burp 接口
- **burp.{plugin}.bean** - 数据传输对象和模型
- **burp.{plugin}.common** - 插件特定工具、常量、辅助类
- **burp.{plugin}.manager** - 业务逻辑管理器
- **burp.{plugin}.ui** - Swing UI 组件和面板

### 命名约定

#### 变量命名
- **成员变量**：`m` 前缀（例如：`mCallbacks`、`mApi`、`mConfig`）
- **静态变量**：`s` 前缀（例如：`sInstance`、`sConfig`、`sThreadPool`）
- **常量**：UPPER_SNAKE_CASE（例如：`TASK_THREAD_COUNT`、`MAX_RETRY_COUNT`）
- **局部变量**：camelCase（例如：`requestData`、`responseBody`）

#### 类命名
- **Manager 类**：`{Function}Manager`（例如：`ConfigManager`、`TaskManager`）
- **UI 类**：
  - 标签页：`{Function}Tab`（例如：`ConfigTab`、`ResultTab`）
  - 面板：`{Function}Panel`（例如：`ConfigPanel`、`FilterPanel`）
  - 表格：`{Function}Table`（例如：`TaskTable`、`ResultTable`）
  - 窗口：`{Function}Window`（例如：`SettingsWindow`）
- **Bean 类**：`{Entity}`（例如：`Task`、`Config`、`Result`）
- **Helper 类**：`{Function}Helper`（例如：`UIHelper`、`HttpHelper`）
- **Utils 类**：`{Function}Utils`（例如：`StringUtils`、`FileUtils`）

#### 包命名
- **通用包**：`burp.common.*`
- **插件包**：`burp.{pluginname}.*`（全小写，无下划线）

### 关键架构组件

#### 入口点
- `burp.BurpExtender` - 实现多个 Burp 接口，管理插件生命周期
  - 实现 `IBurpExtender` - 插件初始化
  - 实现 `IHttpListener` - HTTP 流量监听（可选）
  - 实现 `IProxyListener` - 代理流量监听（可选）
  - 实现 `IExtensionStateListener` - 插件状态监听（可选）

#### 核心管理器层
- **Manager 层**：业务逻辑管理器
  - 配置管理器 - 配置加载、保存、验证
  - 数据管理器 - 数据收集、处理、存储
  - 任务管理器 - 任务调度、执行、监控
- **线程池**：异步任务执行
  - 主任务线程池（建议 10-50 线程）
  - 低频任务线程池（建议 5-25 线程）
  - 特定功能线程池（根据需求）

#### UI 组件层
- **主面板**：插件主界面
  - 标签页（Tab）- 功能模块分组
  - 配置面板 - 用户配置界面
  - 数据展示面板 - 结果展示
- **通用组件**：
  - 表格（Table）- 数据列表展示
  - 编辑器（Editor）- HTTP 请求/响应编辑
  - 过滤器（Filter）- 数据过滤

### 配置文件位置

插件配置存储优先级：
- **优先级 1**：`{plugin-jar-directory}/{PluginName}/`
- **优先级 2**：`~/.config/{PluginName}/`（Linux/macOS）或 `C:\Users\{user}\.config\{PluginName}\`（Windows）
- **优先级 3**：JAR 包内的默认配置（resources/config/）

---

## 技术栈与构建

### 技术约束

#### Java 版本
- **要求**：Java 17 (LTS) 或更高版本
- **最低**：Java 11（Montoya API 要求）
- **编译目标**：必须使用 Java 17 以获得最新特性

#### 构建工具
- **要求**：Maven（唯一支持的构建工具）
- **禁止**：Gradle（不允许使用）
- **原因**：
  - Maven 配置更简洁，易于维护
  - 标准化的项目结构
  - 更好的依赖管理和版本控制

#### Burp API 选择
- **要求**：Montoya API（唯一支持的 API）
  - 现代化 API 设计
  - 更好的类型安全
  - 持续更新和支持
  - 内置深色模式支持
  - 完善的国际化机制
- **禁止**：Legacy Extender API
  - 已有的 Legacy API 代码必须迁移到 Montoya API
  - 不再维护和支持
  - 缺少现代化特性（深色模式、i18n）

### 核心依赖

#### BurpSuite API

**Montoya API（唯一支持）**：

```xml
<dependency>
    <groupId>net.portswigger.burp.extensions</groupId>
    <artifactId>montoya-api</artifactId>
    <version>2025.5</version>
    <scope>provided</scope>
</dependency>
```

- **关键接口**：
  - `MontoyaApi` - 主 API 入口
  - `HttpRequestEditor` / `HttpResponseEditor` - HTTP 编辑器
  - `HttpHandler` - HTTP 流量处理
  - `Logging` - 日志记录
  - `UserInterface` - UI 组件（支持深色模式）
  - `Extension` - 插件生命周期管理
- **文档**：https://portswigger.github.io/burp-extensions-montoya-api/

**注意**：Legacy Extender API 已被弃用，所有新项目必须使用 Montoya API。

#### 常用第三方依赖

**JSON 处理**：
```xml
<!-- Gson -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>

<!-- 或 Jackson -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.15.2</version>
</dependency>
```

**YAML 处理**：
```xml
<dependency>
    <groupId>org.yaml</groupId>
    <artifactId>snakeyaml</artifactId>
    <version>2.2</version>
</dependency>
```

### 构建命令

#### Maven 命令

```bash
# 完整构建
mvn clean package

# 跳过测试
mvn clean package -DskipTests

# 运行测试
mvn test

# 运行特定测试
mvn test -Dtest=ClassName#methodName
```

#### 跨平台命令

**Windows cmd**：
```cmd
REM 使用 & 分隔符
mvn clean & mvn package
```

**Linux/Mac bash**：
```bash
# 使用 && 分隔符
mvn clean && mvn package
```

### POM 最佳实践

#### 版本管理

使用 `<properties>` 统一管理版本号：

```xml
<properties>
    <!-- Java 版本 -->
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    
    <!-- 依赖版本 -->
    <montoya.version>2025.5</montoya.version>
    <gson.version>2.10.1</gson.version>
    <snakeyaml.version>2.2</snakeyaml.version>
    <junit.version>4.13.2</junit.version>
    
    <!-- 插件版本 -->
    <maven-compiler-plugin.version>3.11.0</maven-compiler-plugin.version>
    <maven-assembly-plugin.version>3.6.0</maven-assembly-plugin.version>
</properties>
```

#### 构建输出

- **产物**：`{PluginName}-v{version}.jar` 在 `target/` 目录
- **类型**：Uber JAR（包含所有依赖）
- **要求**：默认情况下只能编译出一个 JAR 文件
- **Assembly**：使用 maven-assembly-plugin 的 jar-with-dependencies 描述符

#### Maven Assembly 配置

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>${maven-assembly-plugin.version}</version>
    <configuration>
        <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
        <archive>
            <manifestEntries>
                <Implementation-Title>${project.name}</Implementation-Title>
                <Implementation-Version>${project.version}</Implementation-Version>
            </manifestEntries>
        </archive>
        <finalName>${project.artifactId}-v${project.version}</finalName>
        <appendAssemblyId>false</appendAssemblyId>
    </configuration>
    <executions>
        <execution>
            <id>make-assembly</id>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

#### 完整 POM 示例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>burp</groupId>
    <artifactId>my-plugin</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <name>My Burp Plugin</name>
    <description>A Burp Suite extension</description>

    <properties>
        <!-- Java 版本 -->
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        
        <!-- 依赖版本 -->
        <montoya.version>2025.5</montoya.version>
        <gson.version>2.10.1</gson.version>
        <snakeyaml.version>2.2</snakeyaml.version>
        <junit.version>4.13.2</junit.version>
        
        <!-- 插件版本 -->
        <maven-compiler-plugin.version>3.11.0</maven-compiler-plugin.version>
        <maven-assembly-plugin.version>3.6.0</maven-assembly-plugin.version>
    </properties>

    <dependencies>
        <!-- Burp Montoya API -->
        <dependency>
            <groupId>net.portswigger.burp.extensions</groupId>
            <artifactId>montoya-api</artifactId>
            <version>${montoya.version}</version>
            <scope>provided</scope>
        </dependency>

        <!-- JSON 处理 -->
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>${gson.version}</version>
        </dependency>

        <!-- YAML 处理 -->
        <dependency>
            <groupId>org.yaml</groupId>
            <artifactId>snakeyaml</artifactId>
            <version>${snakeyaml.version}</version>
        </dependency>

        <!-- 测试依赖 -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- 编译插件 -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>${maven-compiler-plugin.version}</version>
                <configuration>
                    <source>${maven.compiler.source}</source>
                    <target>${maven.compiler.target}</target>
                    <encoding>${project.build.sourceEncoding}</encoding>
                </configuration>
            </plugin>

            <!-- Assembly 插件 -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>${maven-assembly-plugin.version}</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                    <archive>
                        <manifestEntries>
                            <Implementation-Title>${project.name}</Implementation-Title>
                            <Implementation-Version>${project.version}</Implementation-Version>
                        </manifestEntries>
                    </archive>
                    <finalName>${project.artifactId}-v${project.version}</finalName>
                    <appendAssemblyId>false</appendAssemblyId>
                </configuration>
                <executions>
                    <execution>
                        <id>make-assembly</id>
                        <phase>package</phase>
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

### Java 17+ 特性使用

#### 推荐使用的特性

**Lambda 表达式 & Stream API**：
```java
// ✅ 使用 lambda 简化代码
list.forEach(item -> System.out.println(item));

// ✅ 使用 streams 处理集合
List<String> filtered = list.stream()
    .filter(s -> s.startsWith("test"))
    .collect(Collectors.toList());
```

**var 关键字**：
```java
// ✅ 使用 var 简化局部变量声明
var list = new ArrayList<String>();
var result = calculateSomething();
```

**Text Blocks**：
```java
// ✅ 使用 text blocks 处理多行字符串
String json = """
    {
        "name": "MyPlugin",
        "version": "1.0.0"
    }
    """;
```

**Records**：
```java
// ✅ 使用 records 定义简单数据类
public record Config(String name, int value, boolean enabled) {}
```

**Pattern Matching**：
```java
// ✅ 使用 pattern matching
if (obj instanceof String s) {
    System.out.println(s.toUpperCase());
}
```

---

## 插件开发

### 插件类型

#### 1. 被动扫描插件
- **用途**：分析 HTTP 流量，发现安全问题
- **特点**：不发送额外请求，对目标无侵入
- **示例**：敏感信息泄露检测、配置错误识别

#### 2. 主动扫描插件
- **用途**：主动发送请求测试漏洞
- **特点**：可能对目标产生影响，需要用户授权
- **示例**：SQL 注入测试、XSS 检测、目录扫描

#### 3. 流量处理插件
- **用途**：修改、记录或分析 HTTP 流量
- **特点**：实时处理，性能要求高
- **示例**：请求/响应修改、流量记录、协议转换

#### 4. UI 扩展插件
- **用途**：提供额外的用户界面功能
- **特点**：增强 Burp 的可用性
- **示例**：数据可视化、报告生成、配置管理

### 核心功能实现

#### HTTP 处理

```java
// Montoya API 示例
public class MyHttpHandler implements HttpHandler {
    @Override
    public RequestToBeSentAction handleHttpRequestToBeSent(
            HttpRequestToBeSent requestToBeSent) {
        // 处理请求
        return RequestToBeSentAction.continueWith(requestToBeSent);
    }
    
    @Override
    public ResponseReceivedAction handleHttpResponseReceived(
            HttpResponseReceived responseReceived) {
        // 处理响应
        return ResponseReceivedAction.continueWith(responseReceived);
    }
}
```

#### 配置管理

```java
public class ConfigManager {
    private static final String CONFIG_DIR = ".config/MyPlugin/";
    
    public void saveConfig(Config config) {
        Path configPath = getConfigPath();
        Files.writeString(configPath, toJson(config));
    }
    
    public Config loadConfig() {
        Path configPath = getConfigPath();
        return fromJson(Files.readString(configPath));
    }
}
```

#### UI 组件

```java
public class MyTab implements ITab {
    private JPanel mMainPanel;
    
    public MyTab(MontoyaApi api) {
        initUI();
    }
    
    private void initUI() {
        mMainPanel = new JPanel(new BorderLayout());
        
        // 添加配置面板
        JPanel configPanel = createConfigPanel();
        mMainPanel.add(configPanel, BorderLayout.NORTH);
        
        // 添加数据展示表格
        JTable dataTable = createDataTable();
        mMainPanel.add(new JScrollPane(dataTable), BorderLayout.CENTER);
    }
    
    @Override
    public String tabCaption() {
        return "My Plugin";
    }
    
    @Override
    public Component uiComponent() {
        return mMainPanel;
    }
}
```

### 性能优化

#### 线程池管理

```java
public class ThreadPoolManager {
    // 主任务线程池
    private static final ExecutorService sMainPool = 
        Executors.newFixedThreadPool(50);
    
    // 低频任务线程池
    private static final ExecutorService sLowFreqPool = 
        Executors.newFixedThreadPool(10);
    
    public static void submitTask(Runnable task) {
        sMainPool.submit(task);
    }
    
    public static void shutdown() {
        sMainPool.shutdown();
        sLowFreqPool.shutdown();
    }
}
```

#### 缓存策略

```java
public class CacheManager {
    // LRU 缓存
    private static final Map<String, Object> sCache = 
        Collections.synchronizedMap(new LinkedHashMap<>(100, 0.75f, true) {
            @Override
            protected boolean removeEldestEntry(Map.Entry eldest) {
                return size() > 100;
            }
        });
    
    public static void put(String key, Object value) {
        sCache.put(key, value);
    }
    
    public static Object get(String key) {
        return sCache.get(key);
    }
}
```

#### 限流控制

```java
public class RateLimiter {
    private final int qps;
    private final Queue<Long> timestamps = new LinkedList<>();
    
    public RateLimiter(int qps) {
        this.qps = qps;
    }
    
    public synchronized boolean tryAcquire() {
        long now = System.currentTimeMillis();
        
        // 移除过期时间戳
        while (!timestamps.isEmpty() && 
               now - timestamps.peek() > 1000) {
            timestamps.poll();
        }
        
        // 检查是否超过限制
        if (timestamps.size() < qps) {
            timestamps.offer(now);
            return true;
        }
        
        return false;
    }
}
```

---

## 错误处理

### 错误处理原则

1. **快速失败**：尽早发现和报告错误
2. **明确信息**：提供清晰的错误描述
3. **保留上下文**：保留原始异常信息
4. **适当恢复**：在可能的情况下优雅降级
5. **记录日志**：记录错误以便调试

### 异常分类

#### 检查型异常（Checked Exception）

用于可预期的、可恢复的错误：

```java
// ✅ 正确：文件操作使用检查型异常
public String readFile(String path) throws IOException {
    return FileUtils.readFileToString(new File(path), StandardCharsets.UTF_8);
}

// 调用者必须处理
try {
    String content = readFile(configPath);
} catch (IOException e) {
    Logger.error("Failed to read file: %s", e.getMessage());
}
```

#### 非检查型异常（Unchecked Exception）

用于编程错误或不可恢复的错误：

```java
// ✅ 正确：参数验证使用非检查型异常
public void init(String path) {
    if (StringUtils.isEmpty(path)) {
        throw new IllegalArgumentException("Config path cannot be empty");
    }
    if (!FileUtils.isFile(path)) {
        throw new IllegalArgumentException("Config file not found: " + path);
    }
}
```

### 常见场景处理

#### 参数验证

```java
public static void init(String path) {
    // ✅ 正确：验证参数并提供清晰的错误信息
    if (StringUtils.isEmpty(path)) {
        throw new IllegalArgumentException("Config path cannot be empty");
    }
    
    if (!FileUtils.isFile(path)) {
        throw new IllegalArgumentException(
            String.format("Config file not found: %s", path)
        );
    }
    
    loadConfig(path);
}
```

#### 资源操作

```java
// ✅ 正确：使用 try-with-resources 自动关闭资源
public String readConfig(String path) throws IOException {
    try (FileInputStream fis = new FileInputStream(path);
         InputStreamReader isr = new InputStreamReader(fis, StandardCharsets.UTF_8);
         BufferedReader reader = new BufferedReader(isr)) {
        
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            content.append(line).append("\n");
        }
        return content.toString();
    }
}
```

#### UI 错误显示

```java
private void doReload() {
    try {
        ConfigManager.init(ConfigManager.getPath());
        mTable.reloadData();
        
        // ✅ 正确：成功时显示提示
        UIHelper.showTipsDialog("重新加载成功");
        
    } catch (IllegalArgumentException e) {
        // ✅ 正确：失败时显示错误对话框
        Logger.error("Failed to reload config: %s", e.getMessage());
        UIHelper.showErrorDialog("重新加载失败: " + e.getMessage());
    }
}
```

### 日志记录

```java
// ERROR - 错误，需要关注
Logger.error("Failed to load config: %s", e.getMessage());

// WARN - 警告，可能有问题但不影响运行
Logger.warn("Config data at index %d has no rules", i);

// INFO - 信息，重要的业务流程
Logger.info("Config loaded: %d rules", count);

// DEBUG - 调试信息
Logger.debug("Cache hit for key: %s", cacheKey);
```

---

## 测试策略

### 测试原则

1. **测试核心功能**：优先测试业务逻辑和关键路径
2. **最小化测试**：避免过度测试，专注于有价值的测试
3. **快速反馈**：测试应该快速执行，提供即时反馈
4. **可维护性**：测试代码应该易于理解和维护
5. **独立性**：测试之间不应该相互依赖

### 测试代码分离原则

**核心原则**：测试代码必须与核心逻辑代码分离，写在单独的源码目录中。

**目录结构**：
- **核心代码**：`src/main/java/` - 插件的核心功能实现
- **测试代码**：`src/test/java/` - 单元测试和集成测试

**例外情况**：
- 只有在测试代码必须与核心代码紧密耦合时，才可以放在一起
- 例如：测试辅助类、Mock 对象等

### 测试目录结构

```
burp-plugin/
└── src/
    ├── main/
    │   └── java/
    │       └── burp/
    │           ├── common/
    │           │   └── utils/
    │           │       └── StringUtils.java
    │           └── {plugin}/
    │               ├── manager/
    │               │   └── ConfigManager.java
    │               └── ui/
    │                   └── tab/
    │                       └── MainTab.java
    └── test/
        └── java/
            └── burp/
                ├── common/
                │   └── utils/
                │       └── StringUtilsTest.java
                └── {plugin}/
                    ├── manager/
                    │   └── ConfigManagerTest.java
                    └── ui/
                        └── tab/
                            └── MainTabTest.java
```

### 单元测试示例

#### 配置管理测试

```java
public class ConfigManagerTest {
    
    @Test
    public void testLoadConfig_ValidYaml_Success() {
        // Arrange
        String configPath = "src/test/resources/config_valid.yaml";
        
        // Act
        ConfigManager.init(configPath);
        
        // Assert
        assertNotNull(ConfigManager.getConfig());
        assertTrue(ConfigManager.isEnabled());
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void testLoadConfig_InvalidYaml_ThrowsException() {
        // Arrange
        String configPath = "src/test/resources/config_invalid.yaml";
        
        // Act
        ConfigManager.init(configPath);
        
        // Assert - 期望抛出异常
    }
}
```

#### 工具类测试

```java
public class StringUtilsTest {
    
    @Test
    public void testIsEmpty_NullString_ReturnsTrue() {
        assertTrue(StringUtils.isEmpty(null));
    }
    
    @Test
    public void testIsEmpty_EmptyString_ReturnsTrue() {
        assertTrue(StringUtils.isEmpty(""));
    }
    
    @Test
    public void testIsEmpty_NonEmptyString_ReturnsFalse() {
        assertFalse(StringUtils.isEmpty("test"));
    }
}
```

### Maven 测试命令

```bash
# 运行所有测试
mvn test

# 运行特定测试类
mvn test -Dtest=ConfigManagerTest

# 运行特定测试方法
mvn test -Dtest=ConfigManagerTest#testLoadConfig_ValidYaml_Success

# 跳过测试（构建时）
mvn clean package -DskipTests
```

### 测试最佳实践

#### AAA 模式

```java
@Test
public void testMethod() {
    // Arrange - 准备测试数据和环境
    String input = "test";
    
    // Act - 执行被测试的方法
    String result = processInput(input);
    
    // Assert - 验证结果
    assertEquals("TEST", result);
}
```

#### 使用 @Before 和 @After

```java
public class ConfigManagerTest {
    
    private String configPath;
    
    @Before
    public void setUp() {
        // 每个测试前执行
        configPath = "src/test/resources/config.yaml";
        ConfigManager.init(configPath);
    }
    
    @After
    public void tearDown() {
        // 每个测试后执行
        ConfigManager.clearCache();
    }
    
    @Test
    public void testGetConfig() {
        assertNotNull(ConfigManager.getConfig());
    }
}
```

---

## 最佳实践

### 模块化设计
- 将功能拆分为独立的 Manager
- UI 和业务逻辑分离
- 通用组件放在 common 包

### 线程安全
- Manager 类使用单例模式
- 共享数据使用线程安全集合
- 避免在 UI 线程执行耗时操作

### 资源管理
- 使用 try-with-resources 管理资源
- 插件卸载时清理线程池
- 及时释放大对象

### 用户体验
- 长时间操作显示进度条
- 提供友好的错误提示
- 支持国际化（i18n）
- 支持深色模式适配

### 安全考虑
- 验证所有用户输入
- 敏感数据加密存储
- 限制文件系统和网络访问

### 深色模式适配

**默认要求**：除非明确指定，所有插件都需要支持深色模式。

#### Montoya API 深色模式支持

```java
public class MyExtension implements BurpExtension {
    
    @Override
    public void initialize(MontoyaApi api) {
        // 获取当前主题
        UserInterface ui = api.userInterface();
        Theme currentTheme = ui.currentTheme();
        
        // 根据主题设置颜色
        Color backgroundColor = currentTheme == Theme.DARK 
            ? new Color(43, 43, 43) 
            : Color.WHITE;
        
        Color foregroundColor = currentTheme == Theme.DARK 
            ? new Color(187, 187, 187) 
            : Color.BLACK;
        
        // 应用到 UI 组件
        JPanel panel = new JPanel();
        panel.setBackground(backgroundColor);
        panel.setForeground(foregroundColor);
    }
}
```

#### 主题切换监听

```java
// 监听主题变化
api.userInterface().registerThemeChangedHandler(theme -> {
    // 更新 UI 颜色
    updateUIColors(theme);
});
```

#### 推荐颜色方案

**深色模式**：
- 背景色：`#2B2B2B` (43, 43, 43)
- 前景色：`#BBBBBB` (187, 187, 187)
- 边框色：`#323232` (50, 50, 50)
- 选中色：`#214283` (33, 66, 131)

**浅色模式**：
- 背景色：`#FFFFFF` (255, 255, 255)
- 前景色：`#000000` (0, 0, 0)
- 边框色：`#D0D0D0` (208, 208, 208)
- 选中色：`#3875D7` (56, 117, 215)

### 国际化（i18n）支持

**默认要求**：除非明确指定，所有插件都需要支持国际化。

#### 资源文件结构

```
src/main/resources/
└── i18n/
    ├── messages_zh_CN.properties  # 中文
    ├── messages_en_US.properties  # 英文
    └── messages.properties        # 默认（英文）
```

#### 资源文件示例

**messages_zh_CN.properties**：
```properties
plugin.name=我的插件
plugin.description=这是一个示例插件
button.start=开始
button.stop=停止
message.success=操作成功
message.error=操作失败：{0}
```

**messages_en_US.properties**：
```properties
plugin.name=My Plugin
plugin.description=This is a sample plugin
button.start=Start
button.stop=Stop
message.success=Operation successful
message.error=Operation failed: {0}
```

#### 使用国际化

```java
public class I18nHelper {
    private static ResourceBundle sBundle;
    
    static {
        // 加载资源文件
        Locale locale = Locale.getDefault();
        sBundle = ResourceBundle.getBundle("i18n.messages", locale);
    }
    
    public static String getString(String key) {
        return sBundle.getString(key);
    }
    
    public static String getString(String key, Object... args) {
        String pattern = sBundle.getString(key);
        return MessageFormat.format(pattern, args);
    }
}

// 使用示例
String pluginName = I18nHelper.getString("plugin.name");
String errorMsg = I18nHelper.getString("message.error", "文件不存在");
```

#### UI 组件国际化

```java
public class MyTab implements ITab {
    
    private void initUI() {
        // 使用国际化文本
        JButton startButton = new JButton(I18nHelper.getString("button.start"));
        JButton stopButton = new JButton(I18nHelper.getString("button.stop"));
        
        // 设置工具提示
        startButton.setToolTipText(I18nHelper.getString("tooltip.start"));
    }
    
    @Override
    public String tabCaption() {
        return I18nHelper.getString("plugin.name");
    }
}

---

## 参考资料

- **Montoya API 文档**：https://portswigger.github.io/burp-extensions-montoya-api/
- **Burp Extensions**：https://portswigger.net/burp/extender
- **Maven 文档**：https://maven.apache.org/guides/

---

## 变更日志

### v2.0.0 (2025-12-02)
- 移除 Gradle 构建系统支持，仅支持 Maven
- 移除 Legacy Extender API，仅支持 Montoya API
- 新增测试代码分离原则
- 新增 POM 最佳实践和完整示例
- 新增深色模式适配指南（默认要求）
- 新增国际化（i18n）支持指南（默认要求）
- 优化版本管理和配置分离

### v1.0.0 (2025-12-02)
- 初始版本

---

**版本**：2.0.0  
**最后更新**：2025-12-02  
**适用范围**：所有 BurpSuite Java 插件项目
