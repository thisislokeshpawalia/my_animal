import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/buttons/primary_button.dart';
import '../../../../core/textfields/app_text_field.dart';
import '../../../../core/textfields/password_field.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() =>
      _SignupFormState();
}

class _SignupFormState
    extends State<SignupForm> {

  final _formKey =
  GlobalKey<FormState>();

  final nameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  bool agree = false;

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [

          AppTextField(
            controller: nameController,
            hintText: "Full Name",
            prefixIcon:
            const Icon(Icons.person_outline),
          ),

          const SizedBox(
              height: AppSpacing.lg),

          AppTextField(
            controller: emailController,
            hintText: "Email",
            keyboardType:
            TextInputType.emailAddress,
            prefixIcon:
            const Icon(Icons.email_outlined),
          ),

          const SizedBox(
              height: AppSpacing.lg),

          AppTextField(
            controller: phoneController,
            hintText: "Phone Number",
            keyboardType:
            TextInputType.phone,
            prefixIcon:
            const Icon(Icons.phone),
          ),

          const SizedBox(
              height: AppSpacing.lg),

          PasswordField(
            controller:
            passwordController,
          ),

          const SizedBox(
              height: AppSpacing.lg),

          PasswordField(
            controller:
            confirmPasswordController,
            hintText:
            "Confirm Password",
          ),

          CheckboxListTile(
            value: agree,
            onChanged: (v) {

              setState(() {

                agree = v!;

              });

            },

            controlAffinity:
            ListTileControlAffinity.leading,

            title: const Text(
              "I agree to Terms & Conditions",
            ),
          ),

          const SizedBox(
              height: AppSpacing.lg),

          PrimaryButton(
            text: "Create Account",

            isLoading: loading,

            onPressed: () { context.go(AppRoutes.login);},
          ),
        ],
      ),
    );
  }
}