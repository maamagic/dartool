# dartool

[![pub version](https://img.shields.io/pub/v/dartool.svg)](https://pub.dev/packages/dartool)

> 一个纯 Dart 的 Hutool 风格工具库 —— 简单、统一、开箱即用。

`dartool` 是 `dartool` 项目的**纯 Dart 核心包**，零 Flutter 依赖，Flutter 项目和纯 Dart CLI/服务端项目均可使用。设计上借鉴了 [Hutool](https://hutool.cn/) 的哲学：**按需引入、模块化、一个方法解决一类问题**。

## ✨ 特性

- 🧩 **模块化**：按需引入，不拖入无关依赖
- 🎯 **纯 Dart**：不依赖 Flutter，纯 Dart 项目直接可用
- 📦 **统一 API**：命名风格一致，参数友好，开箱即用
- ✅ **高测试覆盖**：核心模块单测覆盖，持续集成保障
- 🚀 **Dart 3 + 空安全**：基于 Dart 3.9 SDK，风格规范（`lints`）

## 📦 安装

```yaml
dependencies:
  dartool: ^0.1.0-dev.1
```

```bash
dart pub get
```

## 🚀 快速开始

```dart
import 'package:dartool/dartool.dart';

void main() {
  // 字符串工具
  print(StrUtil.isBlank('   '));               // true
  print(StrUtil.toCamelCase('hello_world'));  // helloWorld

  // 集合工具
  print(CollectionUtil.isEmpty([]));          // true
  print([3, 1, 2].distinct());                // [3, 1, 2]

  // 日期工具
  print(DateUtil.formatNow());                 // 2026-09-21 12:00:00

  // 校验工具
  print(ValidateUtil.isEmail('a@b.com'));      // true
  print(ValidateUtil.isMobile('13800138000')); // true

  // ID 工具
  print(IdUtil.uuid());                        // xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

  // 结果容器
  final r = Result.success('ok');
  print(r.isSuccess);                          // true

  // 可空值容器
  final op = Optional.of('hello');
  print(op.orElse('default'));                 // hello
}
```

## 📐 模块速览

| 工具类 | 说明 |
|---|---|
| `StrUtil` | 字符串判空、大小写转换、去空格、截断、驼峰 / 下划线互转等 |
| `CollectionUtil` | 集合判空、去重、分页、扁平化、分组等 |
| `DateUtil` | 格式化、解析、时间戳互转、相对时间、时区等 |
| `RegexUtil` | 常用正则（手机号 / 邮箱 / URL / 身份证等）与匹配判断 |
| `EnumUtil` | 枚举按名 / 值解析、遍历等 |
| `ValidateUtil` | 数据校验（非空、邮箱、手机号、身份证等） |
| `ConvertUtil` | 类型转换（字符串↔数字↔布尔等，带兜底） |
| `IdUtil` | UUID、雪花 ID、短唯一 ID 等 |
| `Optional` | 可空值容器（类似 Java `Optional`） |
| `Result` | 结果容器（成功 / 失败，携带数据或错误） |

## 🛠 开发

```bash
# 安装 melos（工作区根目录执行）
dart pub global activate melos
melos bootstrap

# 进入包内开发
cd packages/dartool
dart analyze
dart test
```

## 📄 文档

- API 文档由 `dartdoc` 生成：`dart doc`
- 源码内置详细注释与示例

## 🤝 贡献

欢迎提 Issue 与 PR。提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/)，代码风格遵循 `lints`，新增功能请编写单测。

## 📃 License

[MIT](../../LICENSE)