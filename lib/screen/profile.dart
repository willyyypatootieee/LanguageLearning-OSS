import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../src/navbar.dart';
import '../main/home/home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// FUCKING PISS OF SHIT RIVE ANIMATION NIGGA

class _ProfileScreenState extends State<ProfileScreen> {
  StateMachineController? _controller;
  SMIInput<bool>? _tapInput;
  String? _currentState;

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
    // Bisa digunakan untuk aksi tambahan saat state berubah
    // print('State berubah di $stateMachineName menjadi $stateName');
  }

  // Fungsi untuk trigger input 'tap' pada Rive
  void _onTap() {
    _tapInput?.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _onTap,
        child: SizedBox.expand(
          child: RiveAnimation.asset(
            'assets/images/personalised_character.riv',
            fit: BoxFit.cover,
            stateMachines: const ['state machine'],
            onInit: _onRiveInit,
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Home(),
                settings: const RouteSettings(name: '/home'),
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
        },
      ),
    );
  }
}
