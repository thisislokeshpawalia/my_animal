import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/models/product_model.dart';
import '../../orders/model/order_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier
    extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // ============================================
  // ADD PRODUCT TO CART
  // ============================================

  void addToCart(Product product) {
    final idx = state.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (idx >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx)
            state[i].copyWith(
              quantity: state[i].quantity + 1,
            )
          else
            state[i],
      ];
    } else {
      state = [
        ...state,
        CartItem(
          product: product,
          quantity: 1,
        ),
      ];
    }
  }

  // ============================================
  // ADD ORDER ITEM TO CART
  // RE-ORDER FUNCTIONALITY
  // ============================================

  void addOrderItemToCart(
      OrderItem orderItem,
      ) {
    // Create Product from order history
    final product = Product(
      id: orderItem.productName.hashCode,
      title: orderItem.productName,
      price: orderItem.price,
      image: orderItem.image,
      description: "",
      category: '',

      // Required because Product model
      // now contains rating information.
      rating: 0.0,
      ratingCount: 0,
    );

    // Check if product already exists
    // in the cart.
    final idx = state.indexWhere(
          (item) =>
      item.product.title ==
          orderItem.productName,
    );

    if (idx >= 0) {
      // Product already exists.
      // Increase its quantity.
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx)
            state[i].copyWith(
              quantity:
              state[i].quantity +
                  orderItem.quantity,
            )
          else
            state[i],
      ];
    } else {
      // Add new product to cart.
      state = [
        ...state,
        CartItem(
          product: product,
          quantity: orderItem.quantity,
        ),
      ];
    }
  }

  // ============================================
  // DECREASE QUANTITY
  // ============================================

  void decrementQuantity(
      int productId,
      ) {
    state = state
        .map(
          (item) {
        if (item.product.id ==
            productId) {
          return item.copyWith(
            quantity:
            item.quantity - 1,
          );
        }

        return item;
      },
    )
        .where(
          (item) => item.quantity > 0,
    )
        .toList();
  }

  // ============================================
  // REMOVE PRODUCT
  // ============================================

  void removeFromCart(
      int productId,
      ) {
    state = state
        .where(
          (item) =>
      item.product.id !=
          productId,
    )
        .toList();
  }

  // ============================================
  // CLEAR CART
  // ============================================

  void clearCart() {
    state = [];
  }

  // ============================================
  // SUBTOTAL
  // ============================================

  double get subtotal {
    return state.fold(
      0.0,
          (sum, item) =>
      sum +
          (item.product.price *
              item.quantity),
    );
  }

  // ============================================
  // TOTAL
  // ============================================

  double get total {
    return subtotal;
  }
}

// ================================================
// CART PROVIDER
// ================================================

final cartProvider =
StateNotifierProvider<
    CartNotifier,
    List<CartItem>>(
      (ref) => CartNotifier(),
);