import 'package:flutter/material.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/views/widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController(text: 'demo');
  final TextEditingController _password = TextEditingController(text: 'demo');
  static const String _confirmUsername = 'demo';
  static const String _confirmPassword = 'demo';

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Welcome back',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue to Budget Tracker',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter username',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: KConstants.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _onLoginPressed,
                  child: Text(widget.title),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (_username.text != _confirmUsername || _password.text != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid username or password. Try again.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: KConstants.expenseRed,
        ),
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
      (route) => false,
    );
  }
}
