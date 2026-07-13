import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../../core/buttons/social_button.dart';
import '../../../../core/common/app_divider.dart';

class SignupFooter extends StatelessWidget {
  const SignupFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const AppDivider(),

        // const SizedBox(height: AppSpacing.xl),
        //
        // SocialButton(
        //   text: "Continue with Google",
        //   icon: Image.asset(
        //     "assets/icons/google.png",
        //     width: 22,
        //   ),
        //   onPressed: () {},
        // ),

        const SizedBox(height: AppSpacing.xl),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Text(
              "Already have an account? ",
              style:
              AppTextStyles.bodyMedium,
            ),

            GestureDetector(
              onTap: () {

                context.pop();

              },

              child: Text(
                "Login",
                style:
                AppTextStyles.body.copyWith(
                  color:
                  AppColors.primary,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}