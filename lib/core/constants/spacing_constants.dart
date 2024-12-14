class Spacing {
  // Base spacing unit
  static const double base = 8.0;

  // Multiples of base
  static const double xs = base / 2; // 4.0
  static const double sm = base; // 8.0
  static const double md = base * 2; // 16.0
  static const double lg = base * 3; // 24.0
  static const double xl = base * 4; // 32.0
  static const double xxl = base * 6; // 48.0

  // Common paddings
  static const double screenPadding = md;
  static const double cardPadding = md;
  static const double buttonPadding = sm;

  // Common margins
  static const double verticalSpacing = md;
  static const double horizontalSpacing = md;

  // Border radiuses
  static const double borderRadiusSm = sm;
  static const double borderRadiusMd = md;
  static const double borderRadiusLg = lg;
}
