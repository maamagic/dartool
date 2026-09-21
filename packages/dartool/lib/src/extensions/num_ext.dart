import '../num_util.dart';

/// Extension APIs mirroring [NumUtil].
extension DartoolNum on num {
  num clamp(num min, num max) => NumUtil.clamp<num>(this, min, max);
  double roundNum({int decimal = 0}) => NumUtil.round(this, decimal: decimal);
  double floorNum({int decimal = 0}) => NumUtil.floor(this, decimal: decimal);
  double ceilNum({int decimal = 0}) => NumUtil.ceil(this, decimal: decimal);
  double mapRange(num inMin, num inMax, num outMin, num outMax) =>
      NumUtil.mapRange(
        toDouble(),
        inMin.toDouble(),
        inMax.toDouble(),
        outMin.toDouble(),
        outMax.toDouble(),
      );
  String formatThousand({int fractionalDigits = 0}) =>
      NumUtil.formatThousand(this, fractionalDigits: fractionalDigits);
}

extension DartoolInt on int {
  String formatBytes({int decimals = 1}) =>
      NumUtil.formatBytes(this, decimals: decimals);
}
