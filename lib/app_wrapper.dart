import 'package:flutter/material.dart';
import 'package:youthspot/services/onboarding_service.dart';
import 'package:youthspot/screens/onboarding/onboarding_screen.dart';
import 'package:youthspot/auth/auth_layout.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool? _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();
    setState(() {
      _hasSeenOnboarding = hasSeenOnboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking onboarding status
    if (_hasSeenOnboarding == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show onboarding if user hasn't seen it
    if (!_hasSeenOnboarding!) {
      return const OnboardingScreen();
    }

    // Show normal auth flow if user has seen onboarding
    return const AuthLayout();
  }
}