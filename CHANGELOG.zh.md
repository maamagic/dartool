# 更新日志

## [0.1.0-dev.2] - 2026-09-21

### Pub.dev 评分修复

- 缩短 pubspec.yaml 的 `description` 并补充 `homepage` 字段。
- README.md 与 CHANGELOG.md 统一为英文（去除 emoji / CJK）。
- 两个包均补充 `example/main.dart`。
- 补充 `ConvertUtil` 与 `ValidateUtil` 的 dartdoc 注释。
- 修复示例与 README 中错误的 API 调用（`CollectionUtil.distinct`、`Optional.getOrElse`）。
- 新增 `ColorUtil`（颜色转换 / 亮度 / 插值）。
- 新增 `CryptoUtil`（Base64 / Hex / MD5 / SHA / HMAC / XOR）。
- 新增 `WidgetUtil`（Flutter Widget 简写）。

## [0.1.0-dev.1] - 2026-09-21

### 首个开发版发布到 pub.dev

- `dartool` 与 `dartool_flutter` 同时发布到 pub.dev。
- 补充 `repository` 字段、LICENSE、README、CHANGELOG，通过 `pub publish` 校验。

### 工程初始化

- 初始化 melos monorepo 工作区，拆分为 `dartool`（纯 Dart core）与 `dartool_flutter`（Flutter 层）两个包。
- `dartool` 核心模块集：`StrUtil`、`CollectionUtil`、`DateUtil`、`RegexUtil`、`EnumUtil`、`Optional`、`Result`、`ValidateUtil`、`ConvertUtil`、`IdUtil`。
- `dartool_flutter` Flutter 扩展模块：`PlatformUtil`、`LogUtil`。
- 配套单元测试、GitHub Actions CI 与 pana 评分检查。