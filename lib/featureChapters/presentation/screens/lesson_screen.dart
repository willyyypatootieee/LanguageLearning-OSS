import 'package:flutter/material.dart';
import '../../../core/health_api_service.dart';
import '../../../featureChapters/domain/models/chapter.dart';
import '../../../featureChapters/data/datasources/chapter_remote_datasource.dart';
import '../widgets/user_stats_bar.dart';
import '../widgets/tts_waveform_button.dart';
import '../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../../featureAuthentication/data/datasources/auth_remote_datasource.dart';
import '../../../featureAuthentication/data/repositories/auth_repository_impl.dart';

/// Comprehensive lesson screen with Duolingo-style UI
class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Chapter chapter;

  const LessonScreen({super.key, required this.lesson, required this.chapter});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final ChapterRemoteDataSource _dataSource = ChapterRemoteDataSource();
  String? _userId;
  int _currentQuestionIndex = 0;
  List<Question> _questions = [];
  List<Choice> _currentChoices = [];
  String? _selectedAnswer;
  bool _isAnswerSubmitted = false;
  bool _isCorrect = false;
  int _score = 0;
  int _totalQuestions = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _loadQuestions();
  }

  Future<void> _fetchUserId() async {
    final authRepo = AuthRepositoryImpl(
      AuthRemoteDataSource(),
      AuthLocalDataSource(),
    );
    final user = await authRepo.getCurrentUser();
    setState(() {
      _userId = user?.id;
    });
  }

  Future<void> _loadQuestions() async {
    try {
      if (widget.lesson.questions != null &&
          widget.lesson.questions!.isNotEmpty) {
        _questions = widget.lesson.questions!;
        _totalQuestions = _questions.length;
        await _loadCurrentQuestionChoices();
      }
    } catch (e) {
      // Handle error
      print('Error loading questions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCurrentQuestionChoices() async {
    if (_currentQuestionIndex < _questions.length) {
      final currentQuestion = _questions[_currentQuestionIndex];
      try {
        // First check if choices are already included in the question
        if (currentQuestion.choices != null &&
            currentQuestion.choices!.isNotEmpty) {
          setState(() {
            _currentChoices = currentQuestion.choices!;
          });
        } else {
          // If not, fetch them separately
          final choices = await _dataSource.getQuestionChoices(
            currentQuestion.id,
          );
          setState(() {
            _currentChoices = choices;
          });
        }
      } catch (e) {
        print('Error loading choices: $e');
        setState(() {
          _currentChoices = [];
        });
      }
    }
  }

  void _selectAnswer(String answer) {
    if (!_isAnswerSubmitted) {
      setState(() {
        _selectedAnswer = answer;
      });
    }
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswer == null) return;

    final correctChoice = _currentChoices.firstWhere(
      (choice) => choice.isCorrect,
      orElse: () => _currentChoices.first,
    );

    final isCorrect = _selectedAnswer == correctChoice.text;

    try {
      await _dataSource.submitAnswer(
        questionId: _questions[_currentQuestionIndex].id,
        userAnswer: _selectedAnswer!,
        isCorrect: isCorrect,
      );
    } catch (e) {
      print('Error submitting answer: $e');
    }

    setState(() {
      _isAnswerSubmitted = true;
      _isCorrect = isCorrect;
      if (isCorrect) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswerSubmitted = false;
        _isCorrect = false;
      });
      _loadCurrentQuestionChoices();
    } else {
      _showLessonComplete();
    }
  }

  void _showLessonComplete() {
    if (_userId == null) {
      // Optionally show error or wait
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => LessonCompleteDialog(
            score: _score,
            totalQuestions: _totalQuestions,
            xpReward: widget.lesson.xpReward,
            lesson: widget.lesson,
            chapterId: widget.chapter.id,
            userId: _userId!,
            dataSource: _dataSource,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Lesson'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Tidak ada pertanyaan tersedia')),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _totalQuestions;

    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Column(
        children: [
          // App bar with progress
          Container(
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // Lesson content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question type indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      currentQuestion.questionType.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Question text
                  Text(
                    currentQuestion.questionText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Choices
                  Expanded(
                    child: ListView.builder(
                      itemCount: _currentChoices.length,
                      itemBuilder: (context, index) {
                        final choice = _currentChoices[index];
                        final isSelected = _selectedAnswer == choice.text;
                        Color? backgroundColor;
                        Color? borderColor;

                        if (_isAnswerSubmitted) {
                          if (choice.isCorrect) {
                            backgroundColor = Colors.green[50];
                            borderColor = Colors.green;
                          } else if (isSelected && !choice.isCorrect) {
                            backgroundColor = Colors.red[50];
                            borderColor = Colors.red;
                          } else {
                            backgroundColor = Colors.grey[100];
                            borderColor = Colors.grey[300];
                          }
                        } else if (isSelected) {
                          backgroundColor = Colors.blue[50];
                          borderColor = Colors.blue;
                        } else {
                          backgroundColor = Colors.grey[50];
                          borderColor = Colors.grey[300];
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: TTSWaveformButton(
                            text: choice.text,
                            isSelected: isSelected,
                            backgroundColor: backgroundColor,
                            borderColor: borderColor,
                            onTap: () => _selectAnswer(choice.text),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom button
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed:
                            _selectedAnswer != null
                                ? (_isAnswerSubmitted
                                    ? _nextQuestion
                                    : _submitAnswer)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isAnswerSubmitted
                                  ? (_isCorrect ? Colors.green : Colors.orange)
                                  : Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isAnswerSubmitted
                              ? (_currentQuestionIndex < _questions.length - 1
                                  ? 'LANJUT'
                                  : 'SELESAI')
                              : 'CEK JAWABAN',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }
}

/// Custom dialog for lesson completion with XP and coins
class LessonCompleteDialog extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int xpReward;
  final Lesson lesson;
  final String chapterId;
  final String userId;
  final ChapterRemoteDataSource dataSource;

  const LessonCompleteDialog({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.xpReward,
    required this.lesson,
    required this.chapterId,
    required this.userId,
    required this.dataSource,
  });

  @override
  State<LessonCompleteDialog> createState() => _LessonCompleteDialogState();
}

class _LessonCompleteDialogState extends State<LessonCompleteDialog>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  int _coinsEarned = 0;
  int _finalXp = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _saveProgress();
    _animationController.forward();
  }

  Future<void> _saveProgress() async {
    try {
      final healthApi = HealthApiService(
        baseUrl: 'https://beling-4ef8e653eda6.herokuapp.com',
        adminSecret: 'bellingadmin',
      );
      final result = await healthApi.awardCoinsXPAndHealth(
        userId: widget.userId,
        chapterId: widget.chapterId,
        correctAnswers: widget.score,
        totalQuestions: widget.totalQuestions,
      );
      final data = result['data'] ?? {};
      _coinsEarned = data['coinsEarned'] ?? widget.score;
      _finalXp = data['total_xp'] ?? widget.xpReward;
      // Update user stats in app state/UI if needed
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error saving progress: $e');
      setState(() {
        _isLoading = false;
        _finalXp = widget.xpReward;
        _coinsEarned = widget.score;
      });
    }
  }

  void _updateUserStats() async {
    try {
      // Optionally, update the user's profile in the backend after awarding coins/xp/health
      // You can call the PUT /api/users/{id} endpoint here if you want to refresh the user's stats in the app
      // For now, just pop the dialog and refresh the UI if needed
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pop(); // Go back to lesson list
      // Optionally, trigger a refresh of user stats bar or global state here
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration icon
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Lesson Selesai!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Score
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Skor Anda',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.score}/${widget.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rewards
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Menyimpan progress...'),
                ],
              )
            else
              Row(
                children: [
                  // XP Reward
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.star, color: Colors.blue[700], size: 24),
                          const SizedBox(height: 8),
                          Text(
                            '+$_finalXp XP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Coins Reward
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.amber[700],
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '+$_coinsEarned Coins',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateUserStats,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Menyimpan...' : 'Lanjutkan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
