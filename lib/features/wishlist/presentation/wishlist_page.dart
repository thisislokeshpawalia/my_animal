// lib/features/wishlist/presentation/wishlist_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_style.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/empty_wishlist.dart';
import '../widgets/wishlist_card.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Realtime live user reactive data streams subscription point
    final savedProducts = ref.watch(wishlistProvider);

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
          /// Search Bar
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

          /// Section Title Readout
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
                  "${savedProducts.length} Items",
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          /// Conditional Content rendering layer switch block
          Expanded(
            child: savedProducts.isEmpty
                ? const EmptyWishlist()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              itemCount: savedProducts.length,
              itemBuilder: (context, index) {
                // Dynamically binds standard product schemas directly to your UI display card blocks
                return WishlistCard(
                  product: savedProducts[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}