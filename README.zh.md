# dartool

[![CI](https://github.com/maamagic/dartool/actions/workflows/ci.yml/badge.svg)](https://github.com/maamagic/dartool/actions)

> 一个面向 Flutter / Dart 的 Hutool 风格工具库 —— 简单、统一、开箱即用。

`dartool` 借鉴了 Java 生态 [Hutool](https://hutool.cn/) 的设计哲学：**按需引入、模块化、一个方法解决一类问题**。仓库使用 [melos](https://melos.invertase.dev/) 管理，拆分为多个子包。

## 子包

| 包 | 定位 | pub |
|---|---|---|
| [dartool](packages/dartool) | 纯 Dart 核心（字符串 / 集合 / 日期 / 正则 / 枚举 / 校验 / 转换 / ID 等） | [![pub](https://img.shields.io/pub/v/dartool.svg)](https://pub.dev/packages/dartool) |
| [dartool_flutter](packages/dartool_flutter) | Flutter 专属扩展（平台判断 / 日志 / Widget 简写等） | [![pub](https://img.shields.io/pub/v/dartool_flutter.svg)](https://pub.dev/packages/dartool_flutter) |

更多扩展包（`dartool_http`、`dartool_crypto`、`dartool_cache`、`dartool_widget` 等）将按需迭代。

## 快速开始

### 纯 Dart 项目

```yaml
dependencies:
  dartool: ^0.1.0-dev.2
```

```dart
import 'package:dartool/dartool.dart';

print(StrUtil.isBlank('   '));               // true
print(StrUtil.toCamelCase('hello_world'));   // helloWorld
print(IdUtil.uuid());                         // xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Flutter 项目

```yaml
dependencies:
  dartool: ^0.1.0-dev.2
  dartool_flutter: ^0.1.0-dev.2
```

```dart
import 'package:dartool/dartool.dart';
import 'package:dartool_flutter/dartool_flutter.dart';

if (PlatformUtil.isAndroid) {
  LogUtil.info('running on Android');
}
```

## 本地开发

前置：安装 [Flutter](https://flutter.dev)（自带 Dart 3.9+）。

```bash
# 安装 melos
dart pub global activate melos

# 引导工作区（拉取所有包依赖）
melos bootstrap

# 静态分析
melos run analyze

# 运行全部测试
melos run test

# 发布前检查（analyze + test + format）
melos run pre_publish
```

## 模块一览

### dartool（纯 Dart 核心）

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
| `Optional` | 可空值容器 |
| `Result` | 结果容器（成功 / 失败） |
| `ColorUtil` | 颜色转换、亮度、插值（纯 Dart） |
| `CryptoUtil` | Base64 / Hex 编码、MD5 / SHA / HMAC 哈希、XOR 混淆 |

### dartool_flutter（Flutter 扩展）

| 工具类 | 说明 |
|---|---|
| `PlatformUtil` | 平台判断，Web 安全 |
| `LogUtil` | 分级日志，可替换输出 |
| `WidgetUtil` | 常用 Flutter Widget 简写 |

## 贡献

欢迎提 Issue 与 PR。提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/)，代码风格遵循 `lints`，新增功能请编写单测。

## License

[MIT](LICENSE)