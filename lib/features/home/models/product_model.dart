class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final bool isFavourite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    this.isFavourite = false,
  });

  double get discountPercentage =>
      ((oldPrice - price) / oldPrice * 100);
}