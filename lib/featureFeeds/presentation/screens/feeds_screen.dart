import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../router/router_exports.dart';
import '../../../shared/widgets/global_navbar.dart';
import '../../../featurePractice/data/datasources/practice_local_datasource.dart';
import '../../../featurePractice/data/repositories/practice_repository_impl.dart';
import '../cubit/feeds_cubit.dart';
import '../widgets/feeds_widgets.dart';
import '../widgets/components/friends_management_widget.dart';

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
    _loadFriendsData();
  }

  Future<void> _loadPosts() async {
    await _feedsCubit.loadPosts();
  }

  Future<void> _loadFriendsData() async {
    await _feedsCubit.loadFriends();
    await _feedsCubit.loadPendingRequests();
  }

  void _openFriendsManagement() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ChangeNotifierProvider.value(
              value: _feedsCubit,
              child: const FriendsManagementWidget(),
            ),
      ),
    );
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
      body: Column(
        children: [
          // Fancy gamified header
          FeedsHeader(
            onCreatePost: () => _showCreatePostModal(context),
            onOpenFriends: _openFriendsManagement,
          ),
          // Search bar
          FeedsSearchBar(
            onSearchChanged: (query) {
              _feedsCubit.searchPosts(query);
            },
            onUserSearch: (query) {
              _feedsCubit.searchUsers(query);
            },
            onFilterTap: () => _showFilterModal(context),
          ),
          // User search results
          AnimatedBuilder(
            animation: _feedsCubit,
            builder: (context, child) {
              if (_feedsCubit.userSearchResults.isNotEmpty ||
                  _feedsCubit.isSearchingUsers) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
                  child: UserSearchResults(
                    users: _feedsCubit.userSearchResults,
                    feedsCubit: _feedsCubit,
                    isLoading: _feedsCubit.isSearchingUsers,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
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
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    _feedsCubit.clearError();
                  });
                }

                if (_feedsCubit.isLoading && _feedsCubit.posts.isEmpty) {
                  return const GameLoadingWidget();
                }

                if (_feedsCubit.posts.isEmpty) {
                  return EmptyFeedsWidget(
                    onCreatePost: () => _showCreatePostModal(context),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _feedsCubit.refreshPosts(),
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    itemCount: _feedsCubit.posts.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: _feedsCubit,
                        child: PostCard(post: _feedsCubit.posts[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
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

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => FeedsFilterModal(
            onFiltersApplied: (filters) {
              // Apply filters to the cubit
              _feedsCubit.applyFilters(filters);
            },
          ),
    );
  }
}
