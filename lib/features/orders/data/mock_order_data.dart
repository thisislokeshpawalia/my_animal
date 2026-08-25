// import '../model/order_model_old.dart';
// import '../model/order_status.dart';
//
// final mockOrders = <OrderModel>[
//   OrderModel(
//     id: "MYA1001",
//     // --- WRAP PRODUCTS IN A LIST ---
//     items: [
//       OrderItem(
//         productName: "Premium Dog Food",
//         image: "https://images.unsplash.com/photo-1587300003388-59208cc962cb",
//         quantity: 1,
//         price: 1499,
//       ),
//     ],
//     price: 1499,
//     orderDate: DateTime.now().subtract(const Duration(days: 2)),
//     status: OrderStatus.delivered,
//     trackingId: "TRK123456",
//     receiverName: "John Doe",
//     contactNumber: "+91 9876543210",
//     deliveryAddress: "123, Pet Lovers Lane, Sector 62, Noida, UP - 201301",
//   ),
//   OrderModel(
//     id: "MYA1002",
//     items: [
//       OrderItem(
//         productName: "Cat Toy Set",
//         image: "https://images.unsplash.com/photo-1519052537078-e6302a4968d4",
//         quantity: 2,
//         price: 599,
//       ),
//     ],
//     price: 1198, // 599 * 2
//     orderDate: DateTime.now().subtract(const Duration(days: 1)),
//     status: OrderStatus.shipped,
//     trackingId: "TRK234567",
//     receiverName: "Jane Smith",
//     contactNumber: "+91 9123456789",
//     deliveryAddress: "456, Feline Court, Sector 15, Gurgaon, Haryana - 122001",
//   ),
//   OrderModel(
//     id: "MYA1003",
//     items: [
//       OrderItem(
//         productName: "Bird Cage",
//         image: "https://images.unsplash.com/photo-1444464666168-49d633b86797",
//         quantity: 1,
//         price: 2499,
//       ),
//     ],
//     price: 2499,
//     orderDate: DateTime.now(),
//     status: OrderStatus.pending,
//     trackingId: "TRK345678",
//     receiverName: "John Doe",
//     contactNumber: "+91 9876543210",
//     deliveryAddress: "123, Pet Lovers Lane, Sector 62, Noida, UP - 201301",
//   ),
// ];