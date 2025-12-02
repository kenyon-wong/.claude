---
name: burp-plugin-tech
description: BurpSuite Java 插件技术栈和构建系统规范。Java 17+ 编译目标，Maven 构建（推荐），Montoya API（推荐）或 Legacy API，跨平台命令兼容性。单模块 Maven 结构，核心依赖（Montoya API、Gson、SnakeYAML 等），构建命令，assembly 插件配置。Java 17+ 特性使用指南。适用于设置构建、管理依赖或确保 Java 兼容性时使用。
---

# BurpSuite Java 插件技术栈与构建系统

## 技术约束

### Java 版本
- **推荐**：Java 17 (LTS) 或更高版本
- **最低**：Java 11（Montoya API 要求）
- **编译目标**：建议使用 Java 17 以获得最新特性

### 构建工具
- **推荐**：Maven（更成熟的生态系统）
- **可选**：Gradle（如果团队熟悉）

### Burp API 选择
- **推荐**：Montoya API（新项目）
  - 现代化 API 设计
  - 更好的类型安全
  - 持续更新和支持
- **可选**：Legacy Extender API（维护旧项目）
  - 仅用于维护现有插件
  - 新功能应迁移到 Montoya API

### 跨平台兼容性
- **命令**：使用跨平台命令或提供平台特定脚本
  - Windows：`&` 分隔符，`dir` 命令
  - Linux/Mac：`&&` 分隔符，`ls` 命令
- **路径**：使用 `File.separator` 或 `Path` API

## Maven 单模块结构

```
burp-plugin/                # 单模块项目
├── src/                    # 源代码
│   ├── main/
│   └── test/
├── target/                 # 构建输出
└── pom.xml                 # Maven POM
```

## 核心依赖

### BurpSuite API

#### Montoya API（推荐）

```xml
<dependency>
    <groupId>net.portswigger.burp.extensions</groupId>
    <artifactId>montoya-api</artifactId>
    <version>2025.5</version>
    <scope>provided</scope>
</dependency>
```

- **用途**：所有 Burp 集成功能
- **关键接口**：
  - `MontoyaApi` - 主 API 入口
  - `HttpRequestEditor` / `HttpResponseEditor` - HTTP 编辑器
  - `HttpHandler` - HTTP 流量处理
  - `Logging` - 日志记录
- **文档**：https://portswigger.github.io/burp-extensions-montoya-api/

**版本更新策略**：
1. 检查更新：https://github.com/portswigger/burp-extensions-montoya-api/releases
2. 更新前：查看 release notes 中的 breaking changes
3. 测试兼容性：更新后验证所有 Montoya API 使用
4. 更新路径：修改 `pom.xml` 中的版本标签

#### Legacy Extender API（维护旧项目）

```xml
<!-- 仅用于维护现有插件 -->
<dependency>
    <groupId>net.portswigger.burp.extender</groupId>
    <artifactId>burp-extender-api</artifactId>
    <version>2.3</version>
    <scope>provided</scope>
</dependency>
```

### 常用第三方依赖

#### JSON 处理
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

#### YAML 处理
```xml
<dependency>
    <groupId>org.yaml</groupId>
    <artifactId>snakeyaml</artifactId>
    <version>2.2</version>
</dependency>
```

#### HTTP 客户端（可选）
```xml
<dependency>
    <groupId>com.squareup.okhttp3</groupId>
    <artifactId>okhttp</artifactId>
    <version>4.11.0</version>
</dependency>
```

#### 日志（可选）
```xml
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>2.0.9</version>
</dependency>
```

## 构建命令

### Maven 命令

```bash
# 完整构建
mvn clean package

# 跳过测试
mvn clean package -DskipTests

# 运行测试
mvn test

# 运行特定测试
mvn test -Dtest=ClassName#methodName

# 清理
mvn clean

# 安装到本地仓库
mvn install
```

### Windows cmd 命令
```cmd
REM 使用 & 分隔符
mvn clean & mvn package

REM 跳过测试
mvn clean package -DskipTests
```

### Linux/Mac bash 命令
```bash
# 使用 && 分隔符
mvn clean && mvn package

# 跳过测试
mvn clean package -DskipTests
```

## 构建输出

- **产物**：`{PluginName}-v{version}.jar` 在 `target/` 目录
- **类型**：Uber JAR（包含所有依赖）
- **Assembly**：使用 maven-assembly-plugin 的 jar-with-dependencies 描述符

### Maven Assembly 配置

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>3.6.0</version>
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

## Java 17 Feature Usage Guidelines

Java 17 is an LTS release with many modern features that **should be used** to improve code quality:

### ✅ Recommended Java 17 Features

**Lambda Expressions & Stream API** (Java 8+):
```java
// ✅ Good: Use lambda for cleaner code
list.forEach(item -> System.out.println(item));

// ✅ Good: Use streams for collection processing
List<String> filtered = list.stream()
    .filter(s -> s.startsWith("test"))
    .collect(Collectors.toList());
```

**Optional** (Java 8+):
```java
// ✅ Good: Use Optional to avoid null checks
Optional<String> result = findValue();
return result.orElse("default");
```

**var keyword** (Java 10+):
```java
// ✅ Good: Use var for local variables with obvious types
var list = new ArrayList<String>();
var result = calculateSomething();
```

**Text Blocks** (Java 13+):
```java
// ✅ Good: Use text blocks for multi-line strings
String json = """
    {
        "name": "OneScan",
        "version": "2.2.0"
    }
    """;
```

**Records** (Java 14+):
```java
// ✅ Good: Use records for simple data carriers
public record FingerprintResult(String name, String value, boolean matched) {}
```

**Pattern Matching for instanceof** (Java 16+):
```java
// ✅ Good: Use pattern matching
if (obj instanceof String s) {
    System.out.println(s.toUpperCase());
}
```

**Sealed Classes** (Java 17):
```java
// ✅ Good: Use sealed classes for controlled inheritance
public sealed interface Result permits Success, Failure {}
```

### 📝 Best Practices

1. **Use modern Java features** to write cleaner, more maintainable code
2. **Leverage records** for DTOs and simple data structures
3. **Use text blocks** for JSON, SQL, and multi-line strings
4. **Apply pattern matching** to reduce boilerplate code
5. **Keep it readable** - don't over-complicate with functional programming
