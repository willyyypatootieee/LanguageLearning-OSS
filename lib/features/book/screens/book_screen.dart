import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/book_screen_controller.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Book',
      selectedNavIndex: 1,
      onNavTap: (index) => BookScreenController.handleNavbarTap(context, index),
      body: const Center(child: Text('Book Screen Content')),
    );
  }
}
