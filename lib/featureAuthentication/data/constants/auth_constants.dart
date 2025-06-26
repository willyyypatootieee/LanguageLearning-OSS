/// Authentication constants
class AuthConstants {
  // Private constructor to prevent instantiation
  AuthConstants._();
  // API endpoints
  static const String baseUrl = 'http://beling-4ef8e653eda6.herokuapp.com';
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String adminCheckEndpoint = '/api/auth/admin-check';

  // Admin secret
  static const String adminSecret = 'bellingadmin';

  // Local storage keys
  static const String userKey = 'auth_user';
  static const String tokenKey = 'auth_token';
  static const String isLoggedInKey = 'is_logged_in';

  // UI constants
  static const double borderRadius = 12.0;
  static const double inputHeight = 56.0;
  static const double buttonHeight = 56.0;

  // Validation patterns
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp usernamePattern = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  // Error messages
  static const String emailRequiredError = 'Email is required';
  static const String emailInvalidError = 'Please enter a valid email';
  static const String usernameRequiredError = 'Username is required';
  static const String usernameInvalidError =
      'Username must be 3-20 characters, letters, numbers and underscore only';
  static const String passwordRequiredError = 'Password is required';
  static const String passwordTooShortError =
      'Password must be at least 6 characters';
  static const String birthDateRequiredError = 'Birth date is required';

  // Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String registerSuccessMessage = 'Registration successful!';
}
