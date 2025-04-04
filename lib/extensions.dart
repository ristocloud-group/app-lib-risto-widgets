import 'dart:ui';

extension CustomOpacity on Color {
  Color withCustomOpacity(double opacity) {
    return withValues(
      red: r.toDouble(),
      green: g.toDouble(),
      blue: b.toDouble(),
      alpha: (opacity * 255).roundToDouble(),
    );
  }
}
