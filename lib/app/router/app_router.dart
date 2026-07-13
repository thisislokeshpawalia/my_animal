import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_animal/app/router/app_routes.dart';
import 'package:my_animal/features/auth/providers/auth_provider.dart';
import 'package:my_animal/features/splash/presentation/splash_page.dart';

import '../../features/auth/otp/otp_page.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/main/presentation/main_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.main,
        builder: (_, __) => const MainPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: AppRoutes.otp,

        builder:(context,state){

          final data =
          state.extra as Map<String,dynamic>;


          return OtpPage(

            phoneNumber:
            data["phone"],


            verificationId:
            data["verificationId"],

          );

        },
      ),


    ],
    //
    // redirect: (context, state) {
    //   final location = state.matchedLocation;
    //
    //   final isSplash = location == AppRoutes.splash;
    //   final isLogin = location == AppRoutes.login;
    //   final isSignup = location == AppRoutes.signup;
    //   final isForgotPassword =
    //       location == AppRoutes.forgotPassword;
    //
    //   if (isSplash) return null;
    //
    //   switch (authStatus) {
    //     case AuthStatus.loading:
    //       return AppRoutes.splash;
    //
    //     case AuthStatus.unauthenticated:
    //       if (isLogin || isSignup || isForgotPassword) {
    //         return null;
    //       }
    //       return AppRoutes.login;
    //
    //     case AuthStatus.authenticated:
    //       if (isLogin ||
    //           isSignup ||
    //           isForgotPassword) {
    //         return AppRoutes.home;
    //       }
    //       return null;
    //   }
    // },
  );
});