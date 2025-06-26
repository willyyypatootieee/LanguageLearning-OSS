import 'user.dart';

/// Authentication response model
class AuthResponse {
  final bool success;
  final String message;
  final User? user;
  final String? token;

  const AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      user:
          json['data']?['user'] != null
              ? User.fromJson(json['data']['user'])
              : null,
      token: json['data']?['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        if (user != null) 'user': user!.toJson(),
        if (token != null) 'token': token,
      },
    };
  }

  AuthResponse copyWith({
    bool? success,
    String? message,
    User? user,
    String? token,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}
