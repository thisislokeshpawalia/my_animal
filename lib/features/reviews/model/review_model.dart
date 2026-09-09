class ReviewModel {
  final String id;
  final String userId;
  final String productId;
  final String vendorId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    this.id = '',
    required this.userId,
    required this.productId,
    this.vendorId = '',
    required this.rating,
    this.comment = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      'user_id': userId,
      'product_id': productId,
      'vendor_id': vendorId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
