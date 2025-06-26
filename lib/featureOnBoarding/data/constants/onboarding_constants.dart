import '../../../core/constants/app_constants.dart';
import '../../domain/models/onboarding_page.dart';

/// Constants and static data for onboarding feature
class OnboardingConstants {
  static const List<OnboardingPage> pages = [
    OnboardingPage(
      image: 'assets/images/onboarding.png',
      title: 'Belajar Inggris dengan Gaya yang Baru!',
      description:
          'Belling hadir untuk bantu kamu memahami Bahasa Inggris dengan cara yang mudah, seru, dan menyenangkan.Yuk mulai perjalanan belajarmu hari ini!',
      backgroundColor: AppColors.primary,
    ),
    OnboardingPage(
      image: 'assets/images/home.png',
      title: 'Interaktif dan Nggak Bikin Bosan',
      description:
          'Latihan-latihan ringan, ilustrasi menarik, dan fitur interaktif bikin proses belajar terasa seperti bermain. Belajar jadi nggak terasa berat.',
      backgroundColor: AppColors.secondary,
    ),
    OnboardingPage(
      image: 'assets/images/onboarding.png',
      title: 'Disesuaikan dengan Kemampuanmu!',
      description:
          'Belling mengenali kemampuanmu dan menyesuaikan materi agar kamu bisa berkembang dengan kecepatan sendiri.Tiap orang beda cara belajarnya, Belling ngerti itu.',
      backgroundColor: AppColors.accent,
    ),
    OnboardingPage(
      image: 'assets/images/home.png',
      title: 'Ready to Begin?',
      description:
          'Join millions of learners worldwide and start your language learning adventure today!',
      backgroundColor: AppColors.success,
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
