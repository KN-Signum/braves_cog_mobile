import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final _authCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  bool _showActivation = true; // Toggle between activation and login

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleActivateUser() async {
    if (_authCodeController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Proszę wypełnić wszystkie pola');
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .activateUser(
            _authCodeController.text.trim(),
            _passwordController.text,
          );

      // Check if activation was successful
      final authState = ref.read(authProvider);
      if (authState.error != null) {
        _showAlert(authState.error ?? 'Błąd aktywacji');
        return;
      }

      if (authState.isAuthenticated) {
        final prefs = ref.read(sharedPreferencesProvider);
        await prefs.setBool('user-registered', true);
        widget.onLogin();
      }
    } catch (e) {
      _showAlert('Błąd aktywacji: ${e.toString()}');
    }
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty ||
        _loginPasswordController.text.isEmpty) {
      _showAlert('Proszę wypełnić wszystkie pola');
      return;
    }

    try {
      // For standard login, we'll use the activation mechanism with email directly
      final email = _emailController.text.trim();
      final password = _loginPasswordController.text;

      // Try to extract code from email or use email directly
      String codeToUse = email;
      if (email.contains('@')) {
        // If it's already an email format, try to use it as-is
        codeToUse = email;
      }

      await ref.read(authProvider.notifier).activateUser(codeToUse, password);

      // Check if login was successful
      final authState = ref.read(authProvider);
      if (authState.error != null) {
        _showAlert(authState.error ?? 'Błąd logowania');
        return;
      }

      if (authState.isAuthenticated) {
        final prefs = ref.read(sharedPreferencesProvider);
        await prefs.setBool('user-registered', true);
        widget.onLogin();
      }
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
    _passwordController.dispose();
    _emailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Stack to show loading overlay
    return Stack(
      children: [
        _showActivation ? _buildActivationScreen() : _buildLoginScreen(),
        if (authState.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildActivationScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.spacingLg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                SizedBox(height: AppTheme.spacingXl),
                Image.asset(
                  'assets/images/braves-title.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: AppTheme.spacingXl),
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Aktywuj Konto',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Wprowadź kod zaproszenia i hasło',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppTheme.spacingLg),
                      _buildTextField(
                        label: 'Kod zaproszenia',
                        controller: _authCodeController,
                        placeholder: 'Wprowadź kod',
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      _buildTextField(
                        label: 'Hasło',
                        controller: _passwordController,
                        placeholder: 'Wprowadź hasło',
                        isPassword: true,
                      ),
                      SizedBox(height: AppTheme.spacingXl),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleActivateUser,
                          child: const Text('Aktywuj Konto'),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      TextButton(
                        onPressed: () {
                          setState(() => _showActivation = false);
                        },
                        child: Text(
                          'Masz już konto? Zaloguj się',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            final Uri url = Uri.parse(
                              'https://bravescog.pwr.edu.pl/polityka-prywatnosci/',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Text(
                            'Polityka Prywatności',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                            textAlign: TextAlign.center,
                          ),
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
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                SizedBox(height: AppTheme.spacingXl),
                Image.asset(
                  'assets/images/braves-title.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: AppTheme.spacingXl),
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Zaloguj się',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Wprowadź email i hasło',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppTheme.spacingLg),
                      _buildTextField(
                        label: 'Email',
                        controller: _emailController,
                        placeholder: 'Wprowadź email',
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      _buildTextField(
                        label: 'Hasło',
                        controller: _loginPasswordController,
                        placeholder: 'Wprowadź hasło',
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
                      TextButton(
                        onPressed: () {
                          setState(() => _showActivation = true);
                        },
                        child: Text(
                          'Nie masz konta? Aktywuj zaproszenie',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingMd),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            final Uri url = Uri.parse(
                              'https://bravescog.pwr.edu.pl/polityka-prywatnosci/',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Text(
                            'Polityka Prywatności',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                            textAlign: TextAlign.center,
                          ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDarkMode
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode
        ? const Color(0xFFB0B8C1)
        : const Color(0xFF6B7280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: AppTheme.spacingSm),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF9CA3AF),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF9CA3AF),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
            hintStyle: TextStyle(color: hintColor, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
