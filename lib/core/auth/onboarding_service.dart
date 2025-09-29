class OnboardingService {
  Future<bool> hasCompletedOnboarding() async {

    await Future.delayed(const Duration(seconds: 2));

    return false; 
  }
}
