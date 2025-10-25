import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _onboardingKey = 'onboarding_cmplet';

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await Future.delayed(const Duration(seconds: 2));

    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }
}
