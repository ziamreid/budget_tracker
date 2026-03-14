import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/views/pages/login_page.dart';
import 'package:my_first_app/views/pages/onboarding_page.dart';
import 'package:my_first_app/views/widget_tree.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0F1A),
              Color(0xFF0F172A),
              Color(0xFF0D9488),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: KConstants.primary.withValues(alpha: 0.4),
                            blurRadius: 48,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Lottie.asset(
                        'asset/lottie/Wave_Animation.json',
                        height: 140,
                        width: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFA7F3D0),
                          Color(0xFF5EEAD4),
                          Colors.white,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Budget Tracker',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          height: 1.1,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Take control of your money.\nTrack spending, set budgets, reach goals.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 52),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: KConstants.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingPage(
                                title: 'Welcome',
                                animationPath: 'asset/lottie/Welcome.json',
                                buttonText: 'Get started',
                                description: 'Track every transaction and stay on top of your finances with a clear, simple dashboard.',
                                onButtonPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WidgetTree(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text('Get started'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(title: 'Log in'),
                          ),
                        );
                      },
                      child: Text(
                        'I already have an account',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
