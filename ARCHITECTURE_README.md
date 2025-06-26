# 🏗️ Feature-Based Architecture Documentation

This document describes the new clean architecture structure implemented for the BeLing app.

## 📁 New Project Structure

```
lib/
┣ 📂 core/                    # App-wide logic (theme, utils, constants)
┃ ┣ 📂 constants/
┃ ┃ ┗ 📄 app_constants.dart   # Global constants, colors, typography
┃ ┣ 📂 theme/
┃ ┃ ┗ 📄 app_theme.dart       # Material theme configuration
┃ ┣ 📂 di/
┃ ┃ ┗ 📄 service_locator.dart # Dependency injection
┃ ┗ 📄 core.dart              # Core module barrel file
┣ 📂 shared/                  # Widgets used across multiple features
┃ ┗ 📂 widgets/
┣ 📂 router/                  # GoRouter / Navigator config
┣ 📂 services/                # Global services (e.g., API client, auth)
┣ 📂 featureOnBoarding/       # Onboarding feature module
┃ ┣ 📂 data/
┃ ┃ ┣ 📂 constants/
┃ ┃ ┃ ┗ 📄 onboarding_constants.dart
┃ ┃ ┣ 📂 datasources/
┃ ┃ ┃ ┗ 📄 onboarding_local_datasource.dart
┃ ┃ ┗ 📂 repositories/
┃ ┃   ┗ 📄 onboarding_repository_impl.dart
┃ ┣ 📂 domain/
┃ ┃ ┣ 📂 models/
┃ ┃ ┃ ┗ 📄 onboarding_page.dart
┃ ┃ ┗ 📂 repositories/
┃ ┃   ┗ 📄 onboarding_repository.dart
┃ ┗ 📂 presentation/
┃   ┣ 📂 screens/
┃   ┃ ┗ 📄 onboarding_screen.dart
┃   ┗ 📂 widgets/
┃     ┣ 📄 onboarding_page_widget.dart
┃     ┣ 📄 onboarding_indicators.dart
┃     ┣ 📄 onboarding_navigation_buttons.dart
┃     ┣ 📄 onboarding_skip_button.dart
┃     ┗ 📄 widgets.dart       # Barrel file
┣ 📂 featureHomeScreen/       # Home screen feature module
┃ ┗ 📂 presentation/
┃   ┗ 📂 screens/
┃     ┗ 📄 home_screen.dart
┗ 📄 main.dart
```

## 🏛️ Architecture Principles

### **Clean Architecture Layers**

1. **Domain Layer** (`domain/`)
   - Contains business logic and entities
   - Independent of external dependencies
   - Defines repository interfaces

2. **Data Layer** (`data/`)
   - Implements repository interfaces
   - Handles data sources (local, remote)
   - Contains data models and constants

3. **Presentation Layer** (`presentation/`)
   - UI components and screens
   - State management
   - User interaction handling

### **Feature-Based Organization**

Each feature is self-contained with its own:
- Business logic (domain layer)
- Data handling (data layer)  
- UI components (presentation layer)

### **Dependency Flow**

```
Presentation → Domain ← Data
```

- **Presentation** depends on **Domain**
- **Data** depends on **Domain**  
- **Domain** has no dependencies (pure business logic)

## 🔧 Key Components

### **Core Module**
- `AppConstants`: Global constants, spacing, colors
- `AppTheme`: Material theme with proper typography
- `ServiceLocator`: Simple dependency injection

### **Onboarding Feature**
- **Domain**: `OnboardingPage` model, `OnboardingRepository` interface
- **Data**: Local storage implementation, constants
- **Presentation**: Screens and reusable widgets

## 🎨 Design System

### **Typography**
- **Headers**: PlusJakartaSans (Bold) - via `theme.textTheme.headline*`
- **Body**: Nunito (Regular/Medium) - via `theme.textTheme.body*`

### **Colors** 
- Centralized in `AppColors`
- Semantic color names (primary, secondary, etc.)
- Consistent gray scale

### **Spacing**
- Standardized spacing values in `AppConstants`
- Consistent across all components

## 📦 Dependencies

### **Existing Dependencies**
- `shared_preferences`: Local storage
- Flutter Material Design

### **Architecture Benefits**
- ✅ **Scalability**: Easy to add new features
- ✅ **Maintainability**: Clear separation of concerns  
- ✅ **Testability**: Each layer can be tested independently
- ✅ **Reusability**: Shared components and utilities
- ✅ **Consistency**: Centralized design system

## 🚀 Adding New Features

To add a new feature (e.g., `featureProfile`):

1. **Create feature directory structure**:
   ```
   featureProfile/
   ┣ domain/
   ┃ ┣ models/
   ┃ ┗ repositories/
   ┣ data/
   ┃ ┣ datasources/
   ┃ ┗ repositories/
   ┗ presentation/
     ┣ screens/
     ┗ widgets/
   ```

2. **Define domain models and repositories**
3. **Implement data layer**
4. **Create presentation components**
5. **Register dependencies in `ServiceLocator`**

## 🧪 Testing Strategy

- **Unit Tests**: Domain logic and data repositories
- **Widget Tests**: Individual presentation components  
- **Integration Tests**: Feature workflows
- **Golden Tests**: UI consistency

## 🔄 Migration from Old Structure

The old monolithic structure has been refactored to this feature-based approach:

- ❌ `lib/models/` → ✅ `featureX/domain/models/`
- ❌ `lib/widgets/` → ✅ `featureX/presentation/widgets/`
- ❌ `lib/screens/` → ✅ `featureX/presentation/screens/`
- ❌ `lib/services/` → ✅ `featureX/data/repositories/`

All imports have been updated to use the new structure.
