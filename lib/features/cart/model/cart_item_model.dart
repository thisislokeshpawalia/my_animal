class CartItemModel {
  final String id;
  final String productName;
  final String image;
  final double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.productName,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  // Convert to JSON map to save inside SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'productName': productName,
    'image': image,
    'price': price,
    'quantity': quantity,
  };

  // Create model instance from saved JSON map data
  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['id'] as String,
    productName: json['productName'] as String,
    image: json['image'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int,
  );
}