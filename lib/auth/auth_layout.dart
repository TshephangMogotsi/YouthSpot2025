import 'package:youthspot/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../app_loading_page.dart';
import '../navigation_layout.dart';
import 'auth_switcher.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageifNotConnected,
  });

  final Widget? pageifNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget page;
            if (snapshot.connectionState == ConnectionState.waiting) {
              page = const AppLoadingPage();
            } else if (snapshot.hasData) {
              page = const AppNavigationLayout();
            } else {
              page = pageifNotConnected ?? const AuthSwitcher();
            }
            return page;
          },
        );
      },
    );
  }
}
