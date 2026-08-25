import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/buttons/primary_button.dart';
import '../../../../core/service/auth_service/twilio_auth_service.dart';
import '../../../../core/textfields/app_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    // ---------------------------------------------
    // Validate form
    // ---------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    // ---------------------------------------------
    // Get phone number
    // ---------------------------------------------

    final phoneNumber =
        "+91${phoneController.text.trim()}";

    // ---------------------------------------------
    // Get email
    // ---------------------------------------------

    final email =
    emailController.text.trim();

    try {
      // ---------------------------------------------
      // Send OTP using Twilio
      // ---------------------------------------------

      await TwilioAuthService().sendOtp(
        phoneNumber: phoneNumber,
      );

      // ---------------------------------------------
      // Save user information locally
      // ---------------------------------------------

      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        'user_phone',
        phoneNumber,
      );

      await prefs.setString(
        'user_email',
        email,
      );

      debugPrint(
        'User phone saved: ${prefs.getString('user_phone')}',
      );

      debugPrint(
        'User email saved: ${prefs.getString('user_email')}',
      );

      if (!mounted) return;

      // ---------------------------------------------
      // Stop loading
      // ---------------------------------------------

      setState(() {
        isLoading = false;
      });

      // ---------------------------------------------
      // Navigate to OTP page
      // ---------------------------------------------

      context.push(
        AppRoutes.otp,
        extra: {
          "phone": phoneNumber,
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [

          // -----------------------------------------
          // PHONE NUMBER
          // -----------------------------------------

          AppTextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            hintText: "Phone Number",

            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(width: 14),

                Text(
                  "🇮🇳 +91",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(width: 10),

                VerticalDivider(),
              ],
            ),

            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return "Enter phone number";
              }

              if (value.trim().length != 10) {
                return "Enter valid phone number";
              }

              if (!RegExp(r'^[0-9]+$')
                  .hasMatch(value.trim())) {
                return "Enter valid phone number";
              }

              return null;
            },
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          // -----------------------------------------
          // EMAIL
          // -----------------------------------------

          AppTextField(
            controller: emailController,
            keyboardType:
            TextInputType.emailAddress,
            hintText: "Email Address",

            prefixIcon: const Icon(
              Icons.email_outlined,
            ),

            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return "Enter email address";
              }

              final emailRegex = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              );

              if (!emailRegex.hasMatch(
                value.trim(),
              )) {
                return "Enter valid email address";
              }

              return null;
            },
          ),

          const SizedBox(
            height: AppSpacing.xl,
          ),

          // -----------------------------------------
          // CONTINUE BUTTON
          // -----------------------------------------

          PrimaryButton(
            text: "Continue",
            isLoading: isLoading,
            onPressed: sendOtp,
          ),
        ],
      ),
    );
  }
}