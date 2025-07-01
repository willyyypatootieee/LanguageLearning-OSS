import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/ipa_button.dart';
import '../../../shared/shared_exports.dart';
import '../../../router/router_exports.dart';

// IPA Vowels (matching screenshot)
final List<Map<String, String>> vowelIPA = [
  {'symbol': 'i', 'label': 'minim', 'example': 'sheep'},
  {'symbol': 'ɪ', 'label': 'tipis', 'example': 'ship'},
  {'symbol': 'e', 'label': 'es', 'example': 'bed'},
  {'symbol': 'æ', 'label': 'emas', 'example': 'cat'},
  {'symbol': 'ʌ', 'label': 'abang', 'example': 'cup'},
  {'symbol': 'ɑ', 'label': 'ayah', 'example': 'car'},
  {'symbol': 'ɒ', 'label': 'obat', 'example': 'hot'},
  {'symbol': 'ɔ', 'label': 'obrol', 'example': 'law'},
  {'symbol': 'ʊ', 'label': 'ular', 'example': 'put'},
  {'symbol': 'u', 'label': 'urut', 'example': 'boot'},
  {'symbol': 'ə', 'label': 'sebentar', 'example': 'about'},
];

// IPA Consonants (matching screenshot)
final List<Map<String, String>> consonantIPA = [
  {'symbol': 'p', 'label': 'pintu', 'example': 'pen'},
  {'symbol': 'b', 'label': 'bola', 'example': 'bat'},
  {'symbol': 't', 'label': 'topi', 'example': 'ten'},
  {'symbol': 'd', 'label': 'dompet', 'example': 'dog'},
  {'symbol': 'k', 'label': 'kaki', 'example': 'cat'},
  {'symbol': 'g', 'label': 'gigi', 'example': 'go'},
  {'symbol': 'f', 'label': 'fokus', 'example': 'fish'},
  {'symbol': 'v', 'label': 'vas', 'example': 'van'},
  {'symbol': 's', 'label': 'sapi', 'example': 'sun'},
  {'symbol': 'z', 'label': 'zebra', 'example': 'zoo'},
  {'symbol': 'm', 'label': 'mata', 'example': 'man'},
  {'symbol': 'n', 'label': 'nasi', 'example': 'net'},
];

class IPAChartScreen extends StatelessWidget {
  const IPAChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor:
          AppColors.gray50, // Use the same background as other screens
      appBar: AppBar(
        title: const Text('IPA Chart'),
        backgroundColor: Colors.white.withValues(
          alpha: 0.9,
        ), // Semi-transparent white
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Container(
        color: Colors.white.withOpacity(0.5), // Semi-transparent white overlay
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 120, // Increased bottom padding for floating navbar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vowels',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _buildIPASection(vowelIPA),
              const SizedBox(height: 32),
              Text(
                'Consonants',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _buildIPASection(consonantIPA),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              appRouter.goToHome();
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Practice feature coming soon!')),
              );
              break;
            case 3:
              appRouter.goToLeaderboard();
              break;
            case 4:
              appRouter.goToProfile();
              break;
          }
        },
      ),
    );
  }

  Widget _buildIPASection(List<Map<String, String>> ipaList) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          ipaList
              .map(
                (ipa) => IPASymbolButton(
                  symbol: ipa['symbol']!,
                  label: ipa['label']!,
                  example: ipa['example']!,
                ),
              )
              .toList(),
    );
  }
}
