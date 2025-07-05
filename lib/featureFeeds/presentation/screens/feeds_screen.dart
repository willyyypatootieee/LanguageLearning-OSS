import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../router/router_exports.dart';
import '../../../shared/widgets/global_navbar.dart';
import '../../../featurePractice/data/datasources/practice_local_datasource.dart';
import '../../../featurePractice/data/repositories/practice_repository_impl.dart';
import '../cubit/feeds_cubit.dart';
import '../widgets/feeds_widgets.dart';

/// Main feeds screen
class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  late FeedsCubit _feedsCubit;

  @override
  void initState() {
    super.initState();
    _feedsCubit = ServiceLocator.instance.feedsCubit;
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    await _feedsCubit.loadPosts();
  }

  @override
  void dispose() {
    // Don't dispose the cubit here since it's a singleton
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.gray200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Feeds',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTypography.headerFont,
                      color: AppColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _showCreatePostModal(context),
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            // Posts feed
            Expanded(
              child: AnimatedBuilder(
                animation: _feedsCubit,
                builder: (context, child) {
                  if (_feedsCubit.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_feedsCubit.errorMessage!),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      _feedsCubit.clearError();
                    });
                  }

                  if (_feedsCubit.isLoading && _feedsCubit.posts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (_feedsCubit.posts.isEmpty) {
                    return EmptyFeedsWidget(
                      onCreatePost: () => _showCreatePostModal(context),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => _feedsCubit.refreshPosts(),
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.spacingM),
                      itemCount: _feedsCubit.posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: _feedsCubit.posts[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
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
              appRouter.goToDictionary();
              break;
            case 3:
              _navigateToPractice();
              break;
            case 4:
              appRouter.goToLeaderboard();
              break;
            case 5:
              appRouter.goToProfile();
              break;
          }
        },
      ),
    );
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
      appRouter.goToPracticeOnboarding();
    }
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePostModal(feedsCubit: _feedsCubit),
    );
  }
}
