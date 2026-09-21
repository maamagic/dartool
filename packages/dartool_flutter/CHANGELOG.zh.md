# 更新日志

## 0.1.0-dev.2 - 2026-09-21

### Pub.dev 评分修复

- 缩短 pubspec.yaml 的 `description` 并补充 `homepage` 字段。
- README.md 与 CHANGELOG.md 统一为英文（去除 emoji / CJK）。
- 补充 `example/main.dart`。
- `dartool` 依赖提升至 `^0.1.0-dev.2`。
- 新增 `WidgetUtil`（Flutter Widget 简写）。

## 0.1.0-dev.1 - 2026-09-21

### 首个开发版发布到 pub.dev

- 补充 `repository` 字段、LICENSE、README、CHANGELOG，通过 `pub publish` 校验。
- `dartool` 依赖从 `any` 收紧为 `^0.1.0-dev.1`。

### 工程初始化

- melos monorepo 工作区。
- Flutter 模块：`PlatformUtil`、`LogUtil`。
- 配套单元测试、GitHub Actions CI 与 pana 评分检查。