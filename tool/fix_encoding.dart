import 'dart:convert';
import 'dart:io';

void main() {
  final roots = [
    Directory('packages/dartool/lib'),
    Directory('packages/dartool_flutter/lib'),
    Directory('packages/dartool/test'),
    Directory('packages/dartool_flutter/test'),
  ];

  final replace = <String, String>{
    '\u2192': '->',
    '\u2014': '--',
    '\u2018': "'",
    '\u2019': "'",
    '\u201c': '"',
    '\u201d': '"',
    '\u00A0': ' ',
    '\uFEFF': '',
    '\uFFFD': '',
    '\u9519': ' ',
  };

  var changed = 0;
  for (final root in roots) {
    if (!root.existsSync()) continue;
    for (final f in root.listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final bytes = f.readAsBytesSync();
      var content = String.fromCharCodes(bytes);
      final orig = content;
      for (final e in replace.entries) {
        content = content.replaceAll(e.key, e.value);
      }
      content = content.replaceAllMapped(RegExp(r'[^\x00-\x7F]'), (m) => '');
      if (content != orig) {
        f.writeAsStringSync(content, encoding: utf8);
        print('FIXED ${f.path}');
        changed++;
      }
    }
  }
  print('Total files changed: $changed');
}
