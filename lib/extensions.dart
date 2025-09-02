import 'dart:ui';

extension CustomOpacityAndShade on Color {
  /// Apply a custom opacity value (0.0–1.0).
  Color withCustomOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }

  /// Returns a lighter version of this color by moving closer to white.
  ///
  /// [amount] must be between 0.0 (no change) and 1.0 (full white).
  Color lighter([double amount = .1]) {
    assert(amount >= 0.0 && amount <= 1.0);

    final r =
        ((this.r * 255.0).round() + ((255 - (this.r * 255.0).round()) * amount))
            .round()
            .clamp(0, 255);
    final g =
        ((this.g * 255.0).round() + ((255 - (this.g * 255.0).round()) * amount))
            .round()
            .clamp(0, 255);
    final b =
        ((this.b * 255.0).round() + ((255 - (this.b * 255.0).round()) * amount))
            .round()
            .clamp(0, 255);

    return Color.fromARGB((a * 255.0).round().clamp(0, 255), r, g, b);
  }

  /// Returns a darker version of this color by moving closer to black.
  ///
  /// [amount] must be between 0.0 (no change) and 1.0 (full black).
  Color darker([double amount = .1]) {
    assert(amount >= 0.0 && amount <= 1.0);

    final r = ((this.r * 255.0).round() - ((this.r * 255.0).round() * amount))
        .round()
        .clamp(0, 255);
    final g = ((this.g * 255.0).round() - ((this.g * 255.0).round() * amount))
        .round()
        .clamp(0, 255);
    final b = ((this.b * 255.0).round() - ((this.b * 255.0).round() * amount))
        .round()
        .clamp(0, 255);

    return Color.fromARGB((a * 255.0).round().clamp(0, 255), r, g, b);
  }
}
