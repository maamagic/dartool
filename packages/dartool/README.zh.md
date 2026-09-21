# dartool

[![pub version](https://img.shields.io/pub/v/dartool.svg)](https://pub.dev/packages/dartool)
[![English](https://img.shields.io/badge/README-English-blue)](README.md)

> 一个 Hutool 风格的 Dart 工具库 —— 简单、统一、开箱即用。

`dartool` 是 dartool 项目的纯 Dart 核心包，零 Flutter 依赖，既能在 Flutter 应用中使用，也能在纯 Dart CLI / 服务端项目中使用。借鉴 Java 生态 [Hutool](https://hutool.cn/) 的设计哲学：**按需引入、模块化、一个方法解决一类问题**。

## 特性

- 模块化 —— 按需引入，没有多余依赖
- 纯 Dart —— 零 Flutter 依赖，CLI / 服务端项目也能用
- 统一 API —— 命名一致、参数友好、拿来即用
- 单测完备 —— 每个核心模块都有单元测试
- Dart 3 + 空安全 —— 基于 Dart 3.9 SDK，使用 `lints`

## 安装

```yaml
dependencies:
  dartool: ^0.1.0-dev.2
```

```bash
dart pub get
```

## 快速开始

```dart
import 'package:dartool/dartool.dart';

void main() {
  // 字符串工具
  print(StrUtil.isBlank('   '));               // true
  print(StrUtil.toCamelCase('hello_world'));   // helloWorld

  // 集合工具
  print(CollectionUtil.isEmpty([]));            // true
  print(CollectionUtil.distinct([3, 1, 2, 1]));   // [3, 1, 2]

  // 日期工具
  print(DateUtil.formatNow());                  // 2026-09-21 12:00:00

  // 校验工具
  print(ValidateUtil.isEmail('a@b.com'));       // true
  print(ValidateUtil.isPhone('13800138000'));   // true

  // ID 生成
  print(IdUtil.uuid());                         // xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

  // 颜色工具
  print(ColorUtil.toHex(0xFF4080FF));           // #4080FF
  print(ColorUtil.hexToInt('#4080ff'));         // 0xFF4080FF

  // 加解密工具
  print(CryptoUtil.md5('hello'));               // 5d41402abc4b2a76b9719d911017c592
  print(CryptoUtil.base64Encode('hello'));      // aGVsbG8=

  // 结果容器
  final r = Result.success('ok');
  print(r.isSuccess);                           // true

  // 可空值容器
  final op = Optional.of('hello');
  print(op.getOrElse('default'));                 // hello
}
```

## API 一览

| 工具类 | 说明 |
|---|---|
| `StrUtil` | 字符串判空、大小写转换、去空格、截断、驼峰 / 下划线互转等 |
| `CollectionUtil` | 集合判空、去重、分页、扁平化、分组等 |
| `DateUtil` | 格式化、解析、时间戳互转、相对时间、时区等 |
| `RegexUtil` | 常用正则（手机号 / 邮箱 / URL / 身份证等）与匹配判断 |
| `EnumUtil` | 枚举按名 / 值解析、遍历等 |
| `ValidateUtil` | 数据校验（非空、邮箱、手机号、身份证、范围等） |
| `ConvertUtil` | 类型转换（字符串 ↔ 数字 ↔ 布尔 ↔ 时间，带兜底） |
| `IdUtil` | UUID、雪花 ID、短唯一 ID 等 |
| `ColorUtil` | 颜色转换（ARGB int ↔ hex）、亮度、插值 |
| `CryptoUtil` | Base64 / Hex 编码、MD5 / SHA1 / SHA256 / SHA512 哈希、HMAC、XOR 混淆 |
| `Optional` | 可空值容器 |
| `Result` | 结果容器（成功 / 失败） |

## 本地开发

```bash
# 安装 melos（在工作区根目录执行）
dart pub global activate melos
melos bootstrap

# 在本包内开发
cd packages/dartool
dart analyze
dart test
```

## 文档

- API 文档通过 `dart doc` 生成
- 源码内含详细的文档注释
- [English README](README.md)

## 贡献

欢迎提 Issue 与 PR。提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/)，代码风格遵循 `lints`，新增功能请编写单测。

## License

[MIT](../../LICENSE)