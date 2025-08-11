import 'package:flutter/material.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

class PrimaryContainer extends StatelessWidget {
  const PrimaryContainer({
    super.key,
    this.onTap,
    required this.child,
    this.activeBorder,
    this.span = true,
    this.bgColor,
    this.hasShadow = false,
    this.borderRadius,
    this.padding,
    this.borderColor,
  });

  final Widget child;
  final void Function()? onTap;
  final Border? activeBorder;
  final bool? span;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool hasShadow;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: span == true ? double.infinity : null,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              boxShadow: hasShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
              color: bgColor ??
                  (theme == ThemeMode.dark
                      ? const Color(0xFF23232B)
                      : Colors.white),
              borderRadius: borderRadius ?? BorderRadius.circular(34.0),
              border: activeBorder ??
                  (theme == ThemeMode.dark
                      ? Border.all(
                          color: Colors.transparent,
                          width: 0.8,
                        )
                      : Border.all(
                          color: Colors.grey[300]!.withValues(alpha: 0.4),
                          width: 0.5,
                        )),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
