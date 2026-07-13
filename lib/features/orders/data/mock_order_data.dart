import '../model/order_model.dart';
import '../model/order_status.dart';

final mockOrders = <OrderModel>[
  OrderModel(
    id: "MYA1001",
    productName: "Premium Dog Food",
    image:
    "https://images.unsplash.com/photo-1587300003388-59208cc962cb",
    price: 1499,
    quantity: 1,
    orderDate: DateTime.now().subtract(
      const Duration(days: 2),
    ),
    status: OrderStatus.delivered,
    trackingId: "TRK123456",
  ),

  OrderModel(
    id: "MYA1002",
    productName: "Cat Toy Set",
    image:
    "https://images.unsplash.com/photo-1519052537078-e6302a4968d4",
    price: 599,
    quantity: 2,
    orderDate: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    status: OrderStatus.shipped,
    trackingId: "TRK234567",
  ),

  OrderModel(
    id: "MYA1003",
    productName: "Bird Cage",
    image:
    "https://images.unsplash.com/photo-1444464666168-49d633b86797",
    price: 2499,
    quantity: 1,
    orderDate: DateTime.now(),
    status: OrderStatus.pending,
    trackingId: "TRK345678",
  ),
];