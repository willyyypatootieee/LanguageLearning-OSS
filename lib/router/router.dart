import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../featureOnBoarding/presentation/screens/onboarding_screen.dart';
import '../featureHomeScreen/presentation/screens/home_screen.dart';
import '../featureAuthentication/presentation/screens/login_screen.dart';
import '../featureAuthentication/presentation/screens/register_screen.dart';
import 'route_constants.dart';

/// Global router instance that can be accessed throughout the app
final GlobalRouter appRouter = GlobalRouter();

/// Centralized router configuration for the entire app
class GlobalRouter {
  late final GoRouter _router;

  GlobalRouter() {
    _router = GoRouter(
      initialLocation: AppRoutes.root,
      routes: [
        // Root route - determines if onboarding or home should be shown
        GoRoute(
          path: AppRoutes.root,
          name: AppRoutes.rootName,
          builder: (context, state) => const _RootScreen(),
        ),

        // Onboarding route
        GoRoute(
          path: AppRoutes.onboarding,
          name: AppRoutes.onboardingName,
          builder: (context, state) => const OnboardingScreen(),
        ), // Home route
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) => const HomeScreen(),
        ),

        // Authentication routes
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) => const LoginScreen(),
        ),

        GoRoute(
          path: AppRoutes.register,
          name: AppRoutes.registerName,
          builder: (context, state) => const RegisterScreen(),
        ),

        // Add more routes here as you develop more features
        // Example:
        // GoRoute(
        //   path: '/profile',
        //   name: 'profile',
        //   builder: (context, state) => const ProfileScreen(),
        // ),
      ],

      // Error page
      errorBuilder:
          (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Page Not Found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The page "${state.uri}" could not be found.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// Get the router instance
  GoRouter get router => _router;

  /// Navigate to onboarding screen
  void goToOnboarding() => _router.go(AppRoutes.onboarding);

  /// Navigate to home screen
  void goToHome() => _router.go(AppRoutes.home);

  /// Navigate to login screen
  void goToLogin() => _router.go(AppRoutes.login);

  /// Navigate to register screen
  void goToRegister() => _router.go(AppRoutes.register);

  /// Navigate to root and let it decide the route
  void goToRoot() => _router.go(AppRoutes.root);

  /// Push a new route
  void push(String location) => _router.push(location);

  /// Go to a specific route
  void go(String location) => _router.go(location);

  /// Go back
  void pop() => _router.pop();

  /// Check if we can pop
  bool canPop() => _router.canPop();
}

/// Legacy class for backward compatibility
class AppRouter {
  /// Get the router instance
  static GoRouter get router => appRouter.router;
}

/// Root screen that determines the initial route based on onboarding status
class _RootScreen extends StatelessWidget {
  const _RootScreen();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _determineInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final targetRoute = snapshot.data ?? AppRoutes.onboarding;
        // Navigate to appropriate screen after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(targetRoute);
        });

        // Show loading while navigating
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Future<String> _determineInitialRoute() async {
    final repository = ServiceLocator.instance.onboardingRepository;

    // Check user status
    final hasCompletedOnboarding = await repository.hasCompletedOnboarding();
    final isLoggedIn = await repository.isUserLoggedIn();

    // Route logic:
    // 1. If user is logged in -> go to home
    // 2. If user completed onboarding but not logged in -> go to login
    // 3. If user hasn't completed onboarding -> go to onboarding
    if (isLoggedIn) {
      return AppRoutes.home;
    } else if (hasCompletedOnboarding) {
      return AppRoutes.login;
    } else {
      return AppRoutes.onboarding;
    }
  }
}

/// Extension methods for easier navigation
extension AppRouterExtension on BuildContext {
  /// Navigate to onboarding screen
  void goToOnboarding() => go(AppRoutes.onboarding);

  /// Navigate to home screen
  void goToHome() => go(AppRoutes.home);

  /// Navigate to login screen
  void goToLogin() => go(AppRoutes.login);

  /// Navigate to register screen
  void goToRegister() => go(AppRoutes.register);

  /// Navigate to root and let it decide the route
  void goToRoot() => go(AppRoutes.root);
}
