import 'package:youthspot/config/constants.dart';
import 'package:flutter/material.dart';

import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';

class PrimaryDivider extends StatelessWidget {
  const PrimaryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Divider(
          color: theme == ThemeMode.dark
              ? Colors.white.withValues(alpha: 0.3)
              : properBlack.withValues(alpha: 0.9),
          //  thickness: 1,
          height: 1.5,
          thickness: .8,
        );
      },
    );
  }
}
