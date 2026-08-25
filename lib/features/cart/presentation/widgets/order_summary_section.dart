import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final List<dynamic> cartItems;

  const OrderSummarySection({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary (${cartItems.length} item${cartItems.length == 1 ? '' : 's'})",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < cartItems.length; i++) ...[
            if (i > 0)
              Divider(color: Colors.grey.shade100, height: 20),
            _CartItemRow(item: cartItems[i]),
          ],
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final dynamic item;
  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.product.image as String,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade100,
              child: const Icon(Icons.image_not_supported,
                  color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Title + qty
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.title as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Qty: ${item.quantity}  ×  ₹${(item.product.price as double).toStringAsFixed(0)}",
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Line total
        Text(
          "₹${((item.product.price as double) * (item.quantity as int)).toStringAsFixed(0)}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}