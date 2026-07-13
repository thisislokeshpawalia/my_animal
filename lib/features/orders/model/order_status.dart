enum OrderStatus {
  pending,
  confirmed,
  packed,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get title {
    switch (this) {
      case OrderStatus.pending:
        return "Pending";

      case OrderStatus.confirmed:
        return "Confirmed";

      case OrderStatus.packed:
        return "Packed";

      case OrderStatus.shipped:
        return "Shipped";

      case OrderStatus.delivered:
        return "Delivered";

      case OrderStatus.cancelled:
        return "Cancelled";
    }
  }
}