import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../../data/constants/auth_constants.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/auth_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../widgets/widgets.dart';

/// Register screen with username, email, password, and birth date fields
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  DateTime? _selectedBirthDate;

  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(
      AuthRemoteDataSource(),
      AuthLocalDataSource(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBirthDate == null) {
      setState(() {
        _errorMessage = AuthConstants.birthDateRequiredError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final registerRequest = RegisterRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        birthDate:
            _selectedBirthDate!.toIso8601String().split(
              'T',
            )[0], // YYYY-MM-DD format
      );

      final response = await _authRepository.register(registerRequest);

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: AppColors.success,
            ),
          );
          appRouter.goToHome();
        } else {
          setState(() {
            _errorMessage = response.message;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToLogin() => appRouter.go('/login');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthFormHeader(
                  title: 'Daftar akun baru.',
                  subtitle: 'BeLing Daftar akun',
                ),

                AuthInputField(
                  controller: _emailController,
                  labelText: 'Alamat Email',
                  hintText: 'Masukkan Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AuthConstants.emailRequiredError;
                    }
                    if (!AuthConstants.emailPattern.hasMatch(value)) {
                      return AuthConstants.emailInvalidError;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingL),

                AuthInputField(
                  controller: _usernameController,
                  labelText: 'Nama Pengguna',
                  hintText: 'Masukkan Nama Pengguna',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AuthConstants.usernameRequiredError;
                    }
                    if (!AuthConstants.usernamePattern.hasMatch(value)) {
                      return AuthConstants.usernameInvalidError;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingL),

                AuthInputField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Masukkan Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.gray400,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AuthConstants.passwordRequiredError;
                    }
                    if (value.length < 6) {
                      return AuthConstants.passwordTooShortError;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingL),

                AuthDatePicker(
                  labelText: 'Tanggal Lahir',
                  selectedDate: _selectedBirthDate,
                  onTap: _selectBirthDate,
                  hintText: 'Pilih tanggal lahir',
                ),

                const SizedBox(height: AppConstants.spacingL),

                AuthErrorMessage(errorMessage: _errorMessage),

                AuthButton(
                  onPressed: _isLoading ? null : _register,
                  isLoading: _isLoading,
                  text: 'Daftar',
                ),

                const SizedBox(height: AppConstants.spacingL),
                const AuthDivider(text: 'Atau Login Dengan'),
                const SizedBox(height: AppConstants.spacingL),
                const AuthSocialButtons(),
                const SizedBox(height: AppConstants.spacingXxl),

                AuthFooterText(
                  text: 'Sudah memiliki akun? ',
                  linkText: 'Masuk',
                  onLinkTap: _goToLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
