import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import '../src/navbar.dart';
import '../main/home/home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StateMachineController? _stateMachineController;
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/images/personalised_character.riv').then((
      data,
    ) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      final controller = StateMachineController.fromArtboard(
        artboard,
        'state machine', // Use your state machine name
      );
      if (controller != null) {
        artboard.addController(controller);
      }
      setState(() {
        _artboard = artboard;
        _stateMachineController = controller;
      });
    });
  }

  void _onTap() {
    // Example: If your state machine has a trigger input named 'tap'
    final trigger = _stateMachineController?.findInput<bool>('tap');
    if (trigger != null) {
      trigger.value = true;
    }
    // Add more logic if your state machine uses other input types
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _onTap,
        child: SizedBox.expand(
          child:
              _artboard == null
                  ? const SizedBox.shrink()
                  : Rive(artboard: _artboard!, fit: BoxFit.cover),
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
