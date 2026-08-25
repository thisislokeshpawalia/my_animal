// lib/features/checkout/services/coupon_engine.dart

import '../model/coupon_model.dart';

class CouponEngine {
  /// Returns the subtotal on which the coupon is allowed to apply.
  ///
  /// If category is null:
  /// Coupon applies to entire cart.
  ///
  /// If category exists:
  /// Coupon applies only to products in that category.
  static double getEligibleSubtotal({
    required CouponModel coupon,
    required List<dynamic> cartItems,
  }) {
    double eligibleSubtotal = 0;

    for (final item in cartItems) {
      final product = item.product;

      // Global coupon
      if (coupon.category == null) {
        eligibleSubtotal +=
            product.price * item.quantity;

        continue;
      }

      // Category-specific coupon
      final productCategory =
      product.category
          .trim()
          .toLowerCase();

      final couponCategory =
      coupon.category!
          .trim()
          .toLowerCase();

      if (productCategory ==
          couponCategory) {
        eligibleSubtotal +=
            product.price * item.quantity;
      }
    }

    return eligibleSubtotal;
  }

  /// Checks whether the coupon can be applied.
  static CouponValidationResult validateCoupon({
    required CouponModel coupon,
    required List<dynamic> cartItems,
    required double cartSubtotal,
  }) {
    // Check whether coupon is active
    if (!coupon.active) {
      return const CouponValidationResult(
        isValid: false,
        message: 'This coupon is no longer active.',
      );
    }

    // Calculate eligible subtotal
    final eligibleSubtotal =
    getEligibleSubtotal(
      coupon: coupon,
      cartItems: cartItems,
    );

    // Category coupon but no matching products
    if (coupon.category != null &&
        eligibleSubtotal <= 0) {
      return CouponValidationResult(
        isValid: false,
        message:
        'This coupon is only valid on '
            '${coupon.category} products.',
      );
    }

    // Determine amount used for minimum order check
    final amountForMinimumCheck =
    coupon.category == null
        ? cartSubtotal
        : eligibleSubtotal;

    // Minimum order check
    if (amountForMinimumCheck <
        coupon.minimumOrderAmount) {
      final remaining =
          coupon.minimumOrderAmount -
              amountForMinimumCheck;

      return CouponValidationResult(
        isValid: false,
        message:
        'Add ₹${remaining.toStringAsFixed(0)} '
            'more eligible products to use this coupon.',
      );
    }

    return CouponValidationResult(
      isValid: true,
      message: 'Coupon applied successfully.',
      eligibleSubtotal: eligibleSubtotal,
    );
  }

  /// Calculates the actual discount.
  static double calculateDiscount({
    required CouponModel coupon,
    required double eligibleSubtotal,
    required double deliveryFee,
  }) {
    double discount = 0;

    switch (coupon.type) {
      case CouponType.percentage:
        discount =
            eligibleSubtotal *
                (coupon.value / 100);

        // Apply maximum discount limit
        if (coupon.maximumDiscount != null &&
            discount >
                coupon.maximumDiscount!) {
          discount =
          coupon.maximumDiscount!;
        }

        break;

      case CouponType.flat:
      // Flat discount cannot exceed
      // eligible product subtotal.
        discount =
        coupon.value > eligibleSubtotal
            ? eligibleSubtotal
            : coupon.value;

        break;

      case CouponType.freeDelivery:
        discount = deliveryFee;
        break;
    }

    return discount;
  }
}

class CouponValidationResult {
  final bool isValid;
  final String message;
  final double eligibleSubtotal;

  const CouponValidationResult({
    required this.isValid,
    required this.message,
    this.eligibleSubtotal = 0,
  });
}