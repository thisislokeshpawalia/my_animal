import 'package:flutter/material.dart';
import 'package:my_animal/features/orders/presentation/widgets/order_card.dart';

import '../../../app/theme/app_text_style.dart';
import '../data/mock_order_data.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: AppTextStyles.title,
        ),
      ),

      body: ListView.builder(
        itemCount: mockOrders.length,
        itemBuilder: (context, index) {
          return OrderCard(
            order: mockOrders[index],
          );
        },
      ),
    );
  }
}