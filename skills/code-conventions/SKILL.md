---
name: code-conventions
description: 定义代码约定规范，包括路径处理约定和代码风格约定。当需要处理文件路径、规范化路径显示或遵循项目代码风格时使用此技能。
---

# 代码约定规范

本技能定义 CodeQL Scanner 项目的代码约定和风格标准。

## 路径处理约定

- **直接使用 normpath 原生 API，严禁过度包装**
- 使用 `normalized_display()` 进行路径显示
- 使用 `log_info_with_path!()` 宏记录路径信息
- Clippy 规则会自动检查不当的 `display()` 使用

## 代码风格约定

- 保持代码简洁，避免不必要的复杂度
- 优先使用标准库和成熟的第三方库
- 避免过度抽象和包装
