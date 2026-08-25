// lib/features/auth/presentation/widgets/login_footer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../../core/buttons/social_button.dart';
import '../../../../core/common/app_divider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/service/auth_service/firebase_auth_service.dart';
import '../../services/biometric_service.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final biometric = BiometricService();

    return Column(
      children: [
        const AppDivider(),
        const SizedBox(height: AppSpacing.xl),

        // Google Login
        SocialButton(
          text: "Continue with Google",
          icon: Image.asset(
            AppAssets.google,
            width: 22,
            height: 22,
          ),
          onPressed: () async {
            final user = await FirebaseAuthService().signInWithGoogle();

            if (user != null) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", true);

              if (context.mounted) {
                context.go(AppRoutes.home);
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Google Sign In Failed")),
                );
              }
            }
          },
        ),

        const SizedBox(height: 16),

        // Apple Login
        SocialButton(
          text: "Continue with Apple",
          icon: Image.asset(
            AppAssets.apple,
            width: 22,
            height: 22,
          ),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool("isLoggedIn", true);

            if (context.mounted) {
              context.go(AppRoutes.home);
            }
          },
        ),

        const SizedBox(height: 16),

        // Biometric Login Button
        SocialButton(
          text: "Continue with Fingerprint / Face",
          icon: const Icon(
            Icons.fingerprint,
            size: 24,
          ),
          onPressed: () async {
            bool success = await biometric.authenticate();

            if (success) {
              debugPrint("Biometric Login Success");

              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", true);

              if (context.mounted) {
                context.go(AppRoutes.home);
              }
            } else {
              debugPrint("Biometric Failed");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Biometric authentication failed")),
                );
              }
            }
          },
        ),

        const SizedBox(height: AppSpacing.xl),
        Text(
          "By continuing, you agree to our",
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 4),
        Text(
          "Terms of Service • Privacy Policy",
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}