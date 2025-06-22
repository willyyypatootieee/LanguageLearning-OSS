import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import 'profile_screen.dart';

/// Factory widget that provides the ProfileViewModel to the ProfileScreen
class ProfileScreenFactory extends StatelessWidget {
  const ProfileScreenFactory({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadUserProfile(),
      child: const ProfileScreen(),
    );
  }
}
