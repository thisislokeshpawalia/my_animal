import 'package:flutter/material.dart';

import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_style.dart';

class EmptyCart extends StatelessWidget {
  final VoidCallback onContinueShopping;
  final VoidCallback onOpenWishlist;

  const EmptyCart({
    super.key,
    required this.onContinueShopping,
    required this.onOpenWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            height: 170,
            width: 170,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_checkout_rounded,
              size: 90,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            "Your Cart is Empty",
            style: AppTextStyles.heading2,
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            "Looks like you haven't added\nany pet products yet.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),

          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContinueShopping,
              child: Text(
                "Continue Shopping",
                style: AppTextStyles.button,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wishlist",
                          style: AppTextStyles.label,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Items you've saved for later.",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  FilledButton(
                    onPressed: onOpenWishlist,
                    child: const Text("View"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Popular Categories",
              style: AppTextStyles.title,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _CategoryItem(
                  icon: Icons.pets,
                  title: "Dog Food",
                ),
                _CategoryItem(
                  icon: Icons.cruelty_free,
                  title: "Cat Food",
                ),
                _CategoryItem(
                  icon: Icons.medication,
                  title: "Medicines",
                ),
                _CategoryItem(
                  icon: Icons.spa,
                  title: "Pet Care",
                ),
                _CategoryItem(
                  icon: Icons.toys,
                  title: "Toys",
                ),
                _CategoryItem(
                  icon: Icons.shopping_bag,
                  title: "Accessories",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(.1),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}