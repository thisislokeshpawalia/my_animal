import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../../core/buttons/primary_button.dart';
import '../../../../core/textfields/app_text_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() =>
      _ForgotPasswordFormState();
}

class _ForgotPasswordFormState
    extends State<ForgotPasswordForm> {

  final _formKey = GlobalKey<FormState>();

  final emailController =
  TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetLink() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Password reset link sent successfully.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [

          AppTextField(
            controller: emailController,
            hintText: "Email Address",
            keyboardType:
            TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
            ),
            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {
                return "Please enter your email";
              }

              if (!RegExp(
                r'^[^@]+@[^@]+\.[^@]+',
              ).hasMatch(value)) {
                return "Please enter a valid email";
              }

              return null;
            },
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          PrimaryButton(
            text: "Send Reset Link",
            isLoading: isLoading,
            onPressed: sendResetLink,
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          TextButton.icon(
            onPressed: () {
              context.go(AppRoutes.login);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.primary,
            ),
            label: Text(
              "Back to Login",
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}