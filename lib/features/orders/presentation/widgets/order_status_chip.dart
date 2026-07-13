import 'package:flutter/material.dart';

import '../../../../app/theme/app_color.dart';
import '../../model/order_status.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    Color color;

    switch (status) {
      case OrderStatus.pending:
        color = AppColors.warning;
        break;

      case OrderStatus.confirmed:
        color = Colors.blue;

        break;

      case OrderStatus.packed:
        color = Colors.deepPurple;
        break;

      case OrderStatus.shipped:
        color = Colors.indigo;
        break;

      case OrderStatus.delivered:
        color = AppColors.success;
        break;

      case OrderStatus.cancelled:
        color = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        status.title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}