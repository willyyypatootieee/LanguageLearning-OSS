/// Chapter API constants
class ChapterConstants {
  // Private constructor to prevent instantiation
  ChapterConstants._();

  // API endpoints
  static const String baseUrl = 'https://beling-4ef8e653eda6.herokuapp.com';
  static const String chaptersEndpoint = '/api/chapters';
  static const String lessonsEndpoint = '/api/lessons';
  static const String questionsEndpoint = '/api/questions';
  static const String progressEndpoint = '/api/progress';

  // Build specific endpoints
  static String getChapterEndpoint(String chapterId) =>
      '$chaptersEndpoint/$chapterId';
  static String getLessonEndpoint(String lessonId) =>
      '$lessonsEndpoint/$lessonId';
  static String getQuestionDetailEndpoint(String questionId) =>
      '$questionsEndpoint/$questionId/detail';
  static String getQuestionChoicesEndpoint(String questionId) =>
      '$questionsEndpoint/$questionId/choices';
  static String completeLessonEndpoint(String lessonId) =>
      '$progressEndpoint/complete-lesson/$lessonId';
  static String submitAnswerEndpoint() => '$progressEndpoint/submit-answer';
  static String updateUserXpEndpoint() => '$progressEndpoint/update-xp';
  static String getUserProgressEndpoint() => '$progressEndpoint/user';
  static String addUserCoinsEndpoint() => '$progressEndpoint/add-coins';

  // Headers
  static const String adminSecret = 'bellingadmin';
  static const String contentType = 'application/json';
  static const String accept = 'application/json';

  // Cache keys
  static const String chaptersKey = 'cached_chapters';
  static const String chaptersTimestampKey = 'chapters_timestamp';

  // Cache duration (in hours)
  static const int cacheValidityHours = 6;

  // Error messages
  static const String chaptersNotFoundError = 'Chapters not found';
  static const String lessonNotFoundError = 'Lesson not found';
  static const String questionNotFoundError = 'Question not found';
  static const String networkError = 'Network error occurred';
  static const String fetchFailedError = 'Failed to fetch data';
}
