import 'order_status.dart';

class OrderModel {
  final String id;

  final String productName;

  final String image;

  final double price;

  final int quantity;

  final DateTime orderDate;

  final OrderStatus status;

  final String trackingId;

  const OrderModel({
    required this.id,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.orderDate,
    required this.status,
    required this.trackingId,
  });
}