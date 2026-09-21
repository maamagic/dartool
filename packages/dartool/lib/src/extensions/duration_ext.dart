/// Compact duration formatting helpers.
extension DartoolDuration on Duration {
  /// Format as compact human-readable like `2h30m` or `15s`.
  ///
  /// [dropZeroLeading] omits leading zero components (e.g. `0h5m` → `5m`).
  String formatCompact({bool dropZeroLeading = true}) {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final parts = <String>[];
    if (hours != 0 || !dropZeroLeading) parts.add('${hours}h');
    if (minutes != 0 || !dropZeroLeading) parts.add('${minutes}m');
    if (seconds != 0 || parts.isEmpty) parts.add('${seconds}s');
    return parts.join();
  }

  /// Format as `HH:mm:ss` or `mm:ss`.
  String formatClock() {
    final h = inHours;
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h == 0) return '$m:$s';
    final hh = h.toString().padLeft(2, '0');
    return '$hh:$m:$s';
  }
}
