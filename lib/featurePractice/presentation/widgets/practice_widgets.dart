import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../data/constants/practice_constants.dart';

/// Header widget for practice screen
class PracticeHeader extends StatelessWidget {
  final int practiceStreak;
  final int totalPracticeTime;

  const PracticeHeader({
    super.key,
    required this.practiceStreak,
    required this.totalPracticeTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Gas VideoCall?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: AppTypography.headerFont,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: AppConstants.spacingXs),

          Text(
            'in develop',
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppTypography.bodyFont,
              color: AppColors.gray600,
            ),
          ),

          const SizedBox(height: AppConstants.spacingL),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Streak',
                  value: '$practiceStreak',
                  unit: 'days',
                  icon: Icons.local_fire_department,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: _StatCard(
                  title: 'Practice Time',
                  value: '$totalPracticeTime',
                  unit: 'min',
                  icon: Icons.timer,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingS),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppConstants.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: AppTypography.bodyFont,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTypography.headerFont,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppTypography.bodyFont,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bento box grid for practice modes
class PracticeBentoGrid extends StatelessWidget {
  final AnimationController animationController;
  final Function(PracticeMode) onModeSelected;

  const PracticeBentoGrid({
    super.key,
    required this.animationController,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row - Large conversation practice card
        SizedBox(
          height: 180,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              final animationValue = Curves.easeOutCubic.transform(
                animationController.value.clamp(0.0, 1.0),
              );

              return Transform.translate(
                offset: Offset(0, 30 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: PracticeModeCard(
                    mode:
                        PracticeConstants
                            .practiceModes[0], // Conversation Practice
                    onTap:
                        () =>
                            onModeSelected(PracticeConstants.practiceModes[0]),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppConstants.spacingM),

        // Second row - Two smaller cards
        SizedBox(
          height: 140,
          child: Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final animationValue = Curves.easeOutCubic.transform(
                      ((animationController.value * 1000) - 100).clamp(
                            0.0,
                            1.0,
                          ) /
                          1000,
                    );

                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - animationValue)),
                      child: Opacity(
                        opacity: animationValue,
                        child: PracticeModeCard(
                          mode:
                              PracticeConstants
                                  .practiceModes[1], // Pronunciation
                          onTap:
                              () => onModeSelected(
                                PracticeConstants.practiceModes[1],
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final animationValue = Curves.easeOutCubic.transform(
                      ((animationController.value * 1000) - 200).clamp(
                            0.0,
                            1.0,
                          ) /
                          1000,
                    );

                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - animationValue)),
                      child: Opacity(
                        opacity: animationValue,
                        child: PracticeModeCard(
                          mode:
                              PracticeConstants.practiceModes[2], // Quick Chat
                          onTap:
                              () => onModeSelected(
                                PracticeConstants.practiceModes[2],
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingM),

        // Third row - Two more smaller cards
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final animationValue = Curves.easeOutCubic.transform(
                      ((animationController.value * 1000) - 300).clamp(
                            0.0,
                            1.0,
                          ) /
                          1000,
                    );

                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - animationValue)),
                      child: Opacity(
                        opacity: animationValue,
                        child: PracticeModeCard(
                          mode: PracticeConstants.practiceModes[3], // Role Play
                          onTap:
                              () => onModeSelected(
                                PracticeConstants.practiceModes[3],
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          final animationValue = Curves.easeOutCubic.transform(
                            ((animationController.value * 1000) - 400).clamp(
                                  0.0,
                                  1.0,
                                ) /
                                1000,
                          );

                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - animationValue)),
                            child: Opacity(
                              opacity: animationValue,
                              child: PracticeModeCard(
                                mode:
                                    PracticeConstants
                                        .practiceModes[4], // Listening
                                onTap:
                                    () => onModeSelected(
                                      PracticeConstants.practiceModes[4],
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Flexible(
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          final animationValue = Curves.easeOutCubic.transform(
                            ((animationController.value * 1000) - 500).clamp(
                                  0.0,
                                  1.0,
                                ) /
                                1000,
                          );

                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - animationValue)),
                            child: Opacity(
                              opacity: animationValue,
                              child: PracticeModeCard(
                                mode:
                                    PracticeConstants
                                        .practiceModes[5], // Grammar
                                onTap:
                                    () => onModeSelected(
                                      PracticeConstants.practiceModes[5],
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Individual practice mode card
class PracticeModeCard extends StatefulWidget {
  final PracticeMode mode;
  final VoidCallback onTap;

  const PracticeModeCard({super.key, required this.mode, required this.onTap});

  @override
  State<PracticeModeCard> createState() => _PracticeModeCardState();
}

class _PracticeModeCardState extends State<PracticeModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 8.0, end: 4.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _hoverController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _hoverController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: widget.mode.color.withOpacity(0.1),
                    blurRadius: _shadowAnimation.value,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                child: Stack(
                  children: [
                    // Background gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.mode.color.withOpacity(0.1),
                              widget.mode.color.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                          widget.mode.isLarge
                              ? AppConstants.spacingL
                              : AppConstants.spacingM,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon
                            Container(
                              padding: EdgeInsets.all(
                                widget.mode.isLarge
                                    ? AppConstants.spacingM
                                    : AppConstants.spacingS,
                              ),
                              decoration: BoxDecoration(
                                color: widget.mode.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  widget.mode.isLarge
                                      ? AppConstants.radiusL
                                      : AppConstants.radiusM,
                                ),
                              ),
                              child: Icon(
                                widget.mode.icon,
                                color: widget.mode.color,
                                size: widget.mode.isLarge ? 32 : 24,
                              ),
                            ),

                            SizedBox(
                              height:
                                  widget.mode.isLarge
                                      ? AppConstants.spacingM
                                      : AppConstants.spacingXs,
                            ),

                            // Title
                            Text(
                              widget.mode.title,
                              style: TextStyle(
                                fontSize: widget.mode.isLarge ? 18 : 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTypography.headerFont,
                                color: Colors.black87,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(
                              height:
                                  widget.mode.isLarge
                                      ? AppConstants.spacingXs
                                      : 2,
                            ),

                            // Subtitle
                            Flexible(
                              child: Text(
                                widget.mode.subtitle,
                                style: TextStyle(
                                  fontSize: widget.mode.isLarge ? 13 : 11,
                                  fontFamily: AppTypography.bodyFont,
                                  color: AppColors.gray600,
                                  height: 1.2,
                                ),
                                maxLines: widget.mode.isLarge ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Special indicator for main feature
                            if (widget.mode.title ==
                                'Conversation Practice') ...[
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingS,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.mode.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Talk to AI Bear! 🐻',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: AppTypography.bodyFont,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
