import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_text_style.dart';
import '../../main/providers/bottom_nav_provider.dart';
import '../widgets/empty_cart.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Replace with your Riverpod cart provider later
    final bool isCartEmpty = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: AppTextStyles.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              ref.read(bottomNavProvider.notifier).changeTab(2);
            },
          ),
        ],
      ),
      body: isCartEmpty
          ? EmptyCart(
        onContinueShopping: () {
          ref.read(bottomNavProvider.notifier).changeTab(0);
        },
        onOpenWishlist: () {
          ref.read(bottomNavProvider.notifier).changeTab(2);
        },
      )
          : const Center(
        child: Text("Cart Items"),
      ),
    );
  }
}