import 'package:flutter/material.dart';

class MedicineTileStyle extends ThemeExtension<MedicineTileStyle> {
  const MedicineTileStyle({
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  @override
  ThemeExtension<MedicineTileStyle> copyWith({
    Color? borderRadius,
    Color? textColor,
    Color? iconColor,
  }) =>
      MedicineTileStyle(
        backgroundColor: backgroundColor ?? backgroundColor,
        textColor: textColor ?? textColor,
        iconColor: iconColor ?? iconColor,
      );

  @override
  ThemeExtension<MedicineTileStyle> lerp(
      covariant ThemeExtension<MedicineTileStyle>? other, double t) {
    if (other is! MedicineTileStyle) {
      return this;
    }
    return MedicineTileStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}
