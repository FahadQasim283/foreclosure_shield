import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_reset, size: 100, color: AppColors.primary),
              const SizedBox(height: 32),
              Text('Reset Your Password', style: AppTypography.h1, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                'Enter your email address and we\'ll send you instructions to reset your password.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'fahadqasim3310@gmail.com',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement password reset
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Send Reset Link'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
