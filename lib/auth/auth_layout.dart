import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../app_loading_page.dart';
import '../navigation_layout.dart';
import '../services/onboarding_service.dart';
import '../screens/onboarding/onboarding_screen.dart';
import 'auth_switcher.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageifNotConnected,
  });

  final Widget? pageifNotConnected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: OnboardingService.hasSeenOnboarding(),
      builder: (context, onboardingSnapshot) {
        if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
          return const AppLoadingPage();
        }
        
        final hasSeenOnboarding = onboardingSnapshot.data ?? false;
        
        if (!hasSeenOnboarding) {
          return const OnboardingScreen();
        }
        
        return Consumer<AuthService>(
          builder: (context, auth, child) {
            return StreamBuilder<AuthState>(
              stream: auth.authStateChanges,
              builder: (context, snapshot) {
                Widget page;
                
                // Check connection state first
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If we're waiting for the stream but already have a current user, show the app
                  if (auth.currentUser != null) {
                    page = const AppNavigationLayout();
                  } else {
                    page = const AppLoadingPage();
                  }
                } else if (snapshot.hasData && snapshot.data?.session?.user != null) {
                  // User is authenticated via stream data
                  page = const AppNavigationLayout();
                } else if (auth.currentUser != null) {
                  // Fallback: check current user directly (for edge cases)
                  page = const AppNavigationLayout();
                } else {
                  // User is not authenticated
                  page = pageifNotConnected ?? const AuthSwitcher();
                }
                
                return page;
              },
            );
          },
        );
      },
    );
  }
}