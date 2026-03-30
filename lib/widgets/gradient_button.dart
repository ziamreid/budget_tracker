import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'animated_button.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: text,
      onPressed: isLoading ? null : onPressed,
      isLoading: isLoading,
    );
  }
}
