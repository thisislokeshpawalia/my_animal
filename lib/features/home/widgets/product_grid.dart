// lib/features/home/widgets/product_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/provider/cart_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';
import '../models/product_model.dart';
import 'product_details_bottom_sheet.dart';

// =====================================================
// PRODUCT GRID
// =====================================================

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        childAspectRatio: 0.56,

        crossAxisSpacing: 12,

        mainAxisSpacing: 12,
      ),

      itemBuilder: (context, index) {
        return ProductGridCard(product: products[index]);
      },
    );
  }
}

// =====================================================
// PRODUCT GRID CARD
// =====================================================

class ProductGridCard extends ConsumerWidget {
  final Product product;

  const ProductGridCard({super.key, required this.product});

  // ===================================================
  // OPEN PRODUCT DETAILS
  // ===================================================

  void _showProductDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      showDragHandle: false,

      backgroundColor: Colors.white,

      builder: (context) {
        return ProductDetailsBottomSheet(product: product);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // =================================================
    // WISHLIST STATE
    // =================================================

    final wishlist = ref.watch(wishlistProvider);

    final isSaved = wishlist.any((item) => item.id == product.id);

    // =================================================
    // CART STATE
    // =================================================

    final cartItems = ref.watch(cartProvider);

    final cartItemIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    final isInCart = cartItemIndex != -1;

    final quantity = isInCart ? cartItems[cartItemIndex].quantity : 0;

    // =================================================
    // CARD
    // =================================================

    return GestureDetector(
      onTap: () {
        _showProductDetails(context);
      },

      child: Card(
        clipBehavior: Clip.antiAlias,

        elevation: 1,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        child: Stack(
          children: [
            // =========================================
            // MAIN PRODUCT CONTENT
            // =========================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =====================================
                // PRODUCT IMAGE
                // =====================================
                Expanded(
                  child: Image.network(
                    product.image,

                    fit: BoxFit.cover,

                    width: double.infinity,

                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.grey.shade200,

                        child: const Center(
                          child: Icon(Icons.pets, color: Colors.grey, size: 40),
                        ),
                      );
                    },
                  ),
                ),

                // =====================================
                // PRODUCT DETAILS
                // =====================================
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // =================================
                      // PRODUCT TITLE
                      // =================================
                      Text(
                        product.title,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      // =================================
                      // CATEGORY
                      // =================================
                      Text(
                        product.category,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 11,

                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // =================================
                      // PRICE
                      // =================================
                      Text(
                        "₹${product.price.toStringAsFixed(0)}",

                        style: const TextStyle(
                          color: Colors.green,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // =================================
                      // CART BUTTON
                      // =================================
                      SizedBox(
                        width: double.infinity,

                        height: 36,

                        child: isInCart
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1),

                                  borderRadius: BorderRadius.circular(8),
                                ),

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,

                                  children: [
                                    // =================
                                    // DECREASE
                                    // =================
                                    IconButton(
                                      padding: EdgeInsets.zero,

                                      icon: const Icon(Icons.remove, size: 18),

                                      onPressed: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .decrementQuantity(product.id);
                                      },
                                    ),

                                    // =================
                                    // QUANTITY
                                    // =================
                                    Text(
                                      quantity.toString(),

                                      style: const TextStyle(
                                        fontSize: 14,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // =================
                                    // INCREASE
                                    // =================
                                    IconButton(
                                      padding: EdgeInsets.zero,

                                      icon: const Icon(Icons.add, size: 18),

                                      onPressed: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .addToCart(product);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            // =================================
                            // ADD TO CART
                            // =================================
                            : FilledButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),

                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addToCart(product);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${product.title} added to cart",
                                      ),

                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },

                                child: const Text(
                                  "Add to Cart",

                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // =========================================
            // WISHLIST BUTTON
            // =========================================
            Positioned(
              top: 8,

              right: 8,

              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),

                radius: 16,

                child: IconButton(
                  padding: EdgeInsets.zero,

                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,

                    color: isSaved ? Colors.red : Colors.grey.shade700,

                    size: 18,
                  ),

                  onPressed: () {
                    ref.read(wishlistProvider.notifier).toggleWishlist(product);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
