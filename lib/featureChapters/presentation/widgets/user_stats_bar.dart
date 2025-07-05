import 'package:flutter/material.dart';
import 'dart:ui';
import '../../domain/models/user_profile.dart';
import '../../data/datasources/chapter_remote_datasource.dart';
import '../../../../../featureAuthentication/data/datasources/auth_local_datasource.dart';

/// Top status bar widget that displays user stats
class UserStatsBar extends StatefulWidget {
  const UserStatsBar({super.key});

  @override
  State<UserStatsBar> createState() => _UserStatsBarState();
}

class _UserStatsBarState extends State<UserStatsBar> {
  final ChapterRemoteDataSource _dataSource = ChapterRemoteDataSource();
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final authLocal = AuthLocalDataSource();
      final currentUser = await authLocal.getCurrentUser();
      if (currentUser == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }
      final profileData = await _dataSource.getUserById(currentUser.id);
      if (profileData != null) {
        if (mounted) {
          setState(() {
            _userProfile = UserProfile.fromJson(profileData);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // In build(), update the UI for a more modern, fancy look
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _fancyBar(
        context,
        children: [
          _fancyStatPlaceholder(),
          _fancyStatPlaceholder(),
          _fancyStatPlaceholder(),
        ],
      );
    }
    if (_userProfile == null) {
      return _fancyBar(
        context,
        children: [
          _fancyStat(icon: Icons.favorite, value: '5', color: Colors.red),
          _fancyStat(
            icon: Icons.monetization_on,
            value: '0',
            color: Colors.amber,
          ),
          _fancyStat(icon: Icons.star, value: '0', color: Colors.blue),
        ],
      );
    }
    return _fancyBar(
      context,
      children: [
        _fancyStat(
          icon: Icons.favorite,
          value: '${_userProfile!.health}',
          color: Colors.redAccent,
        ),
        _fancyStat(
          icon: Icons.monetization_on,
          value: '${_userProfile!.coins}',
          color: Colors.amber,
        ),
        _fancyStat(
          icon: Icons.star,
          value: '${_userProfile!.totalXp}',
          color: Colors.yellow[700]!,
        ),
      ],
    );
  }

  Widget _fancyBar(BuildContext context, {required List<Widget> children}) {
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [Color(0x66FFFFFF), Color(0x33D1E9FF)], // more transparent
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), // more blur
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children.map((child) => Expanded(child: child)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _fancyStat({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    Widget coolIcon;
    if (icon == Icons.favorite) {
      coolIcon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(Icons.favorite, color: Colors.redAccent, size: 28),
      );
    } else if (icon == Icons.monetization_on) {
      coolIcon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(Icons.monetization_on, color: Colors.amber[800], size: 28),
      );
    } else if (icon == Icons.star) {
      coolIcon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.yellow[800]!.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(Icons.star, color: Colors.yellow[800], size: 28),
      );
    } else {
      coolIcon = Icon(icon, color: color, size: 24);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder:
          (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              0.7,
            ), // more solid background for readability
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.18), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              coolIcon,
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fancyStatPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.10),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }
}

/// Refreshable version of UserStatsBar
class RefreshableUserStatsBar extends StatefulWidget {
  const RefreshableUserStatsBar({super.key});

  @override
  State<RefreshableUserStatsBar> createState() =>
      _RefreshableUserStatsBarState();
}

class _RefreshableUserStatsBarState extends State<RefreshableUserStatsBar> {
  final GlobalKey<_UserStatsBarState> _statsBarKey = GlobalKey();

  void refreshStats() {
    _statsBarKey.currentState?._loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return UserStatsBar(key: _statsBarKey);
  }
}
