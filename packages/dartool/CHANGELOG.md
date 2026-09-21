# Changelog

## [0.1.0-dev.1] - 2026-09-21

### 🎉 首个开发版发布到 pub.dev

- 补充 `repository` 字段、LICENSE、README、CHANGELOG，通过 `pub publish` 校验。

### 工程初始化

- 初始化 melos monorepo 工作区，拆分为 `dartool`（纯 Dart core）与 `dartool_flutter`（Flutter 层）两个包。
- `dartool` 首个核心模块集落地：`StrUtil`、`CollectionUtil`、`DateUtil`、`RegexUtil`、`EnumUtil`、`Optional`、`Result`、`ValidateUtil`、`ConvertUtil`、`IdUtil`。
- 配套单元测试、GitHub Actions CI 与 pana 评分检查。

> 当前为开发版，API 可能调整，暂未发布到 pub.dev。