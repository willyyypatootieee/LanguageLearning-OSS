import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../../../shared/widgets/global_navbar.dart';
import '../../data/constants/practice_constants.dart';
import '../../data/datasources/practice_local_datasource.dart';
import '../../data/repositories/practice_repository_impl.dart';
import '../../domain/repositories/practice_repository.dart';
import '../widgets/practice_widgets.dart';

/// Main practice screen with bento box design
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  late final PracticeRepository _repository;
  late AnimationController _animationController;
  late AnimationController _staggerController;

  int _practiceStreak = 0;
  int _totalPracticeTime = 0;

  @override
  void initState() {
    super.initState();
    _repository = PracticeRepositoryImpl(PracticeLocalDataSource());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _loadPracticeData();
    _startAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _loadPracticeData() async {
    final streak = await _repository.getPracticeStreak();
    final totalTime = await _repository.getTotalPracticeTime();

    setState(() {
      _practiceStreak = streak;
      _totalPracticeTime = totalTime;
    });
  }

  void _startAnimations() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _staggerController.forward();
    });
  }

  void _onNavTap(int index) {
    if (index == 2) return; // Already on practice

    switch (index) {
      case 0:
        appRouter.goToHome();
        break;
      case 1:
        appRouter.goToDictionary();
        break;
      case 2:
        // Already on practice
        break;
      case 3:
        appRouter.goToLeaderboard();
        break;
      case 4:
        appRouter.goToProfile();
        break;
    }
  }

  void _onPracticeModeSelected(PracticeMode mode) {
    // Handle practice mode selection
    if (mode.title.contains('Ngobrol Sama Beruang AI')) {
      _showConversationPracticeDialog();
    } else {
      _showComingSoonDialog(mode.title);
    }
  }

  void _showConversationPracticeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            title: Row(
              children: [
                Icon(Icons.smart_toy, color: AppColors.primary),
                const SizedBox(width: AppConstants.spacingS),
                const Text('BellingPractice'),
              ],
            ),
            content: const Text(
              'Mau mulai ngobrol sama beruang AI yang supportive? Lo bisa ngobrol natural dan dapet feedback langsung!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nanti Aja'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToVideoCall();
                },
                child: Text(
                  'Check Preview',
                  style: TextStyle(color: AppColors.accent),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToVideoCall();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Mulai Ngobrol!'),
              ),
            ],
          ),
    );
  }

  void _navigateToVideoCall() {
    appRouter.push('/practice/video-call');
  }

  void _showComingSoonDialog(String featureName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            title: const Text('Coming Soon!'),
            content: Text(
              '$featureName will be available in a future update. Stay tuned!',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            FadeTransition(
              opacity: _animationController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: PracticeHeader(
                  practiceStreak: _practiceStreak,
                  totalPracticeTime: _totalPracticeTime,
                ),
              ),
            ),

            // Bento Box Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: PracticeBentoGrid(
                  animationController: _staggerController,
                  onModeSelected: _onPracticeModeSelected,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MainNavbar(
        currentIndex: 2, // Practice tab
        onTap: _onNavTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
