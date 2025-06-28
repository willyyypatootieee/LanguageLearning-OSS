import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/ipa_button.dart';
import '../../../shared/shared_exports.dart';

// Dummy IPA data singkat untuk vowels dan konsonan
final List<Map<String, String>> vowelIPA = [
  {'symbol': 'a', 'label': 'kucing', 'example': 'kucing'},
  {'symbol': 'i', 'label': 'ikan', 'example': 'ikan'},
  {'symbol': 'u', 'label': 'ular', 'example': 'ular'},
  {'symbol': 'e', 'label': 'elang', 'example': 'elang'},
  {'symbol': 'o', 'label': 'orang', 'example': 'orang'},
];

final List<Map<String, String>> consonantIPA = [
  {'symbol': 'k', 'label': 'kambing', 'example': 'kambing'},
  {'symbol': 'g', 'label': 'gajah', 'example': 'gajah'},
  {'symbol': 'm', 'label': 'monyet', 'example': 'monyet'},
  {'symbol': 'n', 'label': 'naga', 'example': 'naga'},
  {'symbol': 's', 'label': 'sapi', 'example': 'sapi'},
];

class IPAChartScreen extends StatelessWidget {
  const IPAChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.background,
      appBar: AppBar(
        title: const Text('IPA Chart'),
        backgroundColor: AppTheme.lightTheme.colorScheme.background,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 120,
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
        onTap:
            (index) => context.go(
              index == 0
                  ? '/home'
                  : index == 1
                  ? '/dictionary'
                  : index == 2
                  ? '/practice'
                  : index == 3
                  ? '/leaderboard'
                  : '/profile',
            ),
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
