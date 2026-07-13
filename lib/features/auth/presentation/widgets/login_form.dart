import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/buttons/primary_button.dart';
import '../../../../core/service/auth_service/phone_auth_service.dart';
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

  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {

    if (!_formKey.currentState!.validate()) return;


    setState(() {
      isLoading = true;
    });


    await PhoneAuthService().sendOtp(

      phoneNumber:
      "+91${phoneController.text.trim()}",


      onCodeSent:
          (verificationId) {


        if (!mounted) return;


        setState(() {
          isLoading = false;
        });


        context.push(
          AppRoutes.otp,

          extra:{

            "phone":
            "+91 ${phoneController.text.trim()}",


            "verificationId":
            verificationId,

          },

        );

      },


      onError:
          (error) {


        if (!mounted) return;


        setState(() {
          isLoading = false;
        });


        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );

      },

    );

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
              if (value == null || value.isEmpty) {
                return "Enter phone number";
              }

              if (value.length != 10) {
                return "Enter valid phone number";
              }

              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xl),

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