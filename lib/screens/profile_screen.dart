import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../widgets/navbar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'add_screen.dart';
import 'notif_screen.dart';

/// Halaman profil dengan animasi Rive.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StateMachineController? _controller; // Kontroler state machine Rive
  SMIInput<bool>? _tapInput; // Input untuk trigger animasi
  String? _currentState; // State saat ini

  // Inisialisasi Rive dan kontrol state machine
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'state machine',
      onStateChange: _onStateChange,
    );
    if (controller != null) {
      artboard.addController(controller);
      setState(() {
        _controller = controller;
        _tapInput = controller.findInput<bool>('tap');
      });
    }
  }

  // Callback saat terjadi perubahan state pada state machine
  void _onStateChange(String stateMachineName, String stateName) {
    setState(() {
      _currentState = stateName;
    });
  }

  // Fungsi untuk trigger input 'tap' pada Rive
  void _onTap() {
    _tapInput?.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Widget animasi Rive
                SizedBox(
                  width: 200,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/images/personalised_character.riv',
                    onInit: _onRiveInit,
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol untuk trigger animasi
                ElevatedButton(onPressed: _onTap, child: const Text('Animate')),
                // Menampilkan state saat ini jika ada
                if (_currentState != null)
                  Text('Current State: $_currentState'),
              ],
            ),
          ),
          // Navbar mengambang di bagian bawah
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Navbar(
              selectedIndex: 4,
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const SearchScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 2) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const AddScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 3) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NotifScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                }
                // index 4 is ProfileScreen itself, do nothing
              },
            ),
          ),
        ],
      ),
    );
  }
}
