import 'package:flutter/material.dart';

class BillBreakdown extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryFee;
  final double grandTotal;
  final bool isFreeDelivery;
  final String? appliedCouponCode;

  const BillBreakdown({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryFee,
    required this.grandTotal,
    required this.isFreeDelivery,
    this.appliedCouponCode,
  });

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

          const Text("Price Details",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _row("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),

          if (discount > 0)
            _row(
              "Coupon Discount${appliedCouponCode != null ? ' ($appliedCouponCode)' : ''}",
              "- ₹${discount.toStringAsFixed(2)}",
              valueColor: Colors.green.shade700,
            ),

          _row("Tax (GST)", "₹${tax.toStringAsFixed(2)}"),

          _row(
            "Delivery Fee",
            isFreeDelivery ? "FREE" : "₹${deliveryFee.toStringAsFixed(2)}",
            valueColor: isFreeDelivery ? Colors.green.shade700 : null,
          ),

          const Divider(height: 28, thickness: 1, color: Color(0xFFEEEEEE)),

          _row(
            "Grand Total",
            "₹${grandTotal.toStringAsFixed(2)}",
            bold: true,
            valueColor: Theme.of(context).colorScheme.primary,
            fontSize: 17,
          ),

          // Savings banner
          if (discount > 0) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.savings_outlined,
                      color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "You saved ₹${discount.toStringAsFixed(2)} on this order 🎉",
                    style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ],

          // Free delivery banner
          if (isFreeDelivery) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping_outlined,
                      color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Free delivery applied!",
                    style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(
      String label,
      String value, {
        bool bold = false,
        Color? valueColor,
        double fontSize = 14,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: fontSize,
                  fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? Colors.black87,
                  fontSize: fontSize,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}