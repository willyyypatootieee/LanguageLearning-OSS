import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart'; // This import already includes all the necessary exports

void main() {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  }
}
