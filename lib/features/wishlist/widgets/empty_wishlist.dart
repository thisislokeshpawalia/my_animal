import 'package:flutter/material.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_text_style.dart';

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.favorite_border,
              size: 90,
              color: AppColors.primary,
            ),

            const SizedBox(height: 24),

            Text(
              "Your Wishlist is Empty",
              style: AppTextStyles.heading2,
            ),

            const SizedBox(height: 10),

            Text(
              "Save products you love and they'll appear here.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}