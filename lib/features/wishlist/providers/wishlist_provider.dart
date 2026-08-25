import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/models/product_model.dart';

class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]);

  // Add or remove product from wishlist
  void toggleWishlist(Product product) {
    final isAlreadySaved = state.any(
          (item) => item.id == product.id,
    );

    if (isAlreadySaved) {
      state = state
          .where(
            (item) => item.id != product.id,
      )
          .toList();
    } else {
      state = [
        ...state,
        product,
      ];
    }
  }

  // Remove product directly
  void removeFromWishlist(int productId) {
    state = state
        .where(
          (item) => item.id != productId,
    )
        .toList();
  }

  // Check if product is in wishlist
  bool isInWishlist(int productId) {
    return state.any(
          (item) => item.id == productId,
    );
  }

  // Clear entire wishlist
  void clearWishlist() {
    state = [];
  }
}

final wishlistProvider =
StateNotifierProvider<WishlistNotifier, List<Product>>(
      (ref) => WishlistNotifier(),
);