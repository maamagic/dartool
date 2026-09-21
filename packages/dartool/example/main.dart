import 'package:dartool/dartool.dart';

void main() {
  // String utilities
  print('StrUtil.isBlank("   ") = ${StrUtil.isBlank('   ')}');
  print(
    'StrUtil.toCamelCase("hello_world") = ${StrUtil.toCamelCase('hello_world')}',
  );
  print(
    'StrUtil.toSnakeCase("helloWorld") = ${StrUtil.toSnakeCase('helloWorld')}',
  );

  // Collection utilities
  print('CollectionUtil.isEmpty([]) = ${CollectionUtil.isEmpty(<int>[])}');
  print('[3, 1, 2].distinct() = ${[3, 1, 2, 1].distinct()}');

  // Date utilities
  print('DateUtil.formatNow() = ${DateUtil.formatNow()}');

  // Validation utilities
  print('ValidateUtil.isEmail("a@b.com") = ${ValidateUtil.isEmail('a@b.com')}');
  print(
    'ValidateUtil.isPhone("13800138000") = ${ValidateUtil.isPhone('13800138000')}',
  );

  // Convert utilities
  print('ConvertUtil.toInt("42") = ${ConvertUtil.toInt('42')}');
  print('ConvertUtil.toBool("yes") = ${ConvertUtil.toBool('yes')}');

  // ID generation
  print('IdUtil.uuid() = ${IdUtil.uuid()}');

  // Optional
  final op = Optional.of('hello');
  print('Optional.of("hello").orElse("default") = ${op.orElse('default')}');

  // Result
  final r = Result.success('ok');
  print('Result.success("ok").isSuccess = ${r.isSuccess}');
}
