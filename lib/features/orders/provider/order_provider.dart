import "package:flutter/foundation.dart";
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/service/email/brevo_email_service.dart';
import '../../../core/service/invoice/invoice_service.dart';
import '../../../core/service/notification/local_notification_service.dart';

import '../model/order_model.dart';
import '../model/order_status.dart';
import '../data/order_repository.dart';
import 'dart:async';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

class OrderNotifier
    extends StateNotifier<List<OrderModel>> {
  
  final Ref ref;
  Timer? _pollingTimer;

  OrderNotifier(this.ref) : super([]) {
    _loadOrdersLocally();
  }

  static const String _storageKey =
      'saved_orders';

  // ============================================================
  // POLLING SYNC
  // ============================================================

  void startPolling() {
    if (_pollingTimer != null && _pollingTimer!.isActive) return;
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      syncOrdersWithBackend();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> syncOrdersWithBackend() async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      final backendOrders = await repository.getOrders();
      
      bool stateChanged = false;
      final updatedState = state.map((localOrder) {
        try {
          final serverOrder = backendOrders.firstWhere((o) => o.id == localOrder.id);
          if (serverOrder.status != localOrder.status) {
            // Status changed! Fire notification
            LocalNotificationService.showNotification(
              id: localOrder.id.hashCode,
              title: 'Order Status Updated',
              body: 'Order #${localOrder.id} is now ${serverOrder.status.name.toUpperCase()}',
            );
            stateChanged = true;
            return localOrder.copyWith(status: serverOrder.status);
          }
        } catch (e) {
          // order not found on server
        }
        return localOrder;
      }).toList();

      if (stateChanged) {
        state = updatedState;
        _saveOrdersLocally(state);
      }
    } catch (e) {
      debugPrint('Error syncing orders: $e');
    }
  }

  // ============================================================
  // LOAD ORDERS
  // ============================================================

  Future<void> _loadOrdersLocally() async {
    final prefs =
    await SharedPreferences.getInstance();

    final String? ordersJson =
    prefs.getString(_storageKey);

    if (ordersJson == null ||
        ordersJson.isEmpty) {
      return;
    }

    try {
      final List<dynamic> decodedList =
      jsonDecode(ordersJson)
      as List<dynamic>;

      final List<OrderModel>
      loadedOrders =
      decodedList
          .map(
            (item) =>
            OrderModel.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
      )
          .toList();

      state = loadedOrders;
    } catch (e) {
      debugPrint(
        'Failed to load orders: $e',
      );
    }
  }

  // ============================================================
  // SAVE ORDERS
  // ============================================================

  Future<void> _saveOrdersLocally(
      List<OrderModel> orders,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    final String encodedList =
    jsonEncode(
      orders
          .map(
            (order) =>
            order.toJson(),
      )
          .toList(),
    );

    await prefs.setString(
      _storageKey,
      encodedList,
    );
  }

  // ============================================================
  // ADD ORDER
  // ============================================================

  void addOrder(
      OrderModel newOrder,
      ) {
    state = [
      newOrder,
      ...state,
    ];

    _saveOrdersLocally(state);
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<void> placeOrder({
    required List<dynamic> cartItems,
    required String receiverName,
    required String contactNumber,
    required String deliveryAddress,
    required String customerEmail,
    bool isSubscription = false,
    String frequency = '',
    int redeemPoints = 0,
  }) async {
    final now =
    DateTime.now();

    final String orderId =
        'ORD-${now.millisecondsSinceEpoch}';

    // ==========================================================
    // CREATE ORDER ITEMS
    // ==========================================================

    final List<OrderItem>
    orderItems =
    cartItems
        .map<OrderItem>(
          (item) {
        return OrderItem(
          productName:
          item.product.title,

          image:
          item.product.image,

          quantity:
          item.quantity,

          price:
          (item.product.price as num)
              .toDouble(),
        );
      },
    ).toList();

    // ==========================================================
    // CALCULATE TOTAL
    // ==========================================================

    final double totalPrice =
    orderItems.fold(
      0.0,
          (sum, item) {
        return sum +
            (item.price *
                item.quantity);
      },
    );

    // ==========================================================
    // CREATE ORDER
    // ==========================================================

    final newOrder =
    OrderModel(
      id:
      orderId,

      items:
      orderItems,

      price:
      totalPrice,

      orderDate:
      now,

      status:
      OrderStatus.pending,

      trackingId:
      'TRK${now.millisecondsSinceEpoch}',

      receiverName:
      receiverName,

      contactNumber:
      contactNumber,

      deliveryAddress:
      deliveryAddress,

      customerEmail:
      customerEmail,

      isSubscription:
      isSubscription,

      frequency:
      frequency,

      redeemPoints:
      redeemPoints,
    );

    // ==========================================================
    // UPDATE STATE
    // ==========================================================

    state = [
      newOrder,
      ...state,
    ];

    // ==========================================================
    // SAVE ORDER
    // ==========================================================

    await _saveOrdersLocally(
      state,
    );

    // Call API to create order
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.createOrder(newOrder.toJson());
      debugPrint('Order successfully sent to backend.');
    } catch (e) {
      debugPrint('Failed to send order to backend: $e');
    }

    debugPrint(
      'Customer email saved with order: '
          '$customerEmail',
    );
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> updateOrderStatus(
      String orderId,
      OrderStatus newStatus,
      ) async {
    // ==========================================================
    // FIND ORDER
    // ==========================================================

    OrderModel previousOrder;

    try {
      previousOrder =
          state.firstWhere(
                (order) =>
            order.id == orderId,
          );
    } catch (e) {
      debugPrint(
        'Order not found: $orderId',
      );

      return;
    }

    // ==========================================================
    // UPDATE ORDER STATUS
    // ==========================================================

    state = state.map(
          (order) {
        if (order.id ==
            orderId) {
          return order.copyWith(
            status:
            newStatus,
          );
        }

        return order;
      },
    ).toList();

    // ==========================================================
    // SAVE UPDATED ORDER
    // ==========================================================

    await _saveOrdersLocally(
      state,
    );

    // ==========================================================
    // SEND EMAIL ONLY WHEN ORDER BECOMES DELIVERED
    // ==========================================================

    if (newStatus ==
        OrderStatus.delivered &&
        previousOrder.status !=
            OrderStatus.delivered) {
      try {
        debugPrint(
          'Order delivered: '
              '${previousOrder.id}',
        );

        debugPrint(
          'Customer email: '
              '${previousOrder.customerEmail}',
        );

        // ======================================================
        // CHECK CUSTOMER EMAIL
        // ======================================================

        if (previousOrder.customerEmail
            .trim()
            .isEmpty) {
          debugPrint(
            'Customer email is empty. '
                'Skipping delivery email.',
          );

          return;
        }

        // ======================================================
        // GENERATE INVOICE
        // ======================================================

        final String invoicePath =
        await InvoiceService
            .generateInvoicePdf(
          orderId:
          previousOrder.id,

          productName:
          previousOrder.items
              .isNotEmpty
              ? previousOrder
              .items
              .first
              .productName
              : 'Multiple Items',

          quantity:
          previousOrder.items.fold(
            0,
                (sum, item) =>
            sum +
                item.quantity,
          ),

          price:
          previousOrder.price,

          deliveryDate:
          previousOrder.orderDate,

          receiverName:
          previousOrder.receiverName,

          contactNumber:
          previousOrder.contactNumber,

          deliveryAddress:
          previousOrder.deliveryAddress,
        );

        // ======================================================
        // PRINT INVOICE PATH
        // ======================================================

        debugPrint(
          'Invoice generated:',
        );

        debugPrint(
          invoicePath,
        );

        // ======================================================
        // SEND EMAIL WITH ATTACHMENT
        // ======================================================

        await BrevoEmailService
            .sendDeliveryEmail(
          customerEmail:
          previousOrder
              .customerEmail,

          customerName:
          previousOrder
              .receiverName,

          orderId:
          previousOrder.id,



          // IMPORTANT:
          // Pass the actual path returned
          // by generateInvoicePdf().
          invoicePath:
          invoicePath,
        );

        debugPrint(
          'Delivery email sent successfully',
        );
      } catch (e) {
        debugPrint(
          'Failed to generate invoice '
              'or send delivery email:',
        );

        debugPrint(e.toString());
      }
    }
  }

  // ============================================================
  // CLEAR ORDERS
  // ============================================================

  Future<void> clearOrders() async {
    state = [];

    await _saveOrdersLocally(
      state,
    );
  }
}

// ================================================================
// PROVIDER
// ================================================================

final orderProvider =
StateNotifierProvider<
    OrderNotifier,
    List<OrderModel>>(
      (ref) {
    return OrderNotifier(ref);
  },
);