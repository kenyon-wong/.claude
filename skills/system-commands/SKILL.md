---
name: system-commands
description: 提供系统命令使用和时间处理的最佳实践，包括 PowerShell 命令、时间获取和命令执行安全规范。当需要获取系统时间、执行 PowerShell 命令、生成文档时间戳或进行系统信息查询时使用此技能。
---

# 系统命令与时间处理规范

本技能提供系统命令使用和时间处理的最佳实践。

## 时间获取最佳实践

### 使用系统 PowerShell 命令获取准确时间

在需要获取当前系统时间时，应使用系统的 PowerShell 命令而不是依赖 AI 的内置时间，以确保时间的准确性。

#### 推荐命令

```powershell
# 获取中文格式的日期时间
Get-Date -Format "yyyy年MM月dd日 HH:mm:ss"

# 获取 ISO 格式的日期时间
Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# 获取详细的日期时间信息
Get-Date -Format "yyyy年MM月dd日 dddd HH:mm:ss"

# 获取 UTC 时间
(Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
```

#### 使用场景

1. **文档生成时间戳**
   - 审查报告
   - 技术文档
   - 变更日志

2. **日志记录**
   - 操作记录
   - 错误报告
   - 性能分析

3. **版本标记**
   - 构建时间
   - 发布时间
   - 测试时间

## 系统命令使用规范

### Windows 环境命令

#### 系统信息获取
```powershell
# 获取系统信息
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory

# 获取 CPU 信息
Get-WmiObject -Class Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

# 获取内存信息
Get-WmiObject -Class Win32_ComputerSystem | Select-Object TotalPhysicalMemory
```

#### 文件系统操作
```powershell
# 获取目录大小
Get-ChildItem -Path "." -Recurse | Measure-Object -Property Length -Sum

# 查找文件
Get-ChildItem -Path "." -Recurse -Filter "*.rs" | Select-Object Name, Length, LastWriteTime

# 统计代码行数
Get-ChildItem -Path "." -Recurse -Filter "*.rs" | Get-Content | Measure-Object -Line
```

#### 进程和服务管理
```powershell
# 获取进程信息
Get-Process | Where-Object {$_.ProcessName -like "*rust*"} | Select-Object Name, Id, CPU, WorkingSet

# 获取服务状态
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object Name, Status
```

### 跨平台命令考虑

虽然项目主要在 Windows 环境下运行，但也应考虑跨平台兼容性：

#### Linux/macOS 等效命令
```bash
# 时间获取
date "+%Y年%m月%d日 %H:%M:%S"

# 系统信息
uname -a
cat /proc/cpuinfo
free -h
```

## 命令执行安全规范

### 安全原则

1. **输入验证**
   - 验证命令参数
   - 防止命令注入
   - 限制执行权限

2. **错误处理**
   - 捕获命令执行错误
   - 提供友好的错误信息
   - 记录执行日志

3. **资源管理**
   - 设置执行超时
   - 限制资源使用
   - 清理临时文件

### 实施示例

```rust
// Rust 中执行 PowerShell 命令的安全实践
use std::process::Command;
use std::time::Duration;

fn get_system_time() -> Result<String, Box<dyn std::error::Error>> {
    let output = Command::new("powershell")
        .arg("-Command")
        .arg("Get-Date -Format 'yyyy年MM月dd日 HH:mm:ss'")
        .timeout(Duration::from_secs(5)) // 设置超时
        .output()?;
    
    if output.status.success() {
        Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
    } else {
        Err(format!("命令执行失败: {}", 
            String::from_utf8_lossy(&output.stderr)).into())
    }
}
```

## 文档时间戳标准

### 标准格式

1. **中文格式**（推荐用于中文文档）
   ```
   生成时间: 2025年09月30日 09:35:04
   ```

2. **ISO 格式**（推荐用于技术文档）
   ```
   Generated: 2025-09-30 09:35:04
   ```

3. **详细格式**（推荐用于重要报告）
   ```
   生成时间: 2025年09月30日 星期二 09:35:04
   时区: UTC+8 (中国标准时间)
   ```

### 应用场景

- **审查报告**: 使用详细格式
- **技术文档**: 使用 ISO 格式
- **日常记录**: 使用中文格式
- **国际协作**: 使用 UTC 时间

## 最佳实践总结

1. **始终使用系统命令获取时间**，确保准确性
2. **选择合适的时间格式**，根据文档类型和受众
3. **包含时区信息**，避免时间混淆
4. **设置命令超时**，防止系统挂起
5. **记录执行环境**，便于问题排查
6. **定期验证时间同步**，确保系统时间准确
