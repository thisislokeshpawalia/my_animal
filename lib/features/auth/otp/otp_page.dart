import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../../core/buttons/primary_button.dart';
import '../../../../core/service/auth_service/twilio_auth_service.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController =
  TextEditingController();

  bool isLoading = false;

  Future<void> verifyOtp() async {
    final enteredOtp =
    otpController.text.trim();

    // Validate OTP
    if (enteredOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter valid 6-digit OTP",
          ),
        ),
      );

      return;
    }

    // Only allow numbers
    if (!RegExp(r'^[0-9]+$')
        .hasMatch(enteredOtp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "OTP must contain only numbers",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Verify OTP with Twilio
      final isVerified =
      await TwilioAuthService().verifyOtp(
        phoneNumber: widget.phoneNumber,
        otp: enteredOtp,
      );

      if (!mounted) return;

      if (isVerified) {
        // Save login state
        final prefs =
        await SharedPreferences
            .getInstance();

        await prefs.setBool(
          "isLoggedIn",
          true,
        );

        if (!mounted) return;

        // Navigate to main application
        context.go(
          AppRoutes.home,
        );
      } else {
        // OTP was not approved
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Invalid or expired OTP",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

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
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            // Heading
            Text(
              "Verify OTP",
              style: AppTextStyles.heading2,
            ),

            const SizedBox(
              height: 12,
            ),

            // Subtitle
            Text(
              "OTP sent to",
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(
              height: 6,
            ),

            // Phone number
            Text(
              widget.phoneNumber,
              style: AppTextStyles.body.copyWith(
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            // OTP Input
            TextField(
              controller: otpController,

              keyboardType:
              TextInputType.number,

              maxLength: 6,

              textAlign:
              TextAlign.center,

              style: TextStyle(
                fontSize: 30,
                fontWeight:
                FontWeight.bold,
                letterSpacing: 20,
                color:
                Colors.grey.shade700,
              ),

              decoration:
              InputDecoration(
                hintText: "******",

                hintStyle: TextStyle(
                  color:
                  Colors.grey.shade400,
                  letterSpacing: 20,
                  fontSize: 30,
                  fontWeight:
                  FontWeight.bold,
                ),

                counterText: "",
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // Verify Button
            PrimaryButton(
              text: "Verify",
              isLoading: isLoading,
              onPressed: verifyOtp,
            ),

            const SizedBox(
              height: 20,
            ),

            // Resend OTP
            TextButton(
              onPressed: () {
                // Resend OTP logic
                // will be added next
              },
              child: const Text(
                "Resend OTP",
              ),
            ),

            const Spacer(),

            Text(
              "Enter the OTP sent to your phone",
              style:
              AppTextStyles.caption,
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}