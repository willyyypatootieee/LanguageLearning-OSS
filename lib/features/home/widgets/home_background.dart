import 'package:flutter/material.dart';

/// Widget for Home screen background
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset('assets/images/home.png', fit: BoxFit.cover),
    );
  }
}
