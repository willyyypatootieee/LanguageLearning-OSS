import 'package:flutter/material.dart';
import '../../../featureChapters/domain/models/chapter.dart';
import '../../../featureChapters/data/datasources/chapter_remote_datasource.dart';
import 'lesson_screen.dart';

/// Screen to show lessons in a selected chapter
class LessonListScreen extends StatefulWidget {
  final Chapter chapter;

  const LessonListScreen({super.key, required this.chapter});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  final ChapterRemoteDataSource _dataSource = ChapterRemoteDataSource();
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get chapter details with lessons
      final chapterWithLessons = await _dataSource.getChapterById(
        widget.chapter.id,
      );

      if (chapterWithLessons != null && chapterWithLessons.lessons != null) {
        setState(() {
          _lessons = chapterWithLessons.lessons!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _lessons = [];
          _isLoading = false;
          _errorMessage = 'Tidak ada lesson tersedia dalam chapter ini';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat lesson: ${e.toString()}';
      });
    }
  }

  Future<void> _startLesson(Lesson lesson) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mempersiapkan lesson...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
      );

      // Try to get lesson with questions
      Lesson? lessonWithQuestions;
      try {
        lessonWithQuestions = await _dataSource.getLessonById(lesson.id);
      } catch (e) {
        print('Failed to fetch lesson details: $e');
        // Use the original lesson as fallback
        lessonWithQuestions = lesson;
      }

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Use the lesson data we have (either fetched or original)
      final lessonToUse = lessonWithQuestions ?? lesson;

      if (lessonToUse.questions != null && lessonToUse.questions!.isNotEmpty) {
        // Navigate to lesson screen
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => LessonScreen(
                    lesson: lessonToUse,
                    chapter: widget.chapter,
                  ),
            ),
          );
        }
      } else {
        // Try to create a demo lesson with placeholder questions for testing
        final demoLesson = _createDemoLesson(lesson);
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      LessonScreen(lesson: demoLesson, chapter: widget.chapter),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat lesson: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Create a demo lesson with sample questions for testing
  Lesson _createDemoLesson(Lesson originalLesson) {
    final demoQuestions = [
      Question(
        id: 'demo_q1',
        questionText: 'Hello! How do you say "Good morning" in English?',
        order: 1,
        createdAt: DateTime.now(),
        questionType: QuestionType(
          id: 'multiple_choice',
          name: 'Multiple Choice',
          description: 'Choose the correct answer',
        ),
        correctAnswer: 'Good morning',
        choices: [
          Choice(id: 'c1', label: 'A', text: 'Good morning', isCorrect: true),
          Choice(id: 'c2', label: 'B', text: 'Good evening', isCorrect: false),
          Choice(id: 'c3', label: 'C', text: 'Good night', isCorrect: false),
        ],
      ),
      Question(
        id: 'demo_q2',
        questionText: 'Which phrase means "How are you?" in English?',
        order: 2,
        createdAt: DateTime.now(),
        questionType: QuestionType(
          id: 'multiple_choice',
          name: 'Multiple Choice',
          description: 'Choose the correct answer',
        ),
        correctAnswer: 'How are you?',
        choices: [
          Choice(
            id: 'c4',
            label: 'A',
            text: 'What is your name?',
            isCorrect: false,
          ),
          Choice(id: 'c5', label: 'B', text: 'How are you?', isCorrect: true),
          Choice(
            id: 'c6',
            label: 'C',
            text: 'Where are you from?',
            isCorrect: false,
          ),
        ],
      ),
    ];

    return Lesson(
      id: originalLesson.id,
      title: originalLesson.title,
      description: originalLesson.description,
      order: originalLesson.order,
      xpReward: originalLesson.xpReward,
      createdAt: originalLesson.createdAt,
      questions: demoQuestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Column(
        children: [
          // User stats bar at the top

          // App bar
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        widget.chapter.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Memuat lessons...'),
                        ],
                      ),
                    )
                    : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadLessons,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chapter description
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.chapter.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tersedia ${_lessons.length} lesson',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Lessons list
                          Text(
                            'Lessons:',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Expanded(
                            child:
                                _lessons.isEmpty
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.school_outlined,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Belum ada lesson tersedia',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : ListView.builder(
                                      itemCount: _lessons.length,
                                      itemBuilder: (context, index) {
                                        final lesson = _lessons[index];
                                        return Card(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: ListTile(
                                            leading: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${lesson.order}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              lesson.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  lesson.description,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 16,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${lesson.xpReward} XP',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.amber[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            trailing: const Icon(
                                              Icons.play_arrow,
                                            ),
                                            onTap: () => _startLesson(lesson),
                                          ),
                                        );
                                      },
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
