import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/service/location/address_provider.dart';
import '../../../orders/provider/order_provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/checkout_provider.dart';

class PaymentBar extends ConsumerStatefulWidget {
  final double grandTotal;

  const PaymentBar({
    super.key,
    required this.grandTotal,
  });

  @override
  ConsumerState<PaymentBar> createState() => _PaymentBarState();
}

class _PaymentBarState extends ConsumerState<PaymentBar> {
  late Razorpay _razorpay;

  bool _isLoading = false;

  // ==================================================
  // RAZORPAY TEST KEY
  // ==================================================

  static const String _razorpayKey =
      'rzp_test_TFdNsbyGrvGJ3a';

  // ==================================================
  // GET LOGGED-IN USER EMAIL
  // ==================================================

  Future<String> _getLoggedInUserEmail() async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('user_email');

    if (email == null || email.trim().isEmpty) {
      throw Exception(
        'User email not found. Please login again.',
      );
    }

    return email.trim();
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ==================================================
  // START PAYMENT
  // ==================================================

  Future<void> _processPayment() async {
    if (widget.grandTotal < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount must be at least ₹1'),
        ),
      );

      return;
    }

    if (_razorpayKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add your Razorpay Test Key ID.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ==================================================
      // GET LOGGED-IN USER EMAIL
      // ==================================================

      final userEmail =
      await _getLoggedInUserEmail();

      debugPrint(
        'Logged-in user email: $userEmail',
      );

      // ==================================================
      // CONVERT RUPEES TO PAISE
      // ==================================================

      final amountInPaise =
      (widget.grandTotal * 100).round();

      // ==================================================
      // GET SELECTED ADDRESS
      // ==================================================

      final selectedAddress =
      ref.read(
        selectedCheckoutAddressProvider,
      );

      String phone = '';

      if (selectedAddress != null) {
        phone = selectedAddress.phone;
      }

      // ==================================================
      // RAZORPAY OPTIONS
      // ==================================================

      final options = {
        'key': _razorpayKey,
        'amount': amountInPaise,
        'name': 'My Animal',
        'description': 'Order Payment',

        'prefill': {
          'contact': phone,
          'email': userEmail,
        },

        'theme': {
          'color': '#2E7D32',
        },
      };

      setState(() {
        _isLoading = false;
      });

      // ==================================================
      // OPEN RAZORPAY
      // ==================================================

      _razorpay.open(options);
    } catch (e) {
      debugPrint(
        'Razorpay initialization error: $e',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to start payment: $e',
          ),
        ),
      );
    }
  }

  // ==================================================
  // PAYMENT SUCCESS
  // ==================================================

  Future<void> _handlePaymentSuccess(
      PaymentSuccessResponse response,
      ) async {
    debugPrint('Payment successful');

    debugPrint(
      'Payment ID: ${response.paymentId}',
    );

    debugPrint(
      'Order ID: ${response.orderId}',
    );

    debugPrint(
      'Signature: ${response.signature}',
    );

    try {
      // ==================================================
      // GET LOGGED-IN USER EMAIL
      // ==================================================

      final customerEmail =
      await _getLoggedInUserEmail();

      debugPrint(
        'Customer email saved with order: '
            '$customerEmail',
      );

      // ==================================================
      // GET CART
      // ==================================================

      final cartItems =
      ref.read(cartProvider);

      // ==================================================
      // GET ADDRESSES
      // ==================================================

      final addressList =
      ref.read(addressProvider);

      // ==================================================
      // GET SELECTED ADDRESS
      // ==================================================

      final selectedAddress =
      ref.read(
        selectedCheckoutAddressProvider,
      );

      // ==================================================
      // VALIDATE CART
      // ==================================================

      if (cartItems.isEmpty) {
        throw Exception(
          'Cannot create order because cart is empty.',
        );
      }

      // ==================================================
      // VALIDATE ADDRESS
      // ==================================================

      if (addressList.isEmpty) {
        throw Exception(
          'Cannot create order because no address was found.',
        );
      }

      // ==================================================
      // FIND FINAL ADDRESS
      // ==================================================

      final finalAddress =
          selectedAddress ??
              addressList.firstWhere(
                    (address) => address.isDefault,
                orElse: () => addressList.first,
              );

      // ==================================================
      // CREATE ORDER
      // ==================================================

      ref
          .read(orderProvider.notifier)
          .placeOrder(
        cartItems: cartItems,
        receiverName:
        finalAddress.fullName,
        contactNumber:
        finalAddress.phone,
        deliveryAddress:
        finalAddress.fullAddress,
        customerEmail:
        customerEmail,
      );

      debugPrint(
        'Order created successfully.',
      );

      debugPrint(
        'Customer email saved with order: '
            '$customerEmail',
      );

      // ==================================================
      // CLEAR CART
      // ==================================================

      ref
          .read(cartProvider.notifier)
          .clearCart();

      // ==================================================
      // CLEAR SELECTED ADDRESS
      // ==================================================

      ref
          .read(
        selectedCheckoutAddressProvider.notifier,
      )
          .state = null;

      // ==================================================
      // STOP LOADING
      // ==================================================

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // ==================================================
      // GO TO SUCCESS PAGE
      // ==================================================

      context.push(
        AppRoutes.dummyPayment,
      );
    } catch (e) {
      debugPrint(
        'Error after successful payment: $e',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment successful, but order creation failed: $e',
          ),
        ),
      );
    }
  }

  // ==================================================
  // PAYMENT ERROR
  // ==================================================

  void _handlePaymentError(
      PaymentFailureResponse response,
      ) {
    debugPrint('Payment failed');

    debugPrint(
      'Error code: ${response.code}',
    );

    debugPrint(
      'Error message: ${response.message}',
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.message ??
              'Payment failed',
        ),
      ),
    );
  }

  // ==================================================
  // EXTERNAL WALLET
  // ==================================================

  void _handleExternalWallet(
      ExternalWalletResponse response,
      ) {
    debugPrint(
      'External wallet selected: '
          '${response.walletName}',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'External wallet: '
              '${response.walletName ?? 'Unknown'}',
        ),
      ),
    );
  }

  // ==================================================
  // UI
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed:
        (_isLoading ||
            widget.grandTotal < 1)
            ? null
            : _processPayment,
        child: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          'Pay ₹${widget.grandTotal.toStringAsFixed(0)}',
        ),
      ),
    );
  }
}