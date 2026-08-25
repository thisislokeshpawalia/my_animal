import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/cart/model/cart_item_model.dart';

class CartService {
  static const String _cartKey = 'user_local_cart';

  // Fetch all current items from local storage
  Future<List<CartItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartJsonList = prefs.getStringList(_cartKey);

    if (cartJsonList == null) return [];

    return cartJsonList
        .map((item) => CartItemModel.fromJson(jsonDecode(item)))
        .toList();
  }

  // Core business logic: Add an item or bump up its quantity
  Future<void> addToCart({
    required String id,
    required String name,
    required String image,
    required double price,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getCartItems();

    // Check if item already exists in cart
    final existingItemIndex = items.indexWhere((item) => item.id == id);

    if (existingItemIndex != -1) {
      // If it exists, increment its quantity counters
      items[existingItemIndex].quantity += 1;
    } else {
      // If it's fresh, inject a brand new cart element mapping
      items.add(CartItemModel(id: id, productName: name, image: image, price: price));
    }

    // Convert back into a serialized String list to save over the key
    final List<String> updatedJsonList = items
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(_cartKey, updatedJsonList);
  }
}