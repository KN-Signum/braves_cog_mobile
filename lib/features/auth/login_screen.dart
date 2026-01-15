import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'dart:convert';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogin;
  
  const LoginScreen({
    super.key,
    required this.onLogin,
  });

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
    _checkReturningUser();
    _showSplashScreen();
  }

  Future<void> _checkReturningUser() async {
    final prefs = await SharedPreferences.getInstance();
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user-registered', true);
    await prefs.setString('user-credentials', jsonEncode({
      'login': _loginController.text,
      'password': _passwordController.text,
    }));
    
    widget.onLogin();
  }

  Future<void> _handleLogin() async {
    if (_loginController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Proszę wypełnić wszystkie pola');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user-credentials', jsonEncode({
      'login': _loginController.text,
      'password': _passwordController.text,
    }));
    await prefs.setBool('user-registered', true);
    
    widget.onLogin();
  }

  void _showAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.inverseTextColor,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
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
    if (_showSplash) {
      return _buildSplashScreen();
    }

    if (!_isReturningUser) {
      return _buildRegistrationScreen();
    }

    return _buildLoginScreen();
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: AppTheme.lightBackgroundColor,
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
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
                ),
                child: Icon(
                  Icons.psychology,
                  size: 120,
                  color: AppTheme.accentColor,
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
      backgroundColor: AppTheme.backgroundColor,
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
                    color: AppTheme.lightBackgroundColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentColor,
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
      backgroundColor: AppTheme.backgroundColor,
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
                    color: AppTheme.lightBackgroundColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
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
                          color: AppTheme.primaryColor.withOpacity(0.7),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentColor,
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
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: AppTheme.spacingSm),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: placeholder,
          ),
        ),
      ],
    );
  }
}
