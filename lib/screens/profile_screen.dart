import 'package:experimental/screens/practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import '../widgets/navbar.dart';
import 'home_screen.dart';
import 'book_screen.dart';
import 'leaderboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const SizedBox(
                    height: 150,
                    width: 150,
                    child: RiveAnimation.asset(
                      'assets/images/personalised_character.riv',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Willy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Feather',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '@supremaczy • Bergabung Mei 2022',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Feather',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Kursus', '10', '+10'),
                      _buildStatColumn('Mengikuti', '84'),
                      _buildStatColumn('Pengikut', '41'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      label: const Text(
                        'TAMBAH TEMAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Feather',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ringkasan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Feather',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.2,
                    children: [
                      _buildOverviewCard(
                        Icons.local_fire_department,
                        'Rentetan Hari',
                        '0',
                      ),
                      _buildOverviewCard(Icons.star, 'Total XP', '17298'),
                      _buildOverviewCard(Icons.shield, 'Liga Saat Ini', 'Emas'),
                      _buildOverviewCard(
                        Icons.flag,
                        'Skor Bahasa Inggris',
                        '104',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lencana Bulanan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Feather',
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'LIHAT SEMUA',
                          style: TextStyle(
                            color: Color(0xFF5C6BC0),
                            fontFamily: 'Feather',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBadge(Icons.home),
                      _buildBadgeFromSvg('assets/navbar/mouth.svg'),
                      _buildBadge(Icons.fitness_center),
                      _buildBadge(Icons.emoji_events),
                      _buildBadge(Icons.person),
                    ],
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.black54, size: 30),
              onPressed: () {},
            ),
          ),
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
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const BookScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 2) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LeaderboardScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 3) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const PracticeScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, [String? subValue]) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Feather',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'Feather',
          ),
        ),
        if (subValue != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subValue,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontFamily: 'Feather',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOverviewCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5C6BC0), size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Feather',
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Feather',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey[200],
      child: Icon(icon, color: Colors.grey[600], size: 30),
    );
  }

  Widget _buildBadgeFromSvg(String assetName) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey[200],
      child: SvgPicture.asset(
        assetName,
        width: 30,
        height: 30,
        colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
      ),
    );
  }
}
