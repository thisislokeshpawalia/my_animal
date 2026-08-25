import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_text_style.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../model/order_model.dart';
import '../../../cart/provider/cart_provider.dart';
import 'order_status_chip.dart';

class OrderCard extends ConsumerWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Formatting Date and Time
    final dateString = DateFormat("dd MMM, hh:mm a").format(order.orderDate);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header: Date & Status ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateString, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // --- Product Images Section ---
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      order.items[index].image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // --- Total Price & Rating ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Amount", style: AppTextStyles.caption),
                    Text("₹${order.price.toStringAsFixed(0)}",
                        style: AppTextStyles.title.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const _RatingStars(rating: 0),
              ],
            ),

            const Divider(height: 24),

            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // 1. Get your Cart Notifier
                      final cartNotifier = ref.read(cartProvider.notifier);

                      // 2. Loop through items and add them to cart
                      for (var item in order.items) {
                        cartNotifier.addOrderItemToCart(item);
                      }

                      // 3. Show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Items added to cart!")),
                      );

                      // 4. Redirect to Cart Page
                      context.push(AppRoutes.cart);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Order Again"),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.push(AppRoutes.orderTracking, extra: order.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Track Order"),
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

// --- Helper Widget: Rating Component ---
class _RatingStars extends StatefulWidget {
  final int rating;
  const _RatingStars({this.rating = 0});

  @override
  State<_RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<_RatingStars> {
  int currentRating = 0;

  @override
  void initState() {
    currentRating = widget.rating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => setState(() => currentRating = index + 1),
          child: Icon(
            index < currentRating ? Icons.star_rounded : Icons.star_border_rounded,
            color: Colors.amber,
            size: 20,
          ),
        );
      }),
    );
  }
}