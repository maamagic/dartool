# dartool

> 一个面向 Flutter / Dart 的 Hutool 风格工具库 —— 简单、统一、开箱即用。
> A Hutool-style toolkit for Flutter / Dart.

`dartool` 旨在为日常 Flutter/Dart 开发提供一套**统一、简洁、开箱即用**的工具方法，减少样板代码，让你专注业务本身。它借鉴了 Java 生态中 [Hutool](https://hutool.cn/) 的设计哲学：**按需引入、模块化、一个方法解决一类问题**。

## ✨ 特性



* 🧩 **模块化**：像 Hutool 一样拆分为多个包，按需引入，绝不拖累无关依赖。

* 🎯 **纯 Dart 友好**：核心 `dartool` 包零 Flutter 依赖，纯 Dart 项目也能使用。

* 📦 **统一 API**：命名一致、参数友好、开箱即用。

* ✅ **高测试覆盖**：核心模块单测覆盖率门槛 ≥ 80%，持续集成保障。

* 🚀 **空安全 + 现代 Dart**：基于 Dart 3 空安全，风格规范（`lints`）。

## 📦 包结构



| 包                                            | 定位                                                    | 依赖        |
| -------------------------------------------- | ----------------------------------------------------- | --------- |
| [dartool](packages/dartool)                  | 纯 Dart 核心工具（字符串 / 集合 / 日期 / 正则 / 枚举 / 校验 / 转换 / ID 等） | 无 Flutter |
| [dartool\_flutter](packages/dartool_flutter) | Flutter 专属能力（平台 / 设备 / 网络 / 日志 / 表单校验等）               | Flutter   |

更多扩展包（`dartool_http`、`dartool_crypto`、`dartool_cache`、`dartool_widget` 等）将按需迭代。

## 🚀 快速开始



```
\# pubspec.yaml

dependencies:

    dartool: ^0.1.0
```



```
import 'package:dartool/dartool.dart';

void main() {

// 字符串工具

print(StrUtil.isBlank('   '));        // true

print(StrUtil.toCamelCase('hello\_world')); // helloWorld

// 集合工具

print(CollectionUtil.isEmpty(\[]));    // true

print(\[3, 1, 2].distinct());          // \[3, 1, 2]

// 日期工具

print(DateUtil.formatNow());          // 2026-09-21 12:00:00

// ID 工具

print(IdUtil.uuid());                 // xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

// 结果容器

final r = Result.success('ok');

print(r.isSuccess);                   // true

}
```

## 🛠 开发

前置：安装 [Flutter](https://flutter.dev)（自带 Dart 3.9+）。



```
\# 安装 melos

dart pub global activate melos

\# 引导工作区（拉取所有包依赖）

melos bootstrap

\# 静态分析

melos run analyze

\# 运行全部测试

melos run test

\# 发布前检查

melos run pre\_publish
```

## 📐 模块速览（dartool）



| 工具类                   | 说明                               |
| --------------------- | -------------------------------- |
| `StrUtil`             | 字符串判空、大小写转换、去空格、截断、驼峰 / 下划线互转等   |
| `CollectionUtil`      | 集合判空、去重、分页、扁平化、分组等               |
| `DateUtil`            | 格式化、解析、时间戳互转、相对时间、时区等            |
| `RegexUtil`           | 常用正则（手机号 / 邮箱 / URL / 身份证等）与匹配判断 |
| `EnumUtil`            | 枚举按名 / 值解析、遍历等                   |
| `Optional` / `Result` | 可空值容器 / 结果容器（类似 Java `Optional`） |
| `ValidateUtil`        | 数据校验（非空、邮箱、手机号、身份证等）             |
| `ConvertUtil`         | 类型转换（字符串↔数字↔布尔等，带兜底）             |
| `IdUtil`              | UUID、雪花 ID、短唯一 ID 等              |

## 📄 文档



* API 文档由 `dartdoc` 生成（`dart doc`）。

* 各包内部附详细注释与示例。

## 🤝 贡献

欢迎提 Issue 与 PR。提交信息请遵循 [Conventional Commits](https://www.conventionalcommits.org/)，代码风格遵循 `lints`，并为新增功能编写单测。

## 📃 License

[MIT](LICENSE)