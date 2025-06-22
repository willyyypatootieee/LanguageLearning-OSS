import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import 'profile_screen.dart';

/// Halaman utama dengan latar belakang dan tombol di posisi tertentu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang
      body: Stack(
        children: [
          // Latar belakang gambar home
          Positioned.fill(
            child: Image.asset('assets/images/home.png', fit: BoxFit.cover),
          ),
          // Tombol gambar di posisi tertentu
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.62,
            child: GestureDetector(
              onTap: () {}, // Aksi saat tombol ditekan
              child: Image.asset(
                'assets/images/button.png',
                width: 64,
                height: 64,
              ),
            ),
          ),
          // Area untuk tombol tambahan di bagian bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  // Tambahkan tombol lain di sini jika diperlukan
                ],
              ),
            ),
          ),
          // Navbar mengambang di bagian bawah
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Navbar(
                selectedIndex: 0,
                onTap: (index) {
                  if (index == 4) {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ProfileScreen(),
                        transitionDuration: const Duration(milliseconds: 220),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
