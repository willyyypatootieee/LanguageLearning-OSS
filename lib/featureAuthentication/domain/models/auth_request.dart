/// Authentication request model for login
class LoginRequest {
  final String? email;
  final String? username;
  final String password;

  const LoginRequest({this.email, this.username, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'password': password};

    if (email != null) {
      json['email'] = email;
    }

    if (username != null) {
      json['username'] = username;
    }

    return json;
  }

  LoginRequest copyWith({String? email, String? username, String? password}) {
    return LoginRequest(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

/// Authentication request model for registration
class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String birthDate;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'birthDate': birthDate,
    };
  }

  RegisterRequest copyWith({
    String? username,
    String? email,
    String? password,
    String? birthDate,
  }) {
    return RegisterRequest(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
