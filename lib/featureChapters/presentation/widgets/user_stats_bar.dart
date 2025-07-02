import 'package:flutter/material.dart';
import '../../domain/models/user_profile.dart';
import '../../data/datasources/chapter_remote_datasource.dart';

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
      final profileData = await _dataSource.getUserProfile();
      if (profileData != null) {
        setState(() {
          _userProfile = UserProfile.fromJson(profileData);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_userProfile == null) {
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(icon: Icons.favorite, value: '5', color: Colors.red),
            _buildStatItem(
              icon: Icons.monetization_on,
              value: '0',
              color: Colors.amber,
            ),
            _buildStatItem(icon: Icons.star, value: '0', color: Colors.blue),
          ],
        ),
      );
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Health/Hearts
          _buildStatItem(
            icon: Icons.favorite,
            value: '${_userProfile!.health}',
            color: Colors.red,
          ),

          // Coins
          _buildStatItem(
            icon: Icons.monetization_on,
            value: '${_userProfile!.coins}',
            color: Colors.amber,
          ),

          // Total XP
          _buildStatItem(
            icon: Icons.star,
            value: '${_userProfile!.totalXp}',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
