import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../domain/models/leaderboard_user.dart';

/// Modern bento box style top 3 leaderboard widget
class BentoTop3Widget extends StatefulWidget {
  final List<LeaderboardUser> top3Users;

  const BentoTop3Widget({super.key, required this.top3Users});

  @override
  State<BentoTop3Widget> createState() => _BentoTop3WidgetState();
}

class _BentoTop3WidgetState extends State<BentoTop3Widget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top Tier',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlusJakartaSans',
                              ),
                            ),
                            Text(
                              'Pemain Hebat, Lo Bisa Jadi Terbaik!',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bento grid for top 3
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _buildBentoGrid(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBentoGrid() {
    if (widget.top3Users.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No data')));
    }

    final firstPlace = widget.top3Users.isNotEmpty ? widget.top3Users[0] : null;
    final secondPlace =
        widget.top3Users.length > 1 ? widget.top3Users[1] : null;
    final thirdPlace = widget.top3Users.length > 2 ? widget.top3Users[2] : null;

    return SizedBox(
      height: 350,
      // width: double.infinity,
      child: Row(
        children: [
          // Left column (2nd place)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                if (secondPlace != null)
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: _buildUserCard(
                            secondPlace,
                            2,
                            const Color(0xFFC0C0C0), // Silver
                            isSecondary: true,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                if (thirdPlace != null)
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: _buildUserCard(
                            thirdPlace,
                            3,
                            const Color(0xFFCD7F32), // Bronze
                            isSecondary: true,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right column (1st place - larger)
          Expanded(
            flex: 4,
            child:
                firstPlace != null
                    ? _buildUserCard(
                      firstPlace,
                      1,
                      const Color(0xFFFFD700), // Gold
                      isChampion: true,
                    )
                    : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(
    LeaderboardUser user,
    int position,
    Color accentColor, {
    bool isChampion = false,
    bool isSecondary = false,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: isChampion ? 2000 : 1500),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, pulseValue, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..scale(isChampion ? pulseValue : 1.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.1),
                  accentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                if (isChampion)
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Position indicator
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.bounceOut,
                    builder: (context, bounceValue, child) {
                      return Transform.scale(
                        scale: bounceValue,
                        child: Container(
                          width: isChampion ? 44 : 34,
                          height: isChampion ? 44 : 34,
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$position',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isChampion ? 20 : 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlusJakartaSans',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  if (isChampion) ...[
                    const SizedBox(height: 4),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1200),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 0.1,
                          child: Icon(
                            Icons.emoji_events,
                            color: accentColor,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 8),

                  // User avatar
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: CircleAvatar(
                          radius: isChampion ? 28 : 22,
                          backgroundColor: accentColor.withOpacity(0.2),
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: isChampion ? 24 : 18,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // Username
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Text(
                          user.username,
                          style: TextStyle(
                            fontSize: isChampion ? 16 : 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray900,
                            fontFamily: 'PlusJakartaSans',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 4),

                  // Score
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, scaleValue, child) {
                      return Transform.scale(
                        scale: scaleValue,
                        child: TweenAnimationBuilder<int>(
                          duration: const Duration(milliseconds: 1500),
                          tween: IntTween(begin: 0, end: user.totalPoint),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: accentColor.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: isChampion ? 18 : 14,
                                    color:
                                        isChampion
                                            ? Colors.amber.shade700
                                            : accentColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$value pts',
                                    style: TextStyle(
                                      fontSize: isChampion ? 16 : 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isChampion
                                              ? Colors.amber.shade700
                                              : accentColor,
                                      fontFamily: 'Nunito',
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bento box style stats overview widget
class BentoStatsWidget extends StatefulWidget {
  final List<LeaderboardUser> allUsers;

  const BentoStatsWidget({super.key, required this.allUsers});

  @override
  State<BentoStatsWidget> createState() => _BentoStatsWidgetState();
}

class _BentoStatsWidgetState extends State<BentoStatsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 100.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalUsers = widget.allUsers.length;
    final averageScore =
        widget.allUsers.isNotEmpty
            ? (widget.allUsers
                        .map((u) => u.totalPoint)
                        .reduce((a, b) => a + b) /
                    totalUsers)
                .round()
            : 0;
    final highestScore =
        widget.allUsers.isNotEmpty
            ? widget.allUsers
                .map((u) => u.totalPoint)
                .reduce((a, b) => a > b ? a : b)
            : 0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, _slideAnimations[0].value),
                  child: _buildStatCard(
                    'Pemain Total',
                    totalUsers.toString(),
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, _slideAnimations[1].value),
                  child: _buildStatCard(
                    'Rata-Rata Skor',
                    '$averageScore pts',
                    Icons.analytics,
                    AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, _slideAnimations[2].value),
                  child: _buildStatCard(
                    'Skor Tertinggi',
                    '$highestScore pts',
                    Icons.emoji_events_rounded,
                    AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.bounceOut,
                  builder: (context, bounceValue, child) {
                    return Transform.scale(
                      scale: bounceValue,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<int>(
                  duration: const Duration(milliseconds: 1000),
                  tween: IntTween(
                    begin: 0,
                    end: int.tryParse(value.split(' ')[0]) ?? 0,
                  ),
                  curve: Curves.easeOut,
                  builder: (context, animatedValue, child) {
                    return Text(
                      value.contains('pts')
                          ? '$animatedValue pts'
                          : animatedValue.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                    fontFamily: 'Nunito',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Modern rank section widget with bento style
class BentoRankSectionWidget extends StatelessWidget {
  final String rankType;
  final List<LeaderboardUser> users;
  final String currentUsername;

  const BentoRankSectionWidget({
    super.key,
    required this.rankType,
    required this.users,
    this.currentUsername = '',
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();

    Color rankColor = _getRankColor(rankType);
    IconData rankIcon = _getRankIcon(rankType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Rank header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  rankColor.withOpacity(0.1),
                  rankColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(rankIcon, color: rankColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rankType,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: rankColor,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                      Text(
                        '${users.length} player${users.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: rankColor.withOpacity(0.7),
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${users.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Users list
          ...users.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            final isCurrentUser = user.username == currentUsername;
            final isLast = index == users.length - 1;

            return _buildUserTile(
              user,
              index + 4, // +4 because top 3 are shown separately
              isCurrentUser,
              isLast,
              rankColor,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUserTile(
    LeaderboardUser user,
    int position,
    bool isCurrentUser,
    bool isLast,
    Color rankColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient:
            isCurrentUser
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.success.withOpacity(0.15),
                    AppColors.success.withOpacity(0.08),
                  ],
                )
                : null,
        color: isCurrentUser ? null : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border:
            isCurrentUser
                ? Border.all(
                  color: AppColors.success.withOpacity(0.4),
                  width: 2,
                )
                : null,
        boxShadow:
            isCurrentUser
                ? [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor:
                  isCurrentUser
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.gray200,
              child: Text(
                user.username[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCurrentUser ? AppColors.success : AppColors.gray700,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.username,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                  color: isCurrentUser ? AppColors.success : AppColors.gray900,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          rankType == 'Unranked' ? 'Rank: -' : 'Rank: ${user.currentRank}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.gray600,
            fontFamily: 'Nunito',
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: rankColor.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: rankColor.withOpacity(0.3), width: 1.2),
          ),
          child: TweenAnimationBuilder<int>(
            duration: const Duration(milliseconds: 1000),
            tween: IntTween(begin: 0, end: user.totalPoint),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 16, color: rankColor),
                  const SizedBox(width: 4),
                  Text(
                    '$value pts',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                      fontFamily: 'Nunito',
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getRankColor(String rankType) {
    switch (rankType) {
      case 'Wood+':
        return AppColors.primary;
      case 'Wood':
        return AppColors.secondary;
      case 'Unranked':
      default:
        return AppColors.gray400;
    }
  }

  IconData _getRankIcon(String rankType) {
    switch (rankType) {
      case 'Wood+':
        return Icons.emoji_events;
      case 'Wood':
        return Icons.park;
      case 'Unranked':
      default:
        return Icons.remove_circle_outline;
    }
  }
}
