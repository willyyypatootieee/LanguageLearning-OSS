# BeLing Project - Modular Structure

## Project Structure

The project follows a modular architecture with the following structure:

### Core

Contains fundamental application components:
- `constants`: App-wide constants like durations, sizes, and paddings
- `navigation`: Routing utilities for screen transitions
- `theme`: App theme definitions including colors and styles

### Features

Each feature is organized as an independent module with its own:
- `screens`: UI presentation layer
- `widgets`: Feature-specific UI components
- `controllers`: Business logic and state management
- `models` (as needed): Data structures for the feature

Features include:
- `book`: Book screen and related components
- `home`: Home screen and related components
- `leaderboard`: Leaderboard screen and related components
- `practice`: Practice screen and related components
- `profile`: Profile screen and related components
- `onboarding`: Onboarding screen and related components
- `splash`: Splash screen and related components

### Shared

Contains shared components used across multiple features:
- `widgets`: Reusable UI components including:
  - `navbar`: Bottom navigation components
  - `base_screen`: Common screen layout

## Import Strategy

The project uses barrel files to simplify imports:
- Each feature has a main export file (e.g., `home.dart`) that exports all its components
- Core modules are exported through `core.dart`
- Shared widgets are exported through `widgets.dart`
- All main modules are exported through the root `app.dart` file

This approach reduces import statements and makes the code more maintainable.

## Navigation

Navigation between screens is handled by the `AppRouter` utility class, providing consistent transitions throughout the app.

## Development Guidelines

1. Keep features modular and independent
2. Use controllers for business logic
3. Keep UI components focused and reusable
4. Use barrel files for clean imports
5. Follow consistent naming conventions
