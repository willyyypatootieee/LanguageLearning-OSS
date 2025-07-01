import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/leaderboard_cubit.dart';
import '../../domain/models/leaderboard_user.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/shared_exports.dart';
import '../../../router/router_exports.dart';

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
      extendBody: true,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFE3E9F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(
            0.5,
          ), // Semi-transparent white overlay
          child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
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
                String currentUser =
                    'You'; // Replace with actual logic if needed
                return Column(
                  children: [
                    const SizedBox(height: AppConstants.spacingL),
                    // Top 3 display (improved, with card and animation)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.white.withOpacity(0.95),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 8.0,
                          ),
                          child: Stack(
                            children: [
                              // Placeholder for confetti effect (replace with real widget if available)
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: Opacity(
                                    opacity: 0.18,
                                    child: Icon(
                                      Icons.celebration,
                                      size: 120,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(3, (i) {
                                  final user = i < top3.length ? top3[i] : null;
                                  final isFirst = i == 0;
                                  final isSecond = i == 1;
                                  Color medalColor;
                                  if (isFirst) {
                                    medalColor = const Color(
                                      0xFFFFD700,
                                    ); // Gold
                                  } else if (isSecond) {
                                    medalColor = const Color(
                                      0xFFC0C0C0,
                                    ); // Silver
                                  } else {
                                    medalColor = const Color(
                                      0xFFCD7F32,
                                    ); // Bronze
                                  }
                                  return user == null
                                      ? const SizedBox(width: 80)
                                      : AnimatedScale(
                                        scale: 1.0,
                                        duration: Duration(
                                          milliseconds: 400 + i * 100,
                                        ),
                                        curve: Curves.easeOutBack,
                                        child: Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: medalColor
                                                            .withOpacity(0.4),
                                                        blurRadius: 16,
                                                        offset: const Offset(
                                                          0,
                                                          8,
                                                        ),
                                                      ),
                                                      if (isFirst)
                                                        BoxShadow(
                                                          color: Colors
                                                              .amberAccent
                                                              .withOpacity(0.7),
                                                          blurRadius: 32,
                                                          spreadRadius: 4,
                                                        ),
                                                    ],
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: isFirst ? 44 : 36,
                                                    backgroundColor: medalColor,
                                                    child: Text(
                                                      user.username[0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 34,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'PlusJakartaSans',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (isFirst)
                                                  Positioned(
                                                    top: -22,
                                                    child: Icon(
                                                      Icons.emoji_events,
                                                      color: medalColor,
                                                      size: 44,
                                                    ),
                                                  ),
                                                if (isFirst)
                                                  Positioned(
                                                    top: 14,
                                                    right: 0,
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      size: 22,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                user.username,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight:
                                                      isFirst
                                                          ? FontWeight.bold
                                                          : FontWeight.w600,
                                                  fontSize: 17,
                                                  color:
                                                      isFirst
                                                          ? medalColor
                                                          : Colors.black87,
                                                  fontFamily: 'PlusJakartaSans',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${user.scoreEnglish} pts',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors.success,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Nunito',
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingL),
                    // List of users (4th and below) with fade-in animation
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 600),
                        child: ListView(
                          padding: const EdgeInsets.only(
                            bottom: 100,
                          ), // Add bottom padding for floating navbar
                          children: [
                            for (final rankType in [
                              'Wood+',
                              'Wood',
                              'Unranked',
                            ]) ...[
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
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        rankType == 'Unranked'
                                            ? Icons.remove_circle_outline
                                            : (rankType == 'Wood+'
                                                ? Icons.emoji_events
                                                : Icons.park),
                                        size: 18,
                                        color:
                                            rankType == 'Unranked'
                                                ? AppColors.gray400
                                                : (rankType == 'Wood+'
                                                    ? AppColors.primary
                                                    : AppColors.secondary),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        rankType,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'PlusJakartaSans',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ...grouped[rankType]!.map((user) {
                                final isYou = user.username == currentUser;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.radiusM,
                                  ),
                                  onTap: () {},
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.spacingM,
                                      vertical: AppConstants.spacingXs,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient:
                                          isYou
                                              ? LinearGradient(
                                                colors: [
                                                  AppColors.success.withOpacity(
                                                    0.18,
                                                  ),
                                                  AppColors.success.withOpacity(
                                                    0.07,
                                                  ),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                              : null,
                                      color:
                                          isYou
                                              ? AppColors.success.withOpacity(
                                                0.10,
                                              )
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
                                          color: AppColors.gray200.withOpacity(
                                            0.18,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.gray200,
                                        child: Text(
                                          user.username[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            user.username,
                                            style: TextStyle(
                                              fontWeight:
                                                  isYou
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color:
                                                  isYou
                                                      ? AppColors.success
                                                      : null,
                                              fontFamily: 'PlusJakartaSans',
                                            ),
                                          ),
                                          if (isYou)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 6.0,
                                              ),
                                              child: ShaderMask(
                                                shaderCallback: (Rect bounds) {
                                                  return LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      AppColors.success,
                                                      Colors.white,
                                                    ],
                                                    stops: [0.0, 0.5, 1.0],
                                                  ).createShader(bounds);
                                                },
                                                child: const Text(
                                                  'You',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Nunito',
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'Rank: ${user.currentRank}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      trailing: Text(
                                        '${user.scoreEnglish} pts',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Nunito',
                                          fontSize: 14,
                                        ),
                                      ),
                                      tileColor: Colors.transparent,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ],
                        ),
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
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          switch (index) {
            case 0:
              appRouter.goToHome();
              break;
            case 1:
              appRouter.goToDictionary();
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Practice feature coming soon!')),
              );
              break;
            case 4:
              appRouter.goToProfile();
              break;
          }
        },
      ),
    );
  }
}
