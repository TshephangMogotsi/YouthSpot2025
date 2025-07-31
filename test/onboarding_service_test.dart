import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youthspot/services/onboarding_service.dart';

void main() {
  group('OnboardingService', () {
    setUp(() async {
      // Set up mock shared preferences
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('hasSeenOnboarding returns false initially', (WidgetTester tester) async {
      final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();
      expect(hasSeenOnboarding, false);
    });

    testWidgets('setOnboardingSeen sets the flag to true', (WidgetTester tester) async {
      // Initially should be false
      expect(await OnboardingService.hasSeenOnboarding(), false);
      
      // Set onboarding as seen
      await OnboardingService.setOnboardingSeen();
      
      // Should now be true
      expect(await OnboardingService.hasSeenOnboarding(), true);
    });

    testWidgets('resetOnboarding resets the flag to false', (WidgetTester tester) async {
      // Set onboarding as seen
      await OnboardingService.setOnboardingSeen();
      expect(await OnboardingService.hasSeenOnboarding(), true);
      
      // Reset onboarding
      await OnboardingService.resetOnboarding();
      
      // Should now be false again
      expect(await OnboardingService.hasSeenOnboarding(), false);
    });
  });
}