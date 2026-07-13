import 'package:flutter/material.dart';

import 'widgets/auth_header.dart';
import 'widgets/signup_form.dart';
import 'widgets/signup_footer.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignupBody(),
      ),
    );
  }
}

class SignupBody extends StatelessWidget {
  const SignupBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 420,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [

              AuthHeader(
                title: "Create Account",
                subtitle:
                "Join MyAnimal and start your pet journey.",
              ),

              SizedBox(height: 40),

              SignupForm(),

              SizedBox(height: 30),

              SignupFooter(),
            ],
          ),
        ),
      ),
    );
  }
}