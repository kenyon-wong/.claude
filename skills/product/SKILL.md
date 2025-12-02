---
name: burp-plugin-development
description: BurpSuite 插件开发指南和最佳实践。涵盖插件类型（被动扫描、主动扫描、流量处理、UI 扩展）、核心功能模块（HTTP 处理、数据存储、配置管理、UI 组件）、性能优化（线程池、缓存、限流）、用户体验设计、安全考虑。适用于规划插件功能、设计架构或讨论用户需求时使用。
---

# BurpSuite 插件开发指南

## 插件类型

### 1. 被动扫描插件
- **用途**：分析 HTTP 流量，发现安全问题
- **特点**：不发送额外请求，对目标无侵入
- **示例**：敏感信息泄露检测、配置错误识别

### 2. 主动扫描插件
- **用途**：主动发送请求测试漏洞
- **特点**：可能对目标产生影响，需要用户授权
- **示例**：SQL 注入测试、XSS 检测、目录扫描

### 3. 流量处理插件
- **用途**：修改、记录或分析 HTTP 流量
- **特点**：实时处理，性能要求高
- **示例**：请求/响应修改、流量记录、协议转换

### 4. UI 扩展插件
- **用途**：提供额外的用户界面功能
- **特点**：增强 Burp 的可用性
- **示例**：数据可视化、报告生成、配置管理

## 核心功能模块

### 1. HTTP 处理
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

**关键功能**：
- 请求/响应拦截和修改
- 流量分析和过滤
- 数据提取和解析

### 2. 数据存储
```java
// 配置存储
public class ConfigManager {
    private static final String CONFIG_DIR = ".config/MyPlugin/";
    
    public void saveConfig(Config config) {
        // 保存到文件系统
        Path configPath = getConfigPath();
        Files.writeString(configPath, toJson(config));
    }
    
    public Config loadConfig() {
        // 从文件系统加载
        Path configPath = getConfigPath();
        return fromJson(Files.readString(configPath));
    }
}
```

**存储选项**：
- 文件系统（配置、规则、日志）
- 内存缓存（临时数据、性能优化）
- Burp 项目文件（与项目关联的数据）

### 3. 配置管理
```java
public class Config {
    // 基础配置
    private boolean enabled = true;
    private int threadCount = 10;
    private int qpsLimit = 100;
    
    // 规则配置
    private List<Rule> rules = new ArrayList<>();
    
    // 过滤配置
    private List<String> allowlist = new ArrayList<>();
    private List<String> blocklist = new ArrayList<>();
}
```

**配置要点**：
- 提供合理的默认值
- 支持导入/导出
- 实时生效或重启生效
- 配置验证

### 4. UI 组件
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

**UI 设计原则**：
- 简洁直观
- 响应式布局
- 快捷键支持
- 状态反馈

## 性能优化

### 1. 线程池管理
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

### 2. 缓存策略
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

### 3. 限流控制
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

## 用户体验设计

### 1. 进度反馈
- 长时间操作显示进度条
- 提供取消操作的选项
- 显示当前状态和剩余时间

### 2. 错误处理
- 友好的错误提示
- 详细的错误日志
- 错误恢复机制

### 3. 国际化支持
```java
public class L {
    private static ResourceBundle sBundle;
    
    static {
        Locale locale = Locale.getDefault();
        sBundle = ResourceBundle.getBundle("i18n/messages", locale);
    }
    
    public static String get(String key) {
        return sBundle.getString(key);
    }
    
    public static String get(String key, Object... args) {
        return String.format(sBundle.getString(key), args);
    }
}
```

## 安全考虑

### 1. 输入验证
- 验证所有用户输入
- 防止路径遍历
- 防止命令注入

### 2. 权限控制
- 敏感操作需要确认
- 限制文件系统访问
- 限制网络访问

### 3. 数据保护
- 敏感数据加密存储
- 避免日志中记录敏感信息
- 安全地清理临时数据

## 目标用户

- 安全研究人员
- 渗透测试工程师
- Web 应用安全测试人员
- 安全开发人员

## 开发流程

1. **需求分析**：明确插件功能和目标用户
2. **架构设计**：设计模块结构和数据流
3. **原型开发**：实现核心功能
4. **测试验证**：单元测试和集成测试
5. **性能优化**：优化性能瓶颈
6. **用户测试**：收集用户反馈
7. **发布部署**：打包发布

---

**版本**：1.0.0  
**最后更新**：2025-12-02  
**适用范围**：所有 BurpSuite Java 插件项目
