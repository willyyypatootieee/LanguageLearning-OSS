import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/ipa_button.dart';
import '../../../shared/shared_exports.dart';
import '../../../router/router_exports.dart';
import '../../../featurePractice/data/datasources/practice_local_datasource.dart';
import '../../../featurePractice/data/repositories/practice_repository_impl.dart';

// IPA Vowels (matching screenshot)
final List<Map<String, String>> vowelIPA = [
  {'symbol': 'i', 'label': 'minim', 'example': 'sheep'},
  {'symbol': 'ɪ', 'label': 'tipis', 'example': 'ship'},
  {'symbol': 'e', 'label': 'es', 'example': 'bed'},
  {'symbol': 'æ', 'label': 'emas', 'example': 'cat'},
  {'symbol': 'ʌ', 'label': 'abang', 'example': 'cup'},
  {'symbol': 'ɑ', 'label': 'ayah', 'example': 'car'},
  {'symbol': 'ɒ', 'label': 'obat', 'example': 'hot'},
  {'symbol': 'ɔ', 'label': 'obrol', 'example': 'law'},
  {'symbol': 'ʊ', 'label': 'ular', 'example': 'put'},
  {'symbol': 'u', 'label': 'urut', 'example': 'boot'},
  {'symbol': 'ə', 'label': 'sebentar', 'example': 'about'},
];

// IPA Consonants (matching screenshot)
final List<Map<String, String>> consonantIPA = [
  {'symbol': 'p', 'label': 'pintu', 'example': 'pen'},
  {'symbol': 'b', 'label': 'bola', 'example': 'bat'},
  {'symbol': 't', 'label': 'topi', 'example': 'ten'},
  {'symbol': 'd', 'label': 'dompet', 'example': 'dog'},
  {'symbol': 'k', 'label': 'kaki', 'example': 'cat'},
  {'symbol': 'g', 'label': 'gigi', 'example': 'go'},
  {'symbol': 'f', 'label': 'fokus', 'example': 'fish'},
  {'symbol': 'v', 'label': 'vas', 'example': 'van'},
  {'symbol': 's', 'label': 'sapi', 'example': 'sun'},
  {'symbol': 'z', 'label': 'zebra', 'example': 'zoo'},
  {'symbol': 'm', 'label': 'mata', 'example': 'man'},
  {'symbol': 'n', 'label': 'nasi', 'example': 'net'},
];

class IPAChartScreen extends StatefulWidget {
  const IPAChartScreen({super.key});

  @override
  State<IPAChartScreen> createState() => _IPAChartScreenState();
}

class _IPAChartScreenState extends State<IPAChartScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    // Start the entrance animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _navigateToPractice() async {
    try {
      final repository = PracticeRepositoryImpl(PracticeLocalDataSource());
      final hasCompletedOnboarding =
          await repository.isPracticeOnboardingCompleted();

      if (hasCompletedOnboarding) {
        appRouter.goToPractice();
      } else {
        appRouter.goToPracticeOnboarding();
      }
    } catch (e) {
      // If there's an error, go to onboarding
      appRouter.goToPracticeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0), Color(0xFFF1F5F9)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'IPA Sound Chart',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.gray800,
                              ),
                        ),
                      ),
                      // Add sound toggle button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.volume_up,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Pilih Simbol untuk mendengar pengucapan',
                                    ),
                                  ],
                                ),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 120,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildSectionHeader(
                          'Vowels',
                          Icons.record_voice_over,
                          AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildBentoGrid(vowelIPA, 'vowels'),
                        const SizedBox(height: 40),
                        _buildSectionHeader(
                          'Consonants',
                          Icons.hearing,
                          AppColors.accent,
                        ),
                        const SizedBox(height: 16),
                        _buildBentoGrid(consonantIPA, 'consonants'),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              appRouter.goToHome();
              break;
            case 2:
              _navigateToPractice();
              break;
            case 3:
              appRouter.goToLeaderboard();
              break;
            case 4:
              appRouter.goToProfile();
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(List<Map<String, String>> ipaList, String type) {
    // Create a bento box layout with varying sizes
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildResponsiveGrid(ipaList, constraints.maxWidth);
        },
      ),
    );
  }

  Widget _buildResponsiveGrid(
    List<Map<String, String>> ipaList,
    double maxWidth,
  ) {
    // Calculate how many columns can fit
    const buttonWidth = 110.0; // Medium button width
    const spacing = 8.0;
    int crossAxisCount = ((maxWidth - 16) / (buttonWidth + spacing))
        .floor()
        .clamp(3, 4); // Fixed at 4 columns

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85, // Adjust to fit button content
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: ipaList.length,
      itemBuilder: (context, i) {
        final ipa = ipaList[i];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (i * 50)),
          child: IPASymbolButton(
            symbol: ipa['symbol']!,
            label: ipa['label']!,
            example: ipa['example']!,
            size: IPAButtonSize.medium,
            index: i,
          ),
        );
      },
    );
  }
}
