import 'package:flutter/material.dart';

/// Model class representing a single onboarding page
class OnboardingPage {
  final String image;
  final String title;
  final String description;
  final Color backgroundColor;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });
}
