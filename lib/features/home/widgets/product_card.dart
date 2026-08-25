// lib/features/home/widgets/product_card.dart

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../app/theme/app_text_style.dart";
import "../../cart/provider/cart_provider.dart";
import "../models/product_model.dart";
import "product_details_bottom_sheet.dart";

class ProductCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _isPressed = false;

  // =====================================================
  // OPEN PRODUCT DETAILS
  // =====================================================

  void _showProductDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Colors.white,
      builder: (context) {
        return ProductDetailsBottomSheet(product: widget.product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ===================================================
    // CART STATE
    // ===================================================

    final cartItems = ref.watch(cartProvider);

    // ===================================================
    // FIND PRODUCT IN CART
    // ===================================================

    final cartItemIndex = cartItems.indexWhere(
      (item) => item.product.id == widget.product.id,
    );

    final isInCart = cartItemIndex != -1;

    final quantity = isInCart ? cartItems[cartItemIndex].quantity : 0;

    // ===================================================
    // PRODUCT CARD
    // ===================================================

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _showProductDetails(context);
      },
      onTapCancel: () => setState(() => _isPressed = false),

      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 180,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================
                  // PRODUCT IMAGE
                  // =====================================
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.image,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.pets, size: 40)),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =====================================
                  // PRODUCT TITLE
                  // =====================================
                  Text(
                    widget.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label,
                  ),

                  const SizedBox(height: 8),

                  // =====================================
                  // RATING
                  // =====================================
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${widget.product.ratingCount})",
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // =====================================
                  // PRICE
                  // =====================================
                  Text(
                    "₹${widget.product.price.toStringAsFixed(0)}",
                    style: AppTextStyles.title,
                  ),

                  const Spacer(),

                  // =====================================
                  // CART BUTTON
                  // =====================================
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: isInCart
                        // =================================
                        // QUANTITY CONTROLS
                        // =================================
                        ? Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // =================
                                // DECREASE
                                // =================
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .decrementQuantity(widget.product.id);
                                  },
                                ),

                                // =================
                                // QUANTITY
                                // =================
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(scale: animation, child: child);
                                  },
                                  child: Text(
                                    quantity.toString(),
                                    key: ValueKey<int>(quantity),
                                    style: AppTextStyles.title.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                // =================
                                // INCREASE
                                // =================
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .addToCart(widget.product);
                                  },
                                ),
                              ],
                            ),
                          )
                        // =================================
                        // ADD TO CART BUTTON
                        // =================================
                        : FilledButton.icon(
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                            ),
                            label: const Text("Add to Cart"),
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ref.read(cartProvider.notifier).addToCart(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${widget.product.title} added to cart"),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
