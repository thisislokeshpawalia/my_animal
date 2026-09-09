
import 'order_status.dart';

class OrderItem {
  final String productName;
  final String image;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productName,
    required this.image,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'image': image,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] as String? ?? '',
      image: json['image'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final double price;
  final DateTime orderDate;
  final OrderStatus status;
  final String trackingId;

  final String receiverName;
  final String contactNumber;
  final String deliveryAddress;

  // Customer email for Brevo
  final String customerEmail;
  final bool isSubscription;
  final String frequency;
  final int redeemPoints;

  const OrderModel({
    required this.id,
    required this.items,
    required this.price,
    required this.orderDate,
    required this.status,
    required this.trackingId,
    required this.receiverName,
    required this.contactNumber,
    required this.deliveryAddress,
    required this.customerEmail,
    this.isSubscription = false,
    this.frequency = '',
    this.redeemPoints = 0,
  });

  OrderModel copyWith({
    String? id,
    List<OrderItem>? items,
    double? price,
    DateTime? orderDate,
    OrderStatus? status,
    String? trackingId,
    String? receiverName,
    String? contactNumber,
    String? deliveryAddress,
    String? customerEmail,
    bool? isSubscription,
    String? frequency,
    int? redeemPoints,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      price: price ?? this.price,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      trackingId: trackingId ?? this.trackingId,
      receiverName: receiverName ?? this.receiverName,
      contactNumber: contactNumber ?? this.contactNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerEmail: customerEmail ?? this.customerEmail,
      isSubscription: isSubscription ?? this.isSubscription,
      frequency: frequency ?? this.frequency,
      redeemPoints: redeemPoints ?? this.redeemPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'price': price,
      'orderDate': orderDate.toIso8601String(),
      'status': status.name,
      'trackingId': trackingId,
      'receiverName': receiverName,
      'contactNumber': contactNumber,
      'deliveryAddress': deliveryAddress,
      'customerEmail': customerEmail,
      'is_subscription': isSubscription,
      'frequency': frequency,
      'redeem_points': redeemPoints,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderItem.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      orderDate: DateTime.tryParse(
        json['orderDate'] as String? ?? '',
      ) ??
          DateTime.now(),
      status: OrderStatus.values.firstWhere(
            (status) => status.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      trackingId: json['trackingId'] as String? ?? '',
      receiverName: json['receiverName'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      customerEmail: json['customerEmail'] as String? ?? '',
      isSubscription: json['is_subscription'] as bool? ?? false,
      frequency: json['frequency'] as String? ?? '',
      redeemPoints: (json['redeem_points'] as num?)?.toInt() ?? 0,
    );
  }
}