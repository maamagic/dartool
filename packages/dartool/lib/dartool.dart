/// dartool —— 面向 Dart / Flutter 的 Hutool 风格工具库（纯 Dart 核心）。
///
/// 本库零 Flutter 依赖，纯 Dart 项目也可直接使用。
/// 用法：
/// ```dart
/// import 'package:dartool/dartool.dart';
///
/// print(StrUtil.isBlank('   '));        // true
/// print(IdUtil.uuid());                 // 随机 UUID
/// ```
library;

export 'src/collection_util.dart';
export 'src/convert_util.dart';
export 'src/date_util.dart';
export 'src/enum_util.dart';
export 'src/id_util.dart';
export 'src/optional.dart';
export 'src/regex_util.dart';
export 'src/result.dart';
export 'src/str_util.dart';
export 'src/validate_util.dart';
