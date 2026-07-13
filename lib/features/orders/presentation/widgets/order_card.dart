import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_text_style.dart';
import '../../model/order_model.dart';
import 'order_status_chip.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Header
            Row(
              children: [

                Expanded(
                  child: Text(
                    "Order #${order.id}",
                    style: AppTextStyles.caption,
                  ),
                ),

                OrderStatusChip(
                  status: order.status,
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// Product
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    order.image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.pets, size: 40),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        order.productName,
                        style: AppTextStyles.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "₹${order.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Quantity : ${order.quantity}",
                        style: AppTextStyles.bodyMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        DateFormat("dd MMM yyyy")
                            .format(order.orderDate),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Divider(
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 10),

            /// Tracking
            Row(
              children: [

                const Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Tracking : ${order.trackingId}",
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// Buttons
            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text("View"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.local_shipping),
                    label: const Text("Track"),
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