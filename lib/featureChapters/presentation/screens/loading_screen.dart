import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import '../../../featureChapters/data/datasources/chapter_remote_datasource.dart';
import 'chapter_selection_screen.dart';

/// Loading screen with cat animation while fetching chapters
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final ChapterRemoteDataSource _dataSource = ChapterRemoteDataSource();
  bool _isLoading = true;
  String _loadingText = 'Memuat chapter...';

  @override
  void initState() {
    super.initState();
    _fetchChaptersAndNavigate();
  }

  Future<void> _fetchChaptersAndNavigate() async {
    try {
      setState(() {
        _loadingText = 'Memuat chapter...';
      });

      // Add a minimum loading time for better UX
      await Future.delayed(const Duration(milliseconds: 1500));

      // Fetch chapters from API
      final chapters = await _dataSource.getChapters();

      if (chapters.isNotEmpty) {
        setState(() {
          _loadingText = 'Chapter berhasil dimuat!';
        });

        await Future.delayed(const Duration(milliseconds: 800));

        setState(() {
          _loadingText = 'Selesai! Masuk ke daftar chapter...';
        });

        await Future.delayed(const Duration(milliseconds: 500));

        // Navigate to chapter selection screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ChapterSelectionScreen(chapters: chapters),
            ),
          );
        }
      } else {
        _showError('Tidak ada chapter tersedia');
      }
    } catch (e) {
      _showError('Gagal memuat data: ${e.toString()}');
    }
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
      _loadingText = message;
    });

    // Go back to home after showing error
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'BeLing',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Belajar Bahasa Inggris',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 60),

              // Cat animation
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const RiveAnimation.asset(
                    'assets/animation/bear.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Loading indicator
              if (_isLoading) ...[
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Loading text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _loadingText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isLoading ? Colors.grey[700] : Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
