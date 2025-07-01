import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Constants for the Practice feature
class PracticeConstants {
  // Animation durations
  static const Duration cardAnimationDelay = Duration(milliseconds: 100);
  static const Duration staggerAnimationDelay = Duration(milliseconds: 50);

  // Practice modes
  static const List<PracticeMode> practiceModes = [
    PracticeMode(
      title: 'Ngobrol Sama Beruang AI 😎',
      subtitle: 'Beruang-nya sopan & ngerti kamu',
      icon: Icons.chat_bubble_outline,
      color: AppColors.primary,
      isLarge: true,
    ),
    PracticeMode(
      title: 'Latihan Ngomong Biar Lidah Nggak Nyelip',
      subtitle: 'Aksen kamu auto-native (amin)',
      icon: Icons.record_voice_over,
      color: AppColors.primary,
      isLarge: false,
    ),
    PracticeMode(
      title: 'Ngobrol Cepat-Cepat Tapi Nempel',
      subtitle: '5 menit aja, tapi dapet banyak',
      icon: Icons.timer,
      color: AppColors.success,
      isLarge: false,
    ),
    PracticeMode(
      title: 'Main Peran Tapi Nggak Cringe',
      subtitle: 'Latihan situasi nyata (kayak interview, date, dll)',
      icon: Icons.theater_comedy,
      color: AppColors.warning,
      isLarge: false,
    ),
    PracticeMode(
      title: 'Dengerin Dulu, Ngomong Belakangan',
      subtitle: 'Biar kamu nggak cuma “hmm iya-iya” doang',
      icon: Icons.hearing,
      color: AppColors.secondary,
      isLarge: false,
    ),
    PracticeMode(
      title: 'Grammar Biar Nggak Malu-Maluin 💀',
      subtitle: 'Latihan terstruktur, nggak bikin kepala ngebul',
      icon: Icons.school,
      color: AppColors.error,
      isLarge: false,
    ),
  ];

  // Practice onboarding
  static const List<PracticeOnboardingPage> onboardingPages = [
    PracticeOnboardingPage(
      title: 'Kenalan Sama Temen Ngobrol Lo 🐻',
      subtitle:
          'Beruang AI yang nggak nge-judge, cuma mau bantu lo jago ngomong',
      description:
          'Lo bisa ngobrol bebas, salah? santuy, langsung dibenerin sama dia. Vibenya aman, friendly, dan supportive.',
      primaryColor: AppColors.primary,
    ),
    PracticeOnboardingPage(
      title: 'Belajar Tapi Kayak Diatur Semesta 🌌',
      subtitle: 'Ngikutin skill lo, bukan maksa',
      description:
          'AI-nya peka, tau lo udah sejauh apa, jadi dikasih tantangan yang pas. Kayak temen yang ngerti “lo tuh bisa asal jangan males.”',
      primaryColor: AppColors.accent,
    ),
    PracticeOnboardingPage(
      title: 'Yuk Gas Sekarang 💥',
      subtitle: 'Pilih mode latihan, terus langsung tancap gas',
      description:
          'Fluency itu perjalanan, bukan lomba. Tapi makin cepet mulai, makin cepet bisa nonton film tanpa subtitle.',
      primaryColor: AppColors.success,
    ),
  ];
}

/// Practice mode data model
class PracticeMode {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isLarge;

  const PracticeMode({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isLarge,
  });
}

/// Practice onboarding page data model
class PracticeOnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final String? animationAsset;
  final Color primaryColor;

  const PracticeOnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    this.animationAsset,
    required this.primaryColor,
  });
}
