import 'package:flutter/material.dart';
import 'package:experimental/src/navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screen/profile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Latar belakang SVG fullscreen
          Positioned.fill(
            child: Image.asset('assets/images/home.png', fit: BoxFit.cover),
          ),
          // Tombol PNG pada posisi dan skala tertentu
          Positioned(
            top: 40, // Atur nilai ini agar sesuai dengan posisi checkmark
            left:
                MediaQuery.of(context).size.width *
                0.62, // Sesuaikan sesuai kebutuhan
            child: GestureDetector(
              onTap: () {
                // TODO: Tambahkan aksi di sini
              },
              child: Image.asset(
                'assets/images/button.png',
                width: 64,
                height: 64,
              ),
            ),
          ),
          // Tombol-tombol di bagian bawah, di atas SVG
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // Mengatur posisi tombol lebih tinggi
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  // ...tambahkan tombol di sini...
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 4) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ProfileScreen(),
                settings: const RouteSettings(name: '/profile'),
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
