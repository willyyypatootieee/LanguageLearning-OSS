import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/practice_screen_controller.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Practice',
      selectedNavIndex: 3,
      onNavTap:
          (index) => PracticeScreenController.handleNavbarTap(context, index),
      body: const Center(child: Text('Practice Screen Content')),
    );
  }
}
