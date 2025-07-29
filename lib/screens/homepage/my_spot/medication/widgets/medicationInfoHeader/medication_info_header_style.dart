import 'package:flutter/material.dart';

class MedicationInfoHeaderStyle
    extends ThemeExtension<MedicationInfoHeaderStyle> {
  const MedicationInfoHeaderStyle({
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
  });
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;

  @override
  ThemeExtension<MedicationInfoHeaderStyle> copyWith({
    Color? borderRadius,
    Color? pillBorderRadius,
    Color? iconColor,
  }) =>
      MedicationInfoHeaderStyle(
        backgroundColor: backgroundColor ?? backgroundColor,
        borderColor: borderColor ?? borderColor,
        iconColor: iconColor ?? iconColor,
      );

  @override
  ThemeExtension<MedicationInfoHeaderStyle> lerp(
      covariant ThemeExtension<MedicationInfoHeaderStyle>? other, double t) {
    if (other is! MedicationInfoHeaderStyle) {
      return this;
    }
    return MedicationInfoHeaderStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      iconColor:
          Color.lerp(iconColor, other.iconColor, t),
    );
  }
}
