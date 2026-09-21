# Changelog

## 0.1.0-dev.2 - 2026-09-21

### Pub.dev scoring fixes

- Shortened `description` in pubspec.yaml and added `homepage` field.
- Converted README.md and CHANGELOG.md to pure English (no emoji / CJK).
- Added `example/main.dart` for both packages.
- Added dartdoc comments for `ConvertUtil` and `ValidateUtil` classes.
- Fixed incorrect API calls in examples and README (`CollectionUtil.distinct`,
  `Optional.getOrElse`).
- Added `ColorUtil` (color conversion / luminance / interpolation).
- Added `CryptoUtil` (Base64 / Hex / MD5 / SHA / HMAC / XOR).

## 0.1.0-dev.1 - 2026-09-21

### First release on pub.dev

- Added `repository` and `homepage` fields to pubspec.yaml.
- Added LICENSE, README.md and CHANGELOG.md for pub.dev publishing.
- Added dartdoc comments for `ConvertUtil` and `ValidateUtil` classes.

### Initial setup

- Melos monorepo workspace.
- Core modules: `StrUtil`, `CollectionUtil`, `DateUtil`, `RegexUtil`,
  `EnumUtil`, `ValidateUtil`, `ConvertUtil`, `IdUtil`, `Optional`, `Result`.
- Unit tests, GitHub Actions CI and pana scoring configured.