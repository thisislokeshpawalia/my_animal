import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_animal/features/orders/presentation/widgets/order_card.dart';

import '../../../app/theme/app_text_style.dart';
import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_spacing.dart';

import '../model/order_status.dart';
import '../provider/order_provider.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: AppTextStyles.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
            ),
            tooltip: "Clear Orders",
            onPressed: orders.isEmpty
                ? null
                : () {
              ref
                  .read(
                orderProvider.notifier,
              )
                  .clearOrders();
            },
          ),
        ],
      ),

      body: orders.isEmpty
          ? Center(
        child: Text(
          "You have no orders yet.",
          style:
          AppTextStyles.bodyMedium,
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder:
            (context, index) {
          final order =
          orders[index];

          return Padding(
            padding:
            const EdgeInsets.symmetric(
              vertical:
              AppSpacing.xs,
            ),

            child: Column(
              children: [

                // ====================================
                // ORDER CARD
                // ====================================

                InkWell(
                  onTap: () {
                    // Navigate to tracking page
                    //
                    // Example:
                    // context.push(
                    //   '/tracking/${order.id}',
                    // );
                  },

                  child:
                  OrderCard(
                    order: order,
                  ),
                ),

                // ====================================
                // STATUS UPDATE
                // ====================================

                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal:
                    AppSpacing.md,
                    vertical:
                    AppSpacing.xs,
                  ),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [

                      // --------------------------------
                      // STATUS INFORMATION
                      // --------------------------------

                      Expanded(
                        child:
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Row(
                              children: [

                                Icon(
                                  _getStatusIcon(
                                    order.status,
                                  ),
                                  size: 16,
                                  color:
                                  _getStatusColor(
                                    order.status,
                                  ),
                                ),

                                const SizedBox(
                                  width:
                                  AppSpacing.xs,
                                ),

                                Text(
                                  "Status: ${order.status.title}",
                                  style:
                                  AppTextStyles
                                      .bodyMedium
                                      .copyWith(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    color:
                                    _getStatusColor(
                                      order.status,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height:
                              AppSpacing.xs,
                            ),

                            Text(
                              "ID: ${order.trackingId} • "
                                  "Ship To: ${order.receiverName}",

                              style:
                              AppTextStyles
                                  .caption
                                  .copyWith(
                                color:
                                AppColors
                                    .textSecondary,
                              ),

                              maxLines: 1,

                              overflow:
                              TextOverflow
                                  .ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // =================================
                      // STATUS DROPDOWN
                      // =================================

                      PopupMenuButton<
                          OrderStatus>(
                        initialValue:
                        order.status,

                        icon:
                        const Icon(
                          Icons
                              .edit_note_rounded,
                          color:
                          AppColors
                              .primary,
                        ),

                        tooltip:
                        "Update Order Status",

                        onSelected:
                            (
                            OrderStatus
                            newStatus,
                            ) async {
                          await ref
                              .read(
                            orderProvider
                                .notifier,
                          )
                              .updateOrderStatus(
                            order.id,
                            newStatus,
                          );
                        },

                        itemBuilder:
                            (
                            BuildContext
                            context,
                            ) {
                          return OrderStatus
                              .values
                              .map(
                                (
                                OrderStatus
                                status,
                                ) {
                              return PopupMenuItem<
                                  OrderStatus>(
                                value:
                                status,

                                child:
                                Row(
                                  children: [

                                    Icon(
                                      _getStatusIcon(
                                        status,
                                      ),
                                      size:
                                      18,
                                      color:
                                      _getStatusColor(
                                        status,
                                      ),
                                    ),

                                    const SizedBox(
                                      width:
                                      AppSpacing
                                          .sm,
                                    ),

                                    Text(
                                      status
                                          .title,
                                      style:
                                      AppTextStyles
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList();
                        },
                      ),
                    ],
                  ),
                ),

                // ====================================
                // TRACKING BUTTON (If Shipped)
                // ====================================
                if (order.status == OrderStatus.shipped || order.status == OrderStatus.delivered)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.local_shipping, size: 18),
                        label: const Text("Track via Delhivery"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // In a real app we would pass the waybill to the route.
                          // For mockup, we just go to the tracking page.
                          context.push('/delhiveryTracking');
                        },
                      ),
                    ),
                  ),

                const Divider(
                  height: 1,
                  color:
                  AppColors.border,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // STATUS ICON
  // =========================================================

  IconData _getStatusIcon(
      OrderStatus status,
      ) {
    switch (status) {
      case OrderStatus.pending:
        return Icons
            .hourglass_empty_rounded;

      case OrderStatus.confirmed:
        return Icons
            .check_circle_outline_rounded;

      case OrderStatus.packed:
        return Icons
            .archive_outlined;

      case OrderStatus.shipped:
        return Icons
            .local_shipping_outlined;

      case OrderStatus.delivered:
        return Icons
            .done_all_rounded;

      case OrderStatus.cancelled:
        return Icons
            .cancel_outlined;
    }
  }

  // =========================================================
  // STATUS COLOR
  // =========================================================

  Color _getStatusColor(
      OrderStatus status,
      ) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;

      case OrderStatus.confirmed:
        return Colors.blue;

      case OrderStatus.packed:
        return Colors.purple;

      case OrderStatus.shipped:
        return Colors.indigo;

      case OrderStatus.delivered:
        return Colors.green;

      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}