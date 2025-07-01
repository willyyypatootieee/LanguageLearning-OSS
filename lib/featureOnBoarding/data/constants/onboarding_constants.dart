import '../../../core/constants/app_constants.dart';
import '../../domain/models/onboarding_page.dart';

/// Constants and static data for onboarding feature
class OnboardingConstants {
  static const List<OnboardingPage> pages = [
    OnboardingPage(
      image: 'assets/images/onboarding/onboarding3.png',
      title: 'SKRRRT 🚗💨 Belajar English Tapi Kok Seru Ya?!',
      description:
          'Kamu kira belajar harus nangis darah? 🧍‍♂️Belling dateng bawa vibes chill, tinggal buka app... tiba-tiba TOEFL kamu 999+ (who knows) 📈📚🔥',
      backgroundColor: AppColors.primary,
    ),
    OnboardingPage(
      image: 'assets/images/onboarding/onboarding2.png',
      title: 'Anti Zzz... 100% Seru Tanpa Efek Ganja Narkoba!',
      description:
          'Latihan kayak mini games, ilustrasi lucu, fitur interaktif... belajar rasa rebahan. Ini bukan app, HIDUP JOKOWI ✨🧘‍♀️',
      backgroundColor: AppColors.primary,
    ),
    OnboardingPage(
      image: 'assets/images/onboarding/onboarding.png',
      title: 'JAWA JAWA JAWA JAWA JAWA JAWA JAWA JAWA',
      description:
          'Belling: “aku tau kamu capek, jadi aku atur materi biar masuknya kayak air wudhu” 🤲✨ Gaya belajar kamu? Diakuin. Dimanjain. Dihalalin.',
      backgroundColor: AppColors.primary,
    ),
  ];

  // Animation durations
  static const Duration pageTransitionDuration = AppConstants.animationNormal;
  static const Duration indicatorAnimationDuration =
      AppConstants.animationNormal;

  // UI Constants
  static const double horizontalPadding = AppConstants.spacingL;
  static const double verticalSpacing = AppConstants.spacingXl;
  static const double buttonHeight = 48.0;
  static const double borderRadius = AppConstants.radiusM;
}
