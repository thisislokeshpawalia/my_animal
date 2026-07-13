import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../../core/buttons/primary_button.dart';
import '../../../core/service/auth_service/phone_auth_service.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;


  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;

  Future<void> verifyOtp() async {

    if (otpController.text.trim().length != 6) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Enter valid OTP",
          ),
        ),

      );

      return;
    }


    setState(() {
      isLoading = true;
    });


    try {

      final user =
      await PhoneAuthService()
          .verifyOtp(

        verificationId:
        widget.verificationId,


        otp:
        otpController.text.trim(),

      );


      if(user != null){


        final prefs =
        await SharedPreferences.getInstance();


        await prefs.setBool(
          "isLoggedIn",
          true,
        );


        if(!mounted) return;


        context.go(
          AppRoutes.main,
        );

      }


    }

    catch(e){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text(
            "Invalid OTP",
          ),
        ),

      );

    }


    if(mounted){

      setState(() {
        isLoading = false;
      });

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
            const SizedBox(height: 20),

            Text(
              "Verify OTP",
              style: AppTextStyles.heading2,
            ),

            const SizedBox(height: 12),

            Text(
              "OTP sent to",
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 6),

            Text(
              widget.phoneNumber,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 20,
                color: Colors.grey.shade700, // Entered OTP color
              ),
              decoration: InputDecoration(
                hintText: "******",
                hintStyle: TextStyle(
                  color: Colors.grey.shade400, // Hint color
                  letterSpacing: 20,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                counterText: "",
              ),
            ),

            const SizedBox(height: 30),

            PrimaryButton(
              text: "Verify",
              isLoading: isLoading,
              onPressed: verifyOtp,
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                // add resend OTP logic later
              },
              child: const Text(
                "Resend OTP",
              ),
            ),

            const Spacer(),

            Text(
              "Enter the OTP sent to your phone",
              style: AppTextStyles.caption,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}