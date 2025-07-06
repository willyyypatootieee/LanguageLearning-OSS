import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/constants/app_constants.dart';
import 'fullscreen_avatar_page.dart';

/// Profile stat card widget showing user statistics
class ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? backgroundColor;

  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        // Simplified shadow for better performance
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingS),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.gray900,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile header with user avatar and basic info
class ProfileHeader extends StatefulWidget {
  final String username;
  final String handle;
  final String joinDate;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onLogoutPressed;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.handle,
    required this.joinDate,
    this.onSettingsPressed,
    this.onLogoutPressed,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  rive.Artboard? _artboard;
  rive.StateMachineController? _controller;
  bool _isAnimationActive = false;

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  void _loadRive() async {
    final data = await rootBundle.load('assets/animation/chooseAvatar.riv');
    final file = rive.RiveFile.import(data);
    final artboard = file.mainArtboard;
    rive.StateMachineController? controller;
    if (artboard.stateMachines.isNotEmpty) {
      controller = rive.StateMachineController.fromArtboard(
        artboard,
        artboard.stateMachines.first.name,
      );
      if (controller != null) {
        artboard.addController(controller);
        // Don't start animation immediately
        controller.isActive = false;
      }
    }
    setState(() {
      _artboard = artboard;
      _controller = controller;
    });
  }

  void _toggleAnimation() {
    if (_controller != null) {
      setState(() {
        _isAnimationActive = !_isAnimationActive;
        _controller!.isActive = _isAnimationActive;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base container with height
        Container(
          width: double.infinity,
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
            ),
          ),
        ),
        // Avatar animation card (clickable, wrapped in card matching ProfileInfoCard style)
        Positioned.fill(
          child: Center(
            child: Container(
              width: double.infinity,
              height: 340,
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 60, // Moved down by increasing this value
                bottom: 4, // Reduced bottom margin to shift content down
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.00),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 20,
                  bottom: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusXl - 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _toggleAnimation();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => const FullscreenAvatarPage(
                                    interactive: true,
                                  ),
                            ),
                          );
                        }
                      });
                    },
                    child:
                        _artboard == null
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                              padding: const EdgeInsets.only(
                                top: 100,
                                bottom: 5,
                              ), // Push content down within container
                              alignment:
                                  Alignment
                                      .bottomCenter, // Align to bottom center
                              child: Transform.scale(
                                scale:
                                    6.80, // Scale down the Rive animation to 75%
                                child: rive.Rive(
                                  artboard: _artboard!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Action buttons with modern design
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Row(
            children: [
              if (widget.onLogoutPressed != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: AppColors.error,
                      size: 24,
                    ),
                    onPressed: widget.onLogoutPressed,
                  ),
                ),
              const SizedBox(width: 8),
              if (widget.onSettingsPressed != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: AppColors.gray700,
                      size: 24,
                    ),
                    onPressed: widget.onSettingsPressed,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String username;
  final String handle;
  final String joinDate;
  final int following;
  final int followers;
  final String country;
  final String countryLabel;

  const ProfileInfoCard({
    super.key,
    required this.username,
    required this.handle,
    required this.joinDate,
    required this.following,
    required this.followers,
    required this.country,
    required this.countryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      transform: Matrix4.translationValues(0, -20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        // Simplified shadow for better performance
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              username.toUpperCase(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.gray900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              handle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.gray600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bergabung Pada $joinDate',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback? onAddFriends;
  final VoidCallback? onShare;
  const ProfileActionButtons({super.key, this.onAddFriends, this.onShare});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (onAddFriends != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onAddFriends,
                  icon: const Icon(Icons.person_add_alt_1, size: 20),
                  label: const Text('Add Friends'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          if (onAddFriends != null) const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share_rounded, size: 20),
                label: const Text('Bagikan Akun'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile section divider with title
class ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ProfileSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingM,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray800,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
