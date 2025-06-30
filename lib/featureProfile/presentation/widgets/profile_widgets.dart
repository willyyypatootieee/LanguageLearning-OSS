import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/constants/app_constants.dart';

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
        color: backgroundColor ?? AppColors.gray50,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile header with user avatar and basic info
class ProfileHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          color: AppColors.accent,
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => const FullscreenAvatarPage(interactive: true),
                  ),
                );
              },
              child: Container(
                width: 650,
                height: 650,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: rive.RiveAnimation.asset(
                    'assets/animation/chooseAvatar.riv',
                    fit: BoxFit.cover,
                    // Let the animation play and be interactive
                    controllers: [],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              if (onLogoutPressed != null)
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black, size: 28),
                  onPressed: onLogoutPressed,
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
              if (onSettingsPressed != null)
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed: onSettingsPressed,
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
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
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username.toUpperCase(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$handle · Joined $joinDate',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 16),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          if (onAddFriends != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onAddFriends,
                icon: const Icon(Icons.person_add_alt_1, size: 24),
                label: const Text('Add Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black,
                ),
              ),
            ),
          if (onAddFriends != null) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.upload_rounded, size: 24),
              label: const Text('Share  Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 6,
                shadowColor: Colors.black,
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

/// Fullscreen avatar page widget
class FullscreenAvatarPage extends StatefulWidget {
  final bool interactive;
  const FullscreenAvatarPage({super.key, this.interactive = false});

  @override
  State<FullscreenAvatarPage> createState() => _FullscreenAvatarPageState();
}

class _FullscreenAvatarPageState extends State<FullscreenAvatarPage> {
  rive.Artboard? _artboard;
  rive.StateMachineController? _controller;
  List<rive.SMIInput<dynamic>>? _inputs;

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
      }
    }
    setState(() {
      _artboard = artboard;
      _controller = controller;
      _inputs = controller?.inputs.toList();
    });
  }

  void _onTap() {
    if (_inputs != null) {
      for (final input in _inputs!) {
        if (input is rive.SMIBool) {
          input.value = !input.value;
        } else if (input is rive.SMITrigger) {
          input.fire();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child:
                _artboard == null
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                      onTap: _onTap,
                      child: rive.Rive(artboard: _artboard!),
                    ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
