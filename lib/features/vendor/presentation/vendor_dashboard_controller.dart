import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vendor_product_model.dart';
import '../data/vendor_repository.dart';

final vendorDashboardControllerProvider =
    AsyncNotifierProvider<VendorDashboardController, List<VendorProductModel>>(() {
  return VendorDashboardController();
});

class VendorDashboardController extends AsyncNotifier<List<VendorProductModel>> {
  @override
  Future<List<VendorProductModel>> build() async {
    return _fetchProducts();
  }

  Future<List<VendorProductModel>> _fetchProducts() async {
    final repository = ref.read(vendorRepositoryProvider);
    return await repository.getProducts();
  }

  Future<void> addProduct(VendorProductModel product) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(vendorRepositoryProvider);
      final newProduct = await repository.createProduct(product);
      final currentProducts = state.value ?? [];
      return [...currentProducts, newProduct];
    });
  }
}
