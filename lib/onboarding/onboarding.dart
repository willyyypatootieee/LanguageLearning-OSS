import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:experimental/main/home/home.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Latar belakang SVG fullscreen
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/onboarding.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Tombol-tombol di bagian bawah, di atas SVG
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // Mengatur posisi tombol lebih tinggi (sebelumnya 40)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  // Tombol "MASUK" (outline, latar putih)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF3ED),
                        side: const BorderSide(
                          color: Color(0xFFFFA726),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'MASUK',
                        style: TextStyle(
                          color: Color(0xFFFFA726),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // DO NOT FUCKING MESSING AROUND WITH THIS.
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementasi navigasi ke halaman registrasi
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'DAFTAR AKUN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
