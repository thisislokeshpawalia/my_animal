// lib/features/checkout/presentation/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_animal/features/cart/presentation/widgets/payment_bar.dart';

import '../../cart/provider/cart_provider.dart';

import '../model/coupon_model.dart';
import '../services/coupon_engine.dart';
import 'widgets/address_section.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  CouponModel? _appliedCoupon;

  double _couponDiscount = 0;

  String? _couponError;

  bool _isCouponSheetOpen = false;

  // You can replace this with
  // your actual delivery fee logic.
  final double _deliveryFee = 40;

  // ---------------------------------------
  // AVAILABLE COUPONS
  // ---------------------------------------

  final List<CouponModel> _availableCoupons = const [
    CouponModel(
      id: '1',
      code: 'WELCOME100',
      title: 'Flat ₹100 Off',
      description: 'Get flat ₹100 off on orders above ₹499.',
      type: CouponType.flat,
      value: 100,
      minimumOrderAmount: 499,
      category: null,
      active: true,
    ),

    CouponModel(
      id: '2',
      code: 'MEN20',
      title: '20% Off Men\'s Clothing',
      description: 'Get 20% off on men\'s clothing.',
      type: CouponType.percentage,
      value: 20,
      maximumDiscount: 250,
      category: "men's clothing",
      active: true,
    ),

    CouponModel(
      id: '3',
      code: 'WOMEN20',
      title: '20% Off Women\'s Clothing',
      description: 'Get 20% off on women\'s clothing.',
      type: CouponType.percentage,
      value: 20,
      maximumDiscount: 250,
      category: "women's clothing",
      active: true,
    ),

    CouponModel(
      id: '4',
      code: 'JEWEL10',
      title: '10% Off Jewelry',
      description: 'Get 10% off on jewelry products.',
      type: CouponType.percentage,
      value: 10,
      maximumDiscount: 500,
      category: "jewelery",
      active: true,
    ),

    CouponModel(
      id: '5',
      code: 'ELEC15',
      title: '15% Off Electronics',
      description: 'Get 15% off on electronics.',
      type: CouponType.percentage,
      value: 15,
      maximumDiscount: 500,
      category: "electronics",
      active: true,
    ),

    CouponModel(
      id: '6',
      code: 'FREESHIP',
      title: 'Free Delivery',
      description: 'Free delivery on orders above ₹300.',
      type: CouponType.freeDelivery,
      value: 0,
      minimumOrderAmount: 300,
      category: null,
      active: true,
    ),
  ];

  // ---------------------------------------
  // CALCULATE CART SUBTOTAL
  // ---------------------------------------

  double _getCartSubtotal() {
    final cartItems = ref.read(cartProvider);

    return cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  // ---------------------------------------
  // APPLY COUPON
  // ---------------------------------------

  void _applyCoupon(CouponModel coupon) {
    final cartItems = ref.read(cartProvider);

    final cartSubtotal = _getCartSubtotal();

    final validation = CouponEngine.validateCoupon(
      coupon: coupon,
      cartItems: cartItems,
      cartSubtotal: cartSubtotal,
    );

    if (!validation.isValid) {
      setState(() {
        _couponError = validation.message;
      });

      return;
    }

    final discount = CouponEngine.calculateDiscount(
      coupon: coupon,
      eligibleSubtotal: validation.eligibleSubtotal,
      deliveryFee: _deliveryFee,
    );

    setState(() {
      _appliedCoupon = coupon;
      _couponDiscount = discount;
      _couponError = null;
    });

    Navigator.pop(context);
  }

  // ---------------------------------------
  // REMOVE COUPON
  // ---------------------------------------

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _couponDiscount = 0;
      _couponError = null;
    });
  }

  // ---------------------------------------
  // SHOW COUPON BOTTOM SHEET
  // ---------------------------------------

  void _showCouponBottomSheet() {
    final subtotal = _getCartSubtotal();

    final cartItems = ref.read(cartProvider);

    setState(() {
      _couponError = null;
      _isCouponSheetOpen = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {

            // ==========================================
            // SORT COUPONS
            //
            // AVAILABLE COUPONS FIRST
            // UNAVAILABLE COUPONS SECOND
            // ==========================================

            final sortedCoupons = [..._availableCoupons];

            sortedCoupons.sort((a, b) {
              // Calculate eligibility for coupon A
              final eligibleSubtotalA =
              CouponEngine.getEligibleSubtotal(
                coupon: a,
                cartItems: cartItems,
              );

              final amountForMinimumA = a.category == null
                  ? subtotal
                  : eligibleSubtotalA;

              final hasEligibleProductsA =
                  a.category == null ||
                      eligibleSubtotalA > 0;

              final canApplyA =
                  a.active &&
                      hasEligibleProductsA &&
                      amountForMinimumA >= a.minimumOrderAmount;

              // Calculate eligibility for coupon B
              final eligibleSubtotalB =
              CouponEngine.getEligibleSubtotal(
                coupon: b,
                cartItems: cartItems,
              );

              final amountForMinimumB = b.category == null
                  ? subtotal
                  : eligibleSubtotalB;

              final hasEligibleProductsB =
                  b.category == null ||
                      eligibleSubtotalB > 0;

              final canApplyB =
                  b.active &&
                      hasEligibleProductsB &&
                      amountForMinimumB >= b.minimumOrderAmount;

              // Available comes before unavailable
              if (canApplyA && !canApplyB) {
                return -1;
              }

              if (!canApplyA && canApplyB) {
                return 1;
              }

              // Keep original order when both have
              // the same availability status.
              return 0;
            });

            // Count available coupons
            final availableCount = sortedCoupons.where((coupon) {
              final eligibleSubtotal =
              CouponEngine.getEligibleSubtotal(
                coupon: coupon,
                cartItems: cartItems,
              );

              final amountForMinimum = coupon.category == null
                  ? subtotal
                  : eligibleSubtotal;

              final hasEligibleProducts =
                  coupon.category == null ||
                      eligibleSubtotal > 0;

              return coupon.active &&
                  hasEligibleProducts &&
                  amountForMinimum >=
                      coupon.minimumOrderAmount;
            }).length;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // --------------------------------
                    // TITLE
                    // --------------------------------
                    const Text(
                      'Available Coupons',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --------------------------------
                    // COUPONS
                    // --------------------------------
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,

                        itemCount: sortedCoupons.length,

                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),

                        itemBuilder: (context, index) {
                          final coupon =
                          sortedCoupons[index];

                          // Calculate amount eligible
                          // for this coupon.
                          final eligibleSubtotal =
                          CouponEngine
                              .getEligibleSubtotal(
                            coupon: coupon,
                            cartItems: cartItems,
                          );

                          // For global coupon,
                          // use complete subtotal.
                          final amountForMinimum =
                          coupon.category == null
                              ? subtotal
                              : eligibleSubtotal;

                          // Check category eligibility.
                          final hasEligibleProducts =
                              coupon.category == null ||
                                  eligibleSubtotal > 0;

                          final canApply =
                              coupon.active &&
                                  hasEligibleProducts &&
                                  amountForMinimum >=
                                      coupon.minimumOrderAmount;

                          final isSelected =
                              _appliedCoupon?.id ==
                                  coupon.id;

                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // --------------------------------
                              // AVAILABLE / UNAVAILABLE DIVIDER
                              // --------------------------------
                              if (index == 0 &&
                                  availableCount > 0)
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Available Coupons',
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 14,
                                          color:
                                          Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Show unavailable heading
                              // before first unavailable coupon.
                              if (!canApply &&
                                  index == availableCount)
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .remove_circle_outline,
                                        size: 18,
                                        color:
                                        Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Unavailable Coupons',
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 14,
                                          color:
                                          Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // --------------------------------
                              // COUPON CARD
                              // --------------------------------
                              Container(
                                padding:
                                const EdgeInsets.all(16),

                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(12),

                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context)
                                        .primaryColor
                                        : Colors
                                        .grey.shade300,
                                  ),
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      children: [
                                        // Coupon code
                                        Container(
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),

                                          decoration:
                                          BoxDecoration(
                                            color: Colors
                                                .grey.shade100,

                                            borderRadius:
                                            BorderRadius
                                                .circular(6),
                                          ),

                                          child: Text(
                                            coupon.code,
                                            style:
                                            const TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const Spacer(),

                                        TextButton(
                                          onPressed: canApply
                                              ? () {
                                            _applyCoupon(
                                              coupon,
                                            );
                                          }
                                              : null,

                                          child: Text(
                                            isSelected
                                                ? 'APPLIED'
                                                : canApply
                                                ? 'APPLY'
                                                : 'NOT ELIGIBLE',
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      coupon.title,

                                      style:
                                      const TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      coupon.description,

                                      style: TextStyle(
                                        color:
                                        Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),

                                    // --------------------------------
                                    // CATEGORY
                                    // --------------------------------
                                    if (coupon.category != null) ...[
                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons
                                                .category_outlined,
                                            size: 15,
                                          ),

                                          const SizedBox(width: 5),

                                          Text(
                                            'Valid on: '
                                                '${coupon.category}',

                                            style:
                                            const TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],

                                    // --------------------------------
                                    // MINIMUM ORDER
                                    // --------------------------------
                                    if (coupon
                                        .minimumOrderAmount >
                                        0) ...[
                                      const SizedBox(height: 6),

                                      Text(
                                        'Minimum eligible amount: '
                                            '₹${coupon.minimumOrderAmount.toStringAsFixed(0)}',

                                        style: TextStyle(
                                          color:
                                          Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],

                                    // --------------------------------
                                    // NOT ELIGIBLE MESSAGE
                                    // --------------------------------
                                    if (!canApply) ...[
                                      const SizedBox(height: 6),

                                      Text(
                                        coupon.category != null &&
                                            eligibleSubtotal <=
                                                0
                                            ? 'Add ${coupon.category} products to use this coupon.'
                                            : coupon
                                            .minimumOrderAmount >
                                            amountForMinimum
                                            ? 'Add ₹${(coupon.minimumOrderAmount - amountForMinimum).toStringAsFixed(0)} more eligible amount.'
                                            : 'This coupon is currently unavailable.',

                                        style:
                                        const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _isCouponSheetOpen = false;
        });
      }
    });
  }

  // ---------------------------------------
  // BUILD
  // ---------------------------------------

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    final subtotal = cartItems.fold(
      0.0,
          (sum, item) =>
      sum + (item.product.price * item.quantity),
    );

    // Delivery fee
    final deliveryFee =
    subtotal >= 500 ? 0.0 : _deliveryFee;

    // Final delivery after coupon
    final finalDelivery =
    _appliedCoupon?.type ==
        CouponType.freeDelivery
        ? 0.0
        : deliveryFee;

    // Example tax
    final tax = subtotal * 0.05;

    // Final total
    final grandTotal =
    (subtotal -
        _couponDiscount +
        tax +
        finalDelivery)
        .clamp(0.0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // ===================================
            // ADDRESS SECTION
            // ===================================
            const AddressSection(),

            const SizedBox(height: 16),

            // ===================================
            // CART PRODUCTS
            // ===================================
            const Text(
              'Your Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...cartItems.map((item) {
              return ListTile(
                contentPadding:
                EdgeInsets.zero,

                leading: Image.network(
                  item.product.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),

                title: Text(
                  item.product.title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                ),

                subtitle: Text(
                  '${item.product.category} • Qty: ${item.quantity}',
                ),

                trailing: Text(
                  '₹${(item.product.price * item.quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              );
            }),

            const SizedBox(height: 25),

            // ===================================
            // COUPON SECTION
            // ===================================
            const Text(
              'Coupon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (_appliedCoupon != null)

            // APPLIED COUPON
              Container(
                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(12),

                  border: Border.all(
                    color: Colors.green,
                  ),

                  color: Colors.green
                      .withValues(alpha: 0.05),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .local_offer_outlined,
                      color: Colors.green,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [
                          Text(
                            _appliedCoupon!.code,

                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'You saved ₹${_couponDiscount.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed:
                      _removeCoupon,

                      child:
                      const Text(
                        'REMOVE',
                        style:
                        TextStyle(
                          color:
                          Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else

            // APPLY COUPON BUTTON
              InkWell(
                onTap:
                _showCouponBottomSheet,

                borderRadius:
                BorderRadius.circular(12),

                child: Container(
                  padding:
                  const EdgeInsets.all(16),

                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                        12),

                    border: Border.all(
                      color:
                      Colors.grey.shade300,
                    ),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons
                            .local_offer_outlined,
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Apply Coupon',
                          style:
                          TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),

                      Icon(
                        Icons
                            .arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

            if (_couponError != null) ...[
              const SizedBox(height: 10),

              Text(
                _couponError!,
                style:
                const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],

            const SizedBox(height: 30),

            // ===================================
            // ORDER SUMMARY
            // ===================================
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _summaryRow(
              'Subtotal',
              '₹${subtotal.toStringAsFixed(0)}',
            ),

            const SizedBox(height: 10),

            _summaryRow(
              'Coupon Discount',
              '- ₹${_couponDiscount.toStringAsFixed(0)}',
              valueColor:
              Colors.green,
            ),

            const SizedBox(height: 10),

            _summaryRow(
              'Tax',
              '₹${tax.toStringAsFixed(0)}',
            ),

            const SizedBox(height: 10),

            _summaryRow(
              'Delivery',
              finalDelivery == 0
                  ? 'FREE'
                  : '₹${finalDelivery.toStringAsFixed(0)}',
              valueColor:
              finalDelivery == 0
                  ? Colors.green
                  : null,
            ),

            const Divider(height: 30),

            _summaryRow(
              'Total',
              '₹${grandTotal.toStringAsFixed(0)}',
              isTotal: true,
            ),

            const SizedBox(height: 30),

            // ===================================
            // PLACE ORDER
            // ===================================


            PaymentBar(
              grandTotal: grandTotal,
            ),

            // SizedBox(
            //   width: double.infinity,
            //   height: 52,
            //   child: FilledButton(
            //     onPressed: () {
            //       Razorpay();
            //     },
            //     child: Text(
            //       'Pay ₹${grandTotal.toStringAsFixed(0)}',
            //     ),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }

  // ---------------------------------------
  // SUMMARY ROW
  // ---------------------------------------

  Widget _summaryRow(
      String title,
      String value, {
        Color? valueColor,
        bool isTotal = false,
      }) {
    return Row(
      children: [
        Text(
          title,

          style: TextStyle(
            fontSize:
            isTotal ? 17 : 14,

            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),

        const Spacer(),

        Text(
          value,

          style: TextStyle(
            fontSize:
            isTotal ? 18 : 14,

            fontWeight:
            FontWeight.bold,

            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ===========================================
// GLOBAL AVAILABLE COUPONS
// ===========================================

final List<CouponModel> availableCoupons = [
  const CouponModel(
    id: '1',
    code: 'WELCOME100',
    title: 'Flat ₹100 Off',
    description:
    'Get flat ₹100 off on orders above ₹499.',
    type: CouponType.flat,
    value: 100,
    minimumOrderAmount: 499,
    category: null,
    active: true,
  ),

  const CouponModel(
    id: '2',
    code: 'MEN20',
    title: '20% Off Men\'s Clothing',
    description:
    'Get 20% off on men\'s clothing.',
    type: CouponType.percentage,
    value: 20,
    maximumDiscount: 250,
    minimumOrderAmount: 0,
    category: "men's clothing",
    active: true,
  ),

  const CouponModel(
    id: '3',
    code: 'WOMEN20',
    title: '20% Off Women\'s Clothing',
    description:
    'Get 20% off on women\'s clothing.',
    type: CouponType.percentage,
    value: 20,
    maximumDiscount: 250,
    minimumOrderAmount: 0,
    category: "women's clothing",
    active: true,
  ),

  const CouponModel(
    id: '4',
    code: 'JEWEL10',
    title: '10% Off Jewelry',
    description:
    'Get 10% off on jewelry products.',
    type: CouponType.percentage,
    value: 10,
    maximumDiscount: 500,
    minimumOrderAmount: 0,
    category: "jewelery",
    active: true,
  ),

  const CouponModel(
    id: '5',
    code: 'ELEC15',
    title: '15% Off Electronics',
    description:
    'Get 15% off on electronics.',
    type: CouponType.percentage,
    value: 15,
    maximumDiscount: 500,
    minimumOrderAmount: 0,
    category: "electronics",
    active: true,
  ),

  const CouponModel(
    id: '6',
    code: 'FREESHIP',
    title: 'Free Delivery',
    description:
    'Free delivery on orders above ₹300.',
    type: CouponType.freeDelivery,
    value: 0,
    minimumOrderAmount: 300,
    category: null,
    active: true,
  ),
];