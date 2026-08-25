// lib/features/checkout/models/coupon_model.dart

enum CouponType {
  percentage,
  flat,
  freeDelivery,
}

class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;

  final CouponType type;

  /// For percentage:
  /// 20 = 20%
  ///
  /// For flat:
  /// 100 = ₹100
  final double value;

  /// Maximum discount allowed.
  /// Mainly useful for percentage coupons.
  final double? maximumDiscount;

  /// Minimum amount required to apply coupon.
  final double minimumOrderAmount;

  /// If null, coupon applies to entire cart.
  ///
  /// Example:
  /// "men's clothing"
  /// "jewelery"
  /// "electronics"
  /// "women's clothing"
  final String? category;

  final bool active;

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.maximumDiscount,
    this.minimumOrderAmount = 0,
    this.category,
    required this.active,
  });
}