import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'core/providers/api_service_provider.dart'; // Add this import
import 'app.dart'; // This import already includes all the necessary exports

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ApiServiceProvider
  ApiServiceProvider(); // This initializes the singleton

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // Tambahkan provider lain di sini jika diperlukan
        // Add other providers here if needed
      ],
      child: const BeLingApp(),
    ),
  );
}

class BeLingApp extends StatelessWidget {
  const BeLingApp({super.key});

  bool _isDesktopOrWeb() {
    // Check if the app is running on web or desktop platforms
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContent = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeLing App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const SplashScreen(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        // Tambahkan rute lain di sini
        // Add other routes here
      },
    );

    // Apply fixed size constraint for web and desktop platforms
    if (_isDesktopOrWeb()) {
      // Galaxy S20 dimensions: 384 x 854
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          width: 384,
          height: 854,
          child: appContent,
        ),
      );
    }

    // Return default app for mobile platforms
    return appContent;
  }
}
