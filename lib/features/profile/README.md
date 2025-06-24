# Profile Feature Module

This module contains all components related to the user profile feature in the BeLing application.

## Structure

## biar ijo

The module follows a clean, modular architecture with the following components:

### Constants
- `profile_strings.dart`: String constants used throughout the profile feature (Indonesian language)

### Controllers
- `profile_screen_controller.dart`: Handles navigation and data operations

### Models
- `profile_model.dart`: Data models for user profile and badges

### Screens
- `profile_screen.dart`: The main profile UI implementation
- `profile_screen_factory.dart`: Factory component that provides the ViewModel to the screen

### Services
- `profile_service.dart`: Service layer for API calls and data operations

### Theme
- `profile_theme.dart`: Profile-specific styling and theme elements

### ViewModels
- `profile_view_model.dart`: ViewModel that handles business logic and state management

### Widgets
- `badges_section.dart`: UI component for displaying monthly badges
- `overview_section.dart`: UI component for displaying profile statistics
- `profile_header.dart`: UI component for displaying user info and profile picture

## Usage

To use this feature in the app, simply import the main barrel file:

```dart
import 'features/profile/profile.dart';
```

And then use the `ProfileScreenFactory` to create the profile screen with its ViewModel:

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const ProfileScreenFactory(),
  ),
);
```

## Dependencies

This module depends on:
- Flutter Material library
- Rive animation (for profile picture)
- Provider pattern (for state management)

## Customization

The UI can be customized by modifying the `ProfileTheme` class, and text can be changed in `ProfileStrings` for different languages.
