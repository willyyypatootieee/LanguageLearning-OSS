import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Profile',
      selectedNavIndex: 4,
      onNavTap:
          (index) => ProfileScreenController.handleNavbarTap(context, index),
      body: const Center(child: Text('Profile Screen Content')),
    );
  }
}
