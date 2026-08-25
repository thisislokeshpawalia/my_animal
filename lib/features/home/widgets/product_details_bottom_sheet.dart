import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/provider/cart_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';
import '../models/product_model.dart';

class ProductDetailsBottomSheet extends ConsumerWidget {
  final Product product;

  const ProductDetailsBottomSheet({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // -----------------------------------------
    // WISHLIST
    // -----------------------------------------

    final wishlist = ref.watch(wishlistProvider);

    final isSaved = wishlist.any(
          (item) => item.id == product.id,
    );

    // -----------------------------------------
    // CART
    // -----------------------------------------

    final cartItems = ref.watch(cartProvider);

    final cartItemIndex = cartItems.indexWhere(
          (item) => item.product.id == product.id,
    );

    final isInCart = cartItemIndex != -1;

    final quantity = isInCart
        ? cartItems[cartItemIndex].quantity
        : 0;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================
              // TOP HANDLE
              // =====================================

              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =====================================
              // PRODUCT IMAGE
              // =====================================

              Stack(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.image,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.contain,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          height: 260,
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  // =================================
                  // WISHLIST BUTTON
                  // =================================

                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isSaved
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isSaved
                              ? Colors.red
                              : Colors.grey.shade700,
                        ),
                        onPressed: () {
                          ref
                              .read(
                            wishlistProvider.notifier,
                          )
                              .toggleWishlist(product);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =====================================
              // CATEGORY
              // =====================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .primaryColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =====================================
              // PRODUCT TITLE
              // =====================================

              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // =====================================
              // RATING
              // =====================================

              Row(
                children: [

                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 5),

                  Text(
                    '(${product.ratingCount} reviews)',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =====================================
              // PRICE
              // =====================================

              Text(
                '₹${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              const SizedBox(height: 20),

              // =====================================
              // DESCRIPTION
              // =====================================

              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                product.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 25),

              // =====================================
              // ADD TO CART / QUANTITY
              // =====================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: isInCart
                    ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [

                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                        ),
                        onPressed: () {
                          ref
                              .read(
                            cartProvider
                                .notifier,
                          )
                              .decrementQuantity(
                            product.id,
                          );
                        },
                      ),

                      const SizedBox(width: 20),

                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 20),

                      IconButton(
                        icon: const Icon(
                          Icons.add,
                        ),
                        onPressed: () {
                          ref
                              .read(
                            cartProvider
                                .notifier,
                          )
                              .addToCart(product);
                        },
                      ),
                    ],
                  ),
                )
                    : FilledButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(
                      cartProvider.notifier,
                    )
                        .addToCart(product);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.title} added to cart',
                        ),
                        duration:
                        const Duration(
                          seconds: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // =====================================
              // CLOSE BUTTON
              // =====================================

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}