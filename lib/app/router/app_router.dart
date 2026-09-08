// lib/app/router/app_router.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:my_animal/app/router/app_routes.dart';

// Feature presentation screen imports
import '../../features/home/presentation/home_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/profile/pages/saved_address_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/auth/otp/otp_page.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/main/presentation/main_page.dart';
import '../../features/category/ presentation/category_page.dart';
import '../../features/profile/presentation/profile_page.dart';

import '../../features/wishlist/presentation/wishlist_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/cart/presentation/checkout_page.dart';
import '../../features/cart/presentation/dummy_payment_page.dart';
import '../../features/orders/presentation/order_tracking_page.dart';
import '../../features/profile/presentation/update_profile_page.dart';
import '../../features/vendor/presentation/vendor_registration_page.dart';
import '../../features/vendor/presentation/vendor_details_page.dart';
import '../../features/vendor/presentation/vendor_dashboard_page.dart';
import '../../features/vendor/presentation/vendor_products_page.dart';
import '../../features/vendor/presentation/vendor_add_product_page.dart';
import '../../features/orders/presentation/delhivery_tracking_page.dart';
import '../../features/admin/presentation/admin_dashboard_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final analytics = FirebaseAnalytics.instance;

  return GoRouter(
    initialLocation: AppRoutes.splash,
    observers: [
      FirebaseAnalyticsObserver(analytics: analytics),
    ],

    routes: [
      // --------------------------------------------------
      // SPLASH
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return const SplashPage();
        },
      ),

      // --------------------------------------------------
      // LOGIN
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      // --------------------------------------------------
      // MAIN (StatefulShellRoute)
      // --------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.category,
                builder: (context, state) => const CategoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // --------------------------------------------------
      // SIGN UP
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) {
          return const SignupPage();
        },
      ),

      // --------------------------------------------------
      // FORGOT PASSWORD
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) {
          return const ForgotPasswordPage();
        },
      ),

      // --------------------------------------------------
      // OTP VERIFICATION
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final data =
          state.extra as Map<String, dynamic>;

          return OtpPage(
            phoneNumber: data["phone"],
          );
        },
      ),

      // --------------------------------------------------
      // WISHLIST
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) {
          return const WishlistPage();
        },
      ),



      // --------------------------------------------------
      // CHECKOUT
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) {
          return const CheckoutPage();
        },
      ),

      // --------------------------------------------------
      // DUMMY PAYMENT
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.dummyPayment,
        builder: (context, state) {
          return const DummyPaymentPage();
        },
      ),

      // --------------------------------------------------
      // UPDATE PROFILE
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.updateProfile,
        builder: (context, state) {
          return const UpdateProfilePage();
        },
      ),

      // --------------------------------------------------
      // ORDER TRACKING
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.orderTracking,
        builder: (context, state) {
          final orderId =
          state.extra as String;

          return OrderTrackingPage(
            orderId: orderId,
          );
        },
      ),



      // --------------------------------------------------
      // SAVED ADDRESSES
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.savedAddress,
        builder: (context, state) {
          return const SavedAddressPage();
        },
      ),

      // --------------------------------------------------
      // VENDOR REGISTRATION
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.vendorRegistration,
        builder: (context, state) {
          return const VendorRegistrationPage();
        },
      ),

      // --------------------------------------------------
      // VENDOR DETAILS
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.vendorDetails,
        builder: (context, state) {
          return const VendorDetailsPage();
        },
      ),

      // --------------------------------------------------
      // VENDOR DASHBOARD
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.vendorDashboard,
        builder: (context, state) {
          return const VendorDashboardPage();
        },
      ),
      GoRoute(
        path: AppRoutes.vendorProducts,
        builder: (context, state) {
          return const VendorProductsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.vendorAddProduct,
        builder: (context, state) {
          return const VendorAddProductPage();
        },
      ),
      GoRoute(
        path: AppRoutes.delhiveryTracking,
        builder: (context, state) {
          return const DelhiveryTrackingPage();
        },
      ),

      // --------------------------------------------------
      // ADMIN DASHBOARD
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) {
          return const AdminDashboardPage();
        },
      ),
    ],
  );
});