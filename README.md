# dartool

[![CI](https://github.com/maamagic/dartool/actions/workflows/ci.yml/badge.svg)](https://github.com/maamagic/dartool/actions)

> A Hutool-style toolkit for Flutter / Dart -- simple, unified and out-of-the-box.

Inspired by Java's [Hutool](https://hutool.cn/), `dartool` follows the philosophy of **modular, on-demand, one method for one problem**. The repository is managed with [melos](https://melos.invertase.dev/) and split into multiple sub-packages.

## Sub-packages

| Package | Positioning | pub |
|---|---|---|
| [dartool](packages/dartool) | Pure Dart core (String / Collection / Date / Regex / Enum / Validation / Conversion / ID, etc.) | [![pub](https://img.shields.io/pub/v/dartool.svg)](https://pub.dev/packages/dartool) |
| [dartool_flutter](packages/dartool_flutter) | Flutter-specific extensions (Platform detection / Logging / Widget helpers, etc.) | [![pub](https://img.shields.io/pub/v/dartool_flutter.svg)](https://pub.dev/packages/dartool_flutter) |

More extension packages (`dartool_http`, `dartool_crypto`, `dartool_cache`, `dartool_widget`, etc.) will be added on demand.

## Quick Start

### Pure Dart projects

```yaml
dependencies:
  dartool: ^0.1.0-dev.2
```

```dart
import 'package:dartool/dartool.dart';

print(StrUtil.isBlank('   '));            // true
print(StrUtil.toCamelCase('hello_world')); // helloWorld
print(IdUtil.uuid());                      // xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Flutter projects

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

## Local Development

Prerequisite: install [Flutter](https://flutter.dev) (ships with Dart 3.9+).

```bash
# Install melos
dart pub global activate melos

# Bootstrap the workspace (fetch all package dependencies)
melos bootstrap

# Static analysis
melos run analyze

# Run all tests
melos run test

# Pre-publish check (analyze + test + format)
melos run pre_publish
```

## Module Overview

### dartool (pure Dart core)

| Class | Description |
|---|---|
| `StrUtil` | String blank checks, case conversion, trimming, truncation, camel/snake conversion |
| `CollectionUtil` | Collection empty checks, dedup, pagination, flatten, grouping |
| `DateUtil` | Formatting, parsing, timestamp conversion, relative time, timezones |
| `RegexUtil` | Common regex patterns (phone, email, URL, ID card) and matchers |
| `EnumUtil` | Enum name/value resolution, iteration |
| `ValidateUtil` | Data validation (non-null, email, phone, ID card, range) |
| `ConvertUtil` | Type conversion (String <-> num <-> bool <-> DateTime) with fallbacks |
| `IdUtil` | UUID, snowflake ID, short unique ID generation |
| `Optional` | Null-safe value container (Java Optional style) |
| `Result` | Success / failure container with data or error |
| `ColorUtil` | Color conversion, luminance, interpolation (pure Dart) |
| `CryptoUtil` | Base64 / Hex encoding, MD5 / SHA / HMAC hashing, XOR obfuscation |

### dartool_flutter (Flutter extensions)

| Class | Description |
|---|---|
| `PlatformUtil` | Platform detection (Web-safe) |
| `LogUtil` | Leveled logging with swappable output |
| `WidgetUtil` | Common Flutter widget shorthands |

## Contributing

Issues and PRs are welcome. Follow [Conventional Commits](https://www.conventionalcommits.org/), respect the `lints` rules, and add tests for new features.

## License

[MIT](LICENSE)