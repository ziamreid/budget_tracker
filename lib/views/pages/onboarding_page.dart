import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/views/pages/login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.animationPath,
    required this.buttonText,
    this.description,
    this.onButtonPressed,
  });

  final String title;
  final String animationPath;
  final String buttonText;
  final String? description;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KConstants.primary.withValues(alpha: 0.12),
                  boxShadow: [
                    BoxShadow(
                      color: KConstants.primary.withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Lottie.asset(
                  animationPath,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDarkMode ? Colors.white : KConstants.surfaceDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    description!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: KConstants.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (onButtonPressed != null) {
                      onButtonPressed!();
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(title: 'Register'),
                        ),
                      );
                    }
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
