/// Write a line on the web, where `dart:io` is unavailable. `print` is routed
/// to the browser console.
void consoleWriteLine(String line, {required bool isError}) {
  // ignore: avoid_print
  print(line);
}
