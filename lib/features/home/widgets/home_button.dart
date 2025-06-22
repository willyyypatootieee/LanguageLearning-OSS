import 'package:flutter/material.dart';

/// Widget for the main action button on Home screen
class HomeButton extends StatelessWidget {
  final VoidCallback onTap;

  const HomeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: MediaQuery.of(context).size.width * 0.62,
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset('assets/images/button.png', width: 64, height: 64),
      ),
    );
  }
}
