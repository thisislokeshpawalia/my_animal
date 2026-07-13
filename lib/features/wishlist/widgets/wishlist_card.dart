import 'package:flutter/material.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_style.dart';
import '../model/wishlist_item.dart';

class WishlistCard extends StatelessWidget {
  final WishlistModel product;

  const WishlistCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final discount =
    ((product.oldPrice - product.price) / product.oldPrice * 100)
        .round();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [

            /// Product
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    product.image,
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 95,
                        height: 95,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.pets,
                          size: 45,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                /// Details
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      /// Name + Favourite
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.title,
                            ),
                          ),

                          IconButton(
                            onPressed: () {},
                            splashRadius: 20,
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      /// Rating
                      Row(
                        children: [

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [

                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.white,
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  product.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$discount% OFF",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      /// Price
                      Row(
                        children: [

                          Text(
                            "₹${product.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "₹${product.oldPrice.toStringAsFixed(0)}",
                            style: AppTextStyles.bodyMedium.copyWith(
                              decoration:
                              TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            /// Divider
            Divider(
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: AppSpacing.md),

            /// Buttons
            Row(
              children: [

                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Add to Cart"),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}