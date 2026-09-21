# Changelog

## 0.1.0-dev.2 - 2026-09-21

### Pub.dev scoring fixes

- Shortened `description` in pubspec.yaml and added `homepage` field.
- Converted README.md and CHANGELOG.md to pure English (no emoji / CJK).
- Added `example/main.dart`.
- Bumped `dartool` dependency to `^0.1.0-dev.2`.

## 0.1.0-dev.1 - 2026-09-21

### First release on pub.dev

- Added `repository` and `homepage` fields to pubspec.yaml.
- Added LICENSE, README.md and CHANGELOG.md for pub.dev publishing.
- Tightened `dartool` dependency from `any` to `^0.1.0-dev.1`.

### Initial setup

- Melos monorepo workspace with `dartool` (pure-Dart core) and
  `dartool_flutter` (Flutter extensions).
- Flutter modules: `PlatformUtil`, `LogUtil`.
- Unit tests, GitHub Actions CI and pana scoring configured.