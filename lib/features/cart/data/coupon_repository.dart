import '../model/coupon_model.dart';

class CouponRepository {
  List<CouponModel> getCoupons() {
    return [
      CouponModel(
        id: '1',
        code: 'WELCOME100',
        title: 'Flat ₹100 Off',
        description: 'Get flat ₹100 off on your first order above ₹499.',
        type: CouponType.flat,
        value: 100,
        minimumOrderAmount: 499,
        active: true,
      ),
       CouponModel(
        id: '2',
        code: 'PETLOVE20',
        title: '20% Off on Pet Supplies',
        description: 'Save 20% on orders above ₹999. Max discount ₹250.',
        type: CouponType.percentage,
        value: 20,
        maximumDiscount: 250,
        minimumOrderAmount: 999,
        active: true,
      ),
       CouponModel(
        id: '3',
        code: 'FREESHIP',
        title: 'Free Delivery',
        description: 'Enjoy free delivery on any order above ₹300.',
        type: CouponType.freeDelivery,
        value: 40,
        minimumOrderAmount: 300,
        active: true,
      ),
    ];
  }
}