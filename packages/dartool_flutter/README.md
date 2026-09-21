# dartool_flutter

[![pub version](https://img.shields.io/pub/v/dartool_flutter.svg)](https://pub.dev/packages/dartool_flutter)

> dartool 的 Flutter 专属扩展 —— 依赖 Flutter 的工具集合。

`dartool_flutter` 提供依赖 Flutter SDK 的工具能力（平台判断、日志等），与纯 Dart 的 `dartool` 核心包配合使用。

## ✨ 特性

- 🧩 **独立分包**：纯 Dart 项目无需引入此包
- 🌐 **Web 兼容**：平台判断正确处理 Web 环境（`dart:io` 在 Web 不可用）
- 📝 **轻量日志**：分级过滤 + 标签 + 可替换输出通道，release 自动降级到 `debugPrint`
- 🚀 **Dart 3 + 空安全**：基于 Dart 3.9 SDK / Flutter 3.22+，风格规范

## 📦 安装

```yaml
dependencies:
  dartool: ^0.1.0-dev.1
  dartool_flutter: ^0.1.0-dev.1
```

```bash
flutter pub get
```

## 🚀 快速开始

```dart
import 'package:dartool/dartool.dart';
import 'package:dartool_flutter/dartool_flutter.dart';

void main() {
  // 平台判断（Web 安全，不会抛异常）
  if (PlatformUtil.isAndroid) {
    LogUtil.info('running on Android');
  }
  if (PlatformUtil.isMobile) {
    LogUtil.debug('mobile device detected');
  }
  if (PlatformUtil.isDesktop) {
    LogUtil.warn('desktop platform');
  }

  // 带标签的日志
  LogUtil.error('network failed', tag: 'NetworkService');

  // 自定义最低日志级别（release 时关闭 debug）
  LogUtil.minLevel = LogLevel.info;

  // 接入自定义日志系统
  LogUtil.output = (line) => myRemoteLogger.send(line);
}
```

## 📐 模块速览

| 工具类 | 说明 |
|---|---|
| `PlatformUtil` | 平台判断（Android / iOS / Web / macOS / Windows / Linux / Mobile / Desktop），Web 安全 |
| `LogUtil` | 分级日志（debug / info / warn / error），标签、最低级别过滤、可替换输出 |

## 🛠 开发

```bash
# 安装 melos（工作区根目录执行）
dart pub global activate melos
melos bootstrap

# 进入包内开发
cd packages/dartool_flutter
flutter analyze
flutter test
```

## 📄 文档

- API 文档由 `dartdoc` 生成：`dart doc`
- 源码内置详细注释与示例

## 🤝 贡献

欢迎提 Issue 与 PR。提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/)，代码风格遵循 `lints`，新增功能请编写单测。

## 📃 License

[MIT](../../LICENSE)