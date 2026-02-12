import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _showSplash = true;
  bool _isReturningUser = false;

  final _authCodeController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely read provider after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkReturningUser();
    });
    _showSplashScreen();
  }

  Future<void> _checkReturningUser() async {
    // We can access sharedPreferencesProvider synchronously because it's initialized in main
    final prefs = ref.read(sharedPreferencesProvider);
    final hasRegistered = prefs.getBool('user-registered') ?? false;
    setState(() {
      _isReturningUser = hasRegistered;
    });
  }

  void _showSplashScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  Future<void> _handleRegister() async {
    if (_authCodeController.text.isEmpty ||
        _loginController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showAlert('Proszę wypełnić wszystkie pola');
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            _loginController.text,
            _passwordController.text,
            'User', // Name placeholder
          );

      // Update UI state for returning user
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool('user-registered', true);

      widget.onLogin();
    } catch (e) {
      _showAlert('Błąd rejestracji: ${e.toString()}');
    }
  }

  Future<void> _handleLogin() async {
    if (_loginController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Proszę wypełnić wszystkie pola');
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .login(_loginController.text, _passwordController.text);
      widget.onLogin();
    } catch (e) {
      _showAlert('Błąd logowania: ${e.toString()}');
    }
  }

  void _showAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  void dispose() {
    _authCodeController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (_showSplash) {
      return _buildSplashScreen();
    }

    // Stack to show loading overlay
    return Stack(
      children: [
        if (!_isReturningUser)
          _buildRegistrationScreen()
        else
          _buildLoginScreen(),

        if (authState.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  // borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
                ),
                child: Icon(
                  Icons.psychology,
                  size: 120,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: AppTheme.spacingLg),
              Text(
                'BRAVES COG',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.spacingLg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                SizedBox(height: AppTheme.spacing2Xl),
                Text(
                  'BRAVES COG',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppTheme.spacing2Xl),
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    // borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rejestracja',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: AppTheme.spacingLg),
                      _buildTextField(
                        label: 'Kod autoryzacyjny',
                        controller: _authCodeController,
                        placeholder: 'Wprowadź kod',
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      _buildTextField(
                        label: 'Login',
                        controller: _loginController,
                        placeholder: 'Twój login',
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      _buildTextField(
                        label: 'Hasło',
                        controller: _passwordController,
                        placeholder: 'Twoje hasło',
                        isPassword: true,
                        // Note: To truly match design, we'd style TextField via InputDeco theme in AppTheme,
                        // but here passing isPassword affects obscureText only.
                      ),
                      SizedBox(height: AppTheme.spacingXl),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleRegister,
                          child: const Text('Zarejestruj się'),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isReturningUser = true;
                            });
                          },
                          child: const Text('Zaloguj się'),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      Center(
                        child: Text(
                          'Polityka Prywatności | Regulamin',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.spacingLg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                SizedBox(height: AppTheme.spacing2Xl),
                Text(
                  'BRAVES COG',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppTheme.spacing2Xl),
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    // borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Witaj Ponownie!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Zaloguj się, by rozwijać swój mózg',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppTheme.spacingLg),
                      _buildTextField(
                        label: 'Login',
                        controller: _loginController,
                        placeholder: 'Twój login',
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      _buildTextField(
                        label: 'Hasło',
                        controller: _passwordController,
                        placeholder: 'Twoje hasło',
                        isPassword: true,
                      ),
                      SizedBox(height: AppTheme.spacingXl),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('Zaloguj się'),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isReturningUser = false;
                            });
                          },
                          child: const Text('Zarejestruj się'),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      Center(
                        child: Text(
                          'Polityka Prywatności | Regulamin',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: AppTheme.spacingSm),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(hintText: placeholder),
        ),
      ],
    );
  }
}
