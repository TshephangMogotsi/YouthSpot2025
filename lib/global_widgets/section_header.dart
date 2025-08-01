import 'package:flutter/material.dart';

import '../config/font_constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Text(
          title,
          // style: TextStyle(
          //   color: theme == ThemeMode.dark ? Colors.white : Colors.black,
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          // ),
             style: AppTextStyles.title
        );
      },
    );
  }
}
