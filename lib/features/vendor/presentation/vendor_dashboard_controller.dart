import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vendor_product_model.dart';

final vendorDashboardControllerProvider =
    StateNotifierProvider<VendorDashboardController, List<VendorProductModel>>((ref) {
  return VendorDashboardController();
});

class VendorDashboardController extends StateNotifier<List<VendorProductModel>> {
  VendorDashboardController() : super([
    // Dummy initial products
    VendorProductModel(
      id: '1',
      name: 'Golden Retriever Puppy',
      price: 15000.0,
      description: 'Healthy and playful Golden Retriever puppy.',
      category: 'Animal',
      imageUrl: 'https://images.unsplash.com/photo-1633722715463-d30f4f325e24',
    ),
    VendorProductModel(
      id: '2',
      name: 'Premium Dog Food 5kg',
      price: 2500.0,
      description: 'High-quality dog food for all breeds.',
      category: 'Accessory',
      imageUrl: 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee',
    ),
  ]);

  void addProduct(VendorProductModel product) {
    state = [...state, product];
  }
}
