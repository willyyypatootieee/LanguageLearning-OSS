import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/leaderboard_cubit.dart';
import '../../domain/models/leaderboard_user.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/shared_exports.dart';

class LeaderboardScreen extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavTap;
  const LeaderboardScreen({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeaderboardLoaded) {
            final users = state.users;
            if (users.isEmpty) {
              return const Center(child: Text('No leaderboard data.'));
            }
            // Top 3 users
            final top3 = users.take(3).toList();
            // Remaining users
            final rest = users.skip(3).toList();
            // Helper to get rank type
            String getRankType(int pts) {
              if (pts == 0) return 'Unranked';
              if (pts > 85) return 'Wood+';
              if (pts > 60) return 'Wood';
              return 'Wood';
            }

            // Group users by rank type
            final Map<String, List<LeaderboardUser>> grouped = {
              'Unranked': [],
              'Wood+': [],
              'Wood': [],
            };
            for (final user in rest) {
              final type = getRankType(user.scoreEnglish);
              grouped[type]?.add(user);
            }
            // Find current user (by id or username)
            String currentUser = 'You'; // Replace with actual logic if needed
            return Column(
              children: [
                const SizedBox(height: AppConstants.spacingL),
                // Top 3 display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (i) {
                    final user = i < top3.length ? top3[i] : null;
                    return user == null
                        ? const SizedBox(width: 80)
                        : Column(
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                CircleAvatar(
                                  radius: i == 1 ? 36 : 28,
                                  backgroundColor:
                                      i == 1
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                  child: Text(
                                    user.username[0],
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (i == 0)
                                  Positioned(
                                    top: -10,
                                    child: Icon(
                                      Icons.emoji_events,
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                  ),
                                if (i == 1)
                                  Positioned(
                                    top: -10,
                                    child: Icon(
                                      Icons.emoji_events,
                                      color: AppColors.secondary,
                                      size: 28,
                                    ),
                                  ),
                                if (i == 2)
                                  Positioned(
                                    top: -10,
                                    child: Icon(
                                      Icons.emoji_events,
                                      color: AppColors.accent,
                                      size: 28,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spacingS),
                            SizedBox(
                              width: 80,
                              child: Text(
                                user.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              '${user.scoreEnglish} pts',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        );
                  }),
                ),
                const SizedBox(height: AppConstants.spacingL),
                // List of users (4th and below)
                Expanded(
                  child: ListView(
                    children: [
                      for (final rankType in ['Wood+', 'Wood', 'Unranked']) ...[
                        if (grouped[rankType]!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingS,
                              horizontal: AppConstants.spacingM,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color:
                                        rankType == 'Unranked'
                                            ? AppColors.gray400
                                            : (rankType == 'Wood+'
                                                ? AppColors.primary
                                                : AppColors.secondary),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  rankType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ...grouped[rankType]!.map((user) {
                          final isYou = user.username == currentUser;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingM,
                              vertical: AppConstants.spacingXs,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isYou
                                      ? AppColors
                                          .success // solid green fill
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusM,
                              ),
                              border:
                                  isYou
                                      ? Border.all(
                                        color: AppColors.success,
                                        width: 2,
                                      )
                                      : null,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gray200.withOpacity(0.5),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.gray200,
                                child: Text(user.username[0]),
                              ),
                              title: Text(
                                user.username,
                                style: TextStyle(
                                  fontWeight:
                                      isYou
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color: isYou ? AppColors.success : null,
                                ),
                              ),
                              subtitle: Text('Rank: ${user.currentRank}'),
                              trailing: Text('${user.scoreEnglish} pts'),
                              tileColor: Colors.transparent,
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            );
          } else if (state is LeaderboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}
