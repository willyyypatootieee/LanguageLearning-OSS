/// Chapter model representing a learning chapter
class Chapter {
  final String id;
  final String title;
  final String description;
  final int order;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String? themeColor;
  final int? unlockXp;
  final String? imageUrl;
  final List<Lesson>? lessons;

  const Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.createdAt,
    this.deletedAt,
    this.themeColor,
    this.unlockXp,
    this.imageUrl,
    this.lessons,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
      // These fields might not be present in the basic chapters endpoint
      themeColor:
          json.containsKey('theme_color')
              ? json['theme_color'] as String?
              : null,
      unlockXp:
          json.containsKey('unlock_xp') ? json['unlock_xp'] as int? : null,
      imageUrl:
          json.containsKey('image_url') ? json['image_url'] as String? : null,
      lessons:
          json.containsKey('lessons') && json['lessons'] != null
              ? (json['lessons'] as List<dynamic>)
                  .map(
                    (lesson) => Lesson.fromJson(lesson as Map<String, dynamic>),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
      if (themeColor != null) 'theme_color': themeColor,
      if (unlockXp != null) 'unlock_xp': unlockXp,
      if (imageUrl != null) 'image_url': imageUrl,
      if (lessons != null)
        'lessons': lessons!.map((lesson) => lesson.toJson()).toList(),
    };
  }

  Chapter copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    DateTime? createdAt,
    DateTime? deletedAt,
    String? themeColor,
    int? unlockXp,
    String? imageUrl,
    List<Lesson>? lessons,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      themeColor: themeColor ?? this.themeColor,
      unlockXp: unlockXp ?? this.unlockXp,
      imageUrl: imageUrl ?? this.imageUrl,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.order == order &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt &&
        other.themeColor == themeColor &&
        other.unlockXp == unlockXp &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      order,
      createdAt,
      deletedAt,
      themeColor,
      unlockXp,
      imageUrl,
    );
  }

  @override
  String toString() {
    return 'Chapter(id: $id, title: $title, description: $description, order: $order, createdAt: $createdAt, lessonsCount: ${lessons?.length})';
  }
}

/// Lesson model representing a lesson within a chapter
class Lesson {
  final String id;
  final String title;
  final String description;
  final int order;
  final int xpReward;
  final DateTime createdAt;
  final List<Question>? questions;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.xpReward,
    required this.createdAt,
    this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      xpReward: json['xp_reward'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      questions:
          json.containsKey('questions') && json['questions'] != null
              ? (json['questions'] as List<dynamic>)
                  .map(
                    (question) =>
                        Question.fromJson(question as Map<String, dynamic>),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'xp_reward': xpReward,
      'created_at': createdAt.toIso8601String(),
      if (questions != null)
        'questions': questions!.map((q) => q.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, order: $order, xpReward: $xpReward, questionsCount: ${questions?.length})';
  }
}

/// Question model representing a question within a lesson
class Question {
  final String id;
  final String questionText;
  final int order;
  final DateTime createdAt;
  final QuestionType questionType;
  final String? correctAnswer;
  final List<Choice>? choices;

  const Question({
    required this.id,
    required this.questionText,
    required this.order,
    required this.createdAt,
    required this.questionType,
    this.correctAnswer,
    this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      questionText: json['question_text'] as String,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      questionType: QuestionType.fromJson(
        json['question_type'] as Map<String, dynamic>,
      ),
      correctAnswer:
          json.containsKey('correct_ans')
              ? json['correct_ans'] as String?
              : null,
      choices:
          json.containsKey('choices') && json['choices'] != null
              ? (json['choices'] as List<dynamic>)
                  .map(
                    (choice) => Choice.fromJson(choice as Map<String, dynamic>),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'question_type': questionType.toJson(),
      if (correctAnswer != null) 'correct_ans': correctAnswer,
      if (choices != null) 'choices': choices!.map((c) => c.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Question(id: $id, questionText: $questionText, order: $order, type: ${questionType.name})';
  }
}

/// Question type model
class QuestionType {
  final String id;
  final String name;
  final String description;

  const QuestionType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory QuestionType.fromJson(Map<String, dynamic> json) {
    return QuestionType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  @override
  String toString() {
    return 'QuestionType(id: $id, name: $name, description: $description)';
  }
}

/// Choice model for multiple choice questions
class Choice {
  final String id;
  final String label;
  final String text;
  final bool isCorrect;
  final String? explanation;

  const Choice({
    required this.id,
    required this.label,
    required this.text,
    required this.isCorrect,
    this.explanation,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String,
      label: json['label'] as String,
      text: json['text'] as String,
      isCorrect: json['is_correct'] == true || json['is_correct'] == 'true',
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'text': text,
      'is_correct': isCorrect,
      if (explanation != null) 'explanation': explanation,
    };
  }

  @override
  String toString() {
    return 'Choice(id: $id, label: $label, text: $text, isCorrect: $isCorrect)';
  }
}
