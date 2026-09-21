import 'dart:io';

/// Write a line to the native VM console (stdout / stderr).
void consoleWriteLine(String line, {required bool isError}) {
  if (isError) {
    stderr.writeln(line);
  } else {
    stdout.writeln(line);
  }
}
