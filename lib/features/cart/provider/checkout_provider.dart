// lib/features/cart/provider/checkout_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider manages the temporary address selection during checkout
final selectedCheckoutAddressProvider = StateProvider<dynamic>((ref) => null);