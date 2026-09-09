import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../orders/provider/order_provider.dart';
import '../../orders/model/order_model.dart';
import '../../../app/theme/app_color.dart';

class MySubscriptionsPage extends ConsumerWidget {
  const MySubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(orderProvider);
    final subscriptions = allOrders.where((order) => order.isSubscription).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscriptions'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: subscriptions.isEmpty
          ? const Center(
              child: Text(
                'You have no active subscriptions.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: subscriptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
                return _SubscriptionCard(subscription: sub);
              },
            ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final OrderModel subscription;

  const _SubscriptionCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    
    // Determine next delivery date based on frequency
    DateTime nextDeliveryDate = subscription.orderDate;
    if (subscription.frequency == 'Weekly') {
      nextDeliveryDate = nextDeliveryDate.add(const Duration(days: 7));
    } else if (subscription.frequency == 'Every 2 Weeks') {
      nextDeliveryDate = nextDeliveryDate.add(const Duration(days: 14));
    } else if (subscription.frequency == 'Monthly') {
      nextDeliveryDate = nextDeliveryDate.add(const Duration(days: 30));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subscription.frequency.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Text(
                'ID: ${subscription.id.substring(0, 10)}...',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...subscription.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50, height: 50, color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${item.quantity} • ₹${item.price.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Next Delivery', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    formatter.format(nextDeliveryDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription Cancelled (Simulation)')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
