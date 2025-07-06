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

class _FeedsScreenState extends State<FeedsScreen>
    with AutomaticKeepAliveClientMixin {
  late FeedsCubit _feedsCubit;
  final ScrollController _scrollController = ScrollController();

  // Track if we've already shown an error message
  bool _hasShownError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _feedsCubit = ServiceLocator.instance.feedsCubit;

    // Load posts with a small delay to avoid janky animations during screen transitions
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _loadPosts();
        _loadFriendsData();
      }
    });
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
        builder: (context) => ChangeNotifierProvider.value(
          value: _feedsCubit,
          child: const FriendsManagementWidget(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Don't dispose the cubit here since it's a singleton
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          _buildUserSearchResults(),

          // Posts feed
          Expanded(
            child: _buildPostsFeed(),
          ),
        ],
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildUserSearchResults() {
    return AnimatedBuilder(
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
    );
  }

  Widget _buildPostsFeed() {
    return AnimatedBuilder(
      animation: _feedsCubit,
      builder: (context, child) {
        // Handle error messages
        if (_feedsCubit.errorMessage != null && !_hasShownError) {
          _hasShownError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
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
            }
          });
        } else if (_feedsCubit.errorMessage == null) {
          _hasShownError = false;
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
          onRefresh: _handleRefresh,
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: _buildOptimizedPostsList(),
        );
      },
    );
  }

  Widget _buildOptimizedPostsList() {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.spacingL),
      itemCount: _feedsCubit.posts.length,
      // Use cacheExtent to keep items in memory when scrolling
      cacheExtent: MediaQuery.of(context).size.height,
      itemBuilder: (context, index) {
        // Use RepaintBoundary to isolate painting for each item
        return RepaintBoundary(
          child: ChangeNotifierProvider.value(
            value: _feedsCubit,
            // Use a unique key for each post to ensure proper reuse
            child: PostCard(
              key: ValueKey(_feedsCubit.posts[index].id),
              post: _feedsCubit.posts[index],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    await _feedsCubit.refreshPosts();
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

  void _handleNavigation(int index) {
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
      builder: (context) => FeedsFilterModal(
        onFiltersApplied: (filters) {
          // Apply filters to the cubit
          _feedsCubit.applyFilters(filters);
        },
      ),
    );
  }
}
