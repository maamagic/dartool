/// Minimal RFC 4180 CSV parser / encoder.
///
/// Handles quoted fields, escaped double-quotes, CRLF / LF / CR line endings.
class CsvUtil {
  CsvUtil._();

  /// Parse [input] into a list of rows.
  ///
  /// - [delimiter]: defaults to `,`
  /// - [quote]: defaults to `"`
  /// - [allowMalformed]: if true, unclosed quotes are tolerated
  static List<List<String>> parse(
    String input, {
    String delimiter = ',',
    String quote = '"',
    bool allowMalformed = false,
  }) {
    if (input.isEmpty) return const <List<String>>[];
    final rows = <List<String>>[];
    List<String> current = <String>[];
    final sb = StringBuffer();
    var inQuotes = false;
    var i = 0;
    final chars = input.codeUnits;
    final d = delimiter.codeUnitAt(0);
    final q = quote.codeUnitAt(0);

    void finishField() {
      current.add(sb.toString());
      sb.clear();
    }

    void finishRow() {
      finishField();
      rows.add(current);
      current = <String>[];
    }

    while (i < chars.length) {
      final c = chars[i];

      if (inQuotes) {
        if (c == q) {
          // escaped quote?
          if (i + 1 < chars.length && chars[i + 1] == q) {
            sb.writeCharCode(q);
            i += 2;
            continue;
          }
          inQuotes = false;
          i++;
          continue;
        }
        sb.writeCharCode(c);
        i++;
        continue;
      }

      if (c == q) {
        inQuotes = true;
        i++;
        continue;
      }
      if (c == d) {
        finishField();
        i++;
        continue;
      }
      if (c == 0x0D) {
        // CR
        if (i + 1 < chars.length && chars[i + 1] == 0x0A) {
          i += 2;
        } else {
          i++;
        }
        finishRow();
        continue;
      }
      if (c == 0x0A) {
        i++;
        finishRow();
        continue;
      }
      sb.writeCharCode(c);
      i++;
    }

    if (inQuotes && !allowMalformed) {
      throw FormatException('Unclosed quote at end of input');
    }
    // trailing data
    if (sb.isNotEmpty || current.isNotEmpty || rows.isEmpty) {
      finishRow();
      if (rows.isNotEmpty &&
          rows.last.every((s) => s.isEmpty) &&
          rows.length > 1) {
        rows.removeLast();
      }
    }

    return rows;
  }

  /// Encode [rows] into a CSV string. Uses CRLF line endings per RFC 4180.
  static String encode(
    List<List<String>> rows, {
    String delimiter = ',',
    String quote = '"',
  }) {
    final sb = StringBuffer();
    for (var r = 0; r < rows.length; r++) {
      final row = rows[r];
      for (var c = 0; c < row.length; c++) {
        if (c > 0) sb.write(delimiter);
        sb.write(_escapeField(row[c], delimiter, quote));
      }
      if (r < rows.length - 1) sb.write('\r\n');
    }
    return sb.toString();
  }

  static String _escapeField(String field, String delimiter, String quote) {
    final needsQuote =
        field.contains(delimiter) ||
        field.contains(quote) ||
        field.contains('\n') ||
        field.contains('\r');
    if (!needsQuote) return field;
    final escaped = field.replaceAll(quote, '$quote$quote');
    return '$quote$escaped$quote';
  }
}
