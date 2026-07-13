import 'package:flutter/material.dart';

import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_style.dart';
import '../data/mock_wishlist.dart';
import '../widgets/empty_wishlist.dart';
import '../widgets/wishlist_card.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Wishlist",
          style: AppTextStyles.heading2,
        ),
      ),

      body: Column(
        children: [

          /// Search
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: AppTextStyles.bodyMedium,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),

          /// Section Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: Row(
              children: [

                Text(
                  "Saved Products",
                  style: AppTextStyles.title,
                ),

                const Spacer(),

                Text(
                  "${mockWishlist.length} Items",
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// Wishlist
          Expanded(
            child: mockWishlist.isEmpty
                ? const EmptyWishlist()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              itemCount: mockWishlist.length,
              itemBuilder: (context, index) {
                return WishlistCard(
                  product: mockWishlist[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}