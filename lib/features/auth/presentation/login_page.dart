import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_animal/features/auth/presentation/widgets/login_footer.dart';
import 'package:my_animal/features/auth/presentation/widgets/login_form.dart';
import 'package:my_animal/features/auth/presentation/widgets/login_header.dart';

import '../../../core/common/app_logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffE8F5E9),
            Colors.white,
            Color(0xffF5FFF6),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                children: [
                  /// Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 8,
                        sigmaY: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.55),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(.12),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const AppLogo(
                          size: 100,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const LoginHeader(),

                  const SizedBox(height: 40),

                  const LoginForm(),

                  const SizedBox(height: 36),

                  const LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}