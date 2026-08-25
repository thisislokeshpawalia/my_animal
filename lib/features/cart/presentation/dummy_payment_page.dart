import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_color.dart';

class DummyPaymentPage extends ConsumerStatefulWidget {
  const DummyPaymentPage({super.key});

  @override
  ConsumerState<DummyPaymentPage> createState() => _DummyPaymentPageState();
}

class _DummyPaymentPageState extends ConsumerState<DummyPaymentPage> {
  // Alternatively, you can pass the Razorpay paymentId here via routing arguments
  final String orderId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";

  @override
  void initState() {
    super.initState();
    _redirectToOrders();
  }

  Future<void> _redirectToOrders() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Open Orders tab (index 3)
    context.go(AppRoutes.orders);

    // Navigate to MainPage
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 90,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Your payment has been completed successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Redirecting to Orders...",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}