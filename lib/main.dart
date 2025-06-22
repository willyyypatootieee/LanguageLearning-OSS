import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const BeLingApp());
}

class BeLingApp extends StatelessWidget {
  const BeLingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
