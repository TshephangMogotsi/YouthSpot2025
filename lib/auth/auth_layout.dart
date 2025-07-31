import 'package:provider/provider.dart';
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
    return Consumer<AuthService>(
      builder: (context, auth, child) {
        return StreamBuilder(
          stream: auth.authStateChanges,
          builder: (context, snapshot) {
            Widget page;
            if (snapshot.connectionState == ConnectionState.waiting) {
              page = const AppLoadingPage();
            } else if (snapshot.hasData && snapshot.data?.user != null) {
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
