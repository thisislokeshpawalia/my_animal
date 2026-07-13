import 'package:flutter/material.dart';

import 'widgets/auth_header.dart';
import 'widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ForgotPasswordBody(),
      ),
    );
  }
}

class ForgotPasswordBody extends StatelessWidget {
  const ForgotPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              AuthHeader(
                title: "Forgot Password",
                subtitle:
                "No worries! Enter your email address and we'll send you a password reset link.",
              ),

              SizedBox(height: 40),

              ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}