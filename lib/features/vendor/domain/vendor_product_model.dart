class VendorProductModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  VendorProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory VendorProductModel.fromJson(Map<String, dynamic> json) {
    return VendorProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'price': price,
      'description': description,
      'category': category,
      'image': imageUrl,
      'vendor_id': 'mock-vendor-123', // Currently mocked
    };
  }
}
