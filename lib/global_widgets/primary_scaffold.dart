import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import 'custom_app_bar.dart';

class PrimaryScaffold extends StatelessWidget {
  const PrimaryScaffold({
    super.key,
    required this.child,
    this.isHomePage = false,
  });

  final Widget child;
  final bool isHomePage;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Scaffold(
          
          backgroundColor: theme == ThemeMode.dark
              ? const Color(0xFF0A0A0A) 
              : backgroundColorLight,
          appBar: PreferredSize(
            
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(
              context: context,
              isHomePage: isHomePage,
          
            ),
          ),
          body: child,
        );
      },
    );
  }
}
