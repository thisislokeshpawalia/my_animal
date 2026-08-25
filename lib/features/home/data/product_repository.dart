import '../models/product_model.dart';
import '../../../../core/network/api_client.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> fetchProducts() async {
    final response = await _apiClient.instance.get('/products');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}