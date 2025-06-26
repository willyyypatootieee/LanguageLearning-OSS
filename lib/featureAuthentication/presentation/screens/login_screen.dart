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

/// Login screen with email/username and password fields
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isEmailMode = true;
  String? _errorMessage;
  
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
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loginRequest = LoginRequest(
        email: _isEmailMode ? _loginController.text.trim() : null,
        username: !_isEmailMode ? _loginController.text.trim() : null,
        password: _passwordController.text,
      );

      final response = await _authRepository.login(loginRequest);

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

  void _toggleLoginMode() {
    setState(() {
      _isEmailMode = !_isEmailMode;
      _loginController.clear();
    });
  }

  void _goToRegister() => appRouter.go('/register');

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot password feature coming soon!')),
    );
  }

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
                  title: 'Ayo lanjutkan ke akunmu!',
                  subtitle: 'BeLing Login Akun',
                ),
                
                AuthLoginOption(
                  isEmailMode: _isEmailMode,
                  onToggle: _toggleLoginMode,
                  controller: _loginController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _isEmailMode 
                        ? AuthConstants.emailRequiredError
                        : AuthConstants.usernameRequiredError;
                    }
                    if (_isEmailMode && !AuthConstants.emailPattern.hasMatch(value)) {
                      return AuthConstants.emailInvalidError;
                    }
                    if (!_isEmailMode && !AuthConstants.usernamePattern.hasMatch(value)) {
                      return AuthConstants.usernameInvalidError;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppConstants.spacingL),
                
                AuthInputField(
                  controller: _passwordController,
                  labelText: 'Kata Sandi',
                  hintText: 'Masukkan Kata Sandi',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
                    return null;
                  },
                ),
                
                const SizedBox(height: AppConstants.spacingM),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingL),
                
                AuthErrorMessage(errorMessage: _errorMessage),
                
                AuthButton(
                  onPressed: _isLoading ? null : _login,
                  isLoading: _isLoading,
                  text: 'Masuk',
                ),
                
                const SizedBox(height: AppConstants.spacingL),
                const AuthDivider(text: 'Atau Login Dengan'),
                const SizedBox(height: AppConstants.spacingL),
                const AuthSocialButtons(),
                const SizedBox(height: AppConstants.spacingXxl),
                
                AuthFooterText(
                  text: 'Belum memiliki akun? ',
                  linkText: 'Daftar',
                  onLinkTap: _goToRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
