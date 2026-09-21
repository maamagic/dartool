# dartool_flutter

[![pub version](https://img.shields.io/pub/v/dartool_flutter.svg)](https://pub.dev/packages/dartool_flutter)
[![English](https://img.shields.io/badge/README-English-blue)](README.md)

> dartool 的 Flutter 专属扩展。

`dartool_flutter` 提供依赖 Flutter SDK 的工具（平台判断、日志、Widget 简写等），与纯 Dart 的 `dartool` 核心包配合使用。

## 特性

- 独立包 —— 纯 Dart 项目无需依赖本包
- Web 安全的平台判断 —— 在 `dart:io` 不可用的 Web 平台也能正确工作
- 轻量日志 —— 分级过滤、支持 tag、输出可替换
- Widget 简写 —— 常用 Flutter Widget 的精简封装
- Dart 3 + 空安全 —— 基于 Dart 3.9 SDK / Flutter 3.22+

## 安装

```yaml
dependencies:
  dartool: ^0.1.0-dev.2
  dartool_flutter: ^0.1.0-dev.2
```

```bash
flutter pub get
```

## 快速开始

```dart
import 'package:dartool/dartool.dart';
import 'package:dartool_flutter/dartool_flutter.dart';

void main() {
  // 平台判断（Web 安全，永不抛异常）
  if (PlatformUtil.isAndroid) {
    LogUtil.info('running on Android');
  }
  if (PlatformUtil.isMobile) {
    LogUtil.debug('mobile device detected');
  }
  if (PlatformUtil.isDesktop) {
    LogUtil.warn('desktop platform');
  }

  // 带 tag 的日志
  LogUtil.error('network failed', tag: 'NetworkService');

  // 自定义最低日志级别（例如 release 环境屏蔽 debug）
  LogUtil.minLevel = LogLevel.info;

  // 将日志输出到自定义通道
  LogUtil.output = (line) => myRemoteLogger.send(line);
}

// Flutter Widget 中的简写用法
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetUtil.sizedBoxH(16),
          WidgetUtil.paddingAll(child: Text('hi'), value: 8),
          WidgetUtil.expanded(child: ListView()),
          WidgetUtil.safeArea(child: HomePage()),
        ],
      ),
    );
  }
}
```

## API 一览

| 工具类 | 说明 |
|---|---|
| `PlatformUtil` | 平台判断（Android、iOS、Web、macOS、Windows、Linux、Mobile、Desktop），Web 安全 |
| `LogUtil` | 分级日志（debug、info、warn、error），支持 tag、级别过滤、输出可替换 |
| `WidgetUtil` | 常用 Widget 简写（SizedBox、Padding、Expanded、SafeArea 等） |

## 本地开发

```bash
# 安装 melos（在工作区根目录执行）
dart pub global activate melos
melos bootstrap

# 在本包内开发
cd packages/dartool_flutter
flutter analyze
flutter test
```

## 文档

- API 文档通过 `dart doc` 生成
- 源码内含详细的文档注释
- [English README](README.md)

## 贡献

欢迎提 Issue 与 PR。提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/)，代码风格遵循 `lints`，新增功能请编写单测。

## License

[MIT](../../LICENSE)