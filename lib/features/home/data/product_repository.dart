import '../models/product_model.dart';
import '../../../../core/network/api_client.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> fetchProducts({String? query, String? category}) async {
    final queryParams = <String, dynamic>{};
    if (query != null && query.isNotEmpty) queryParams['q'] = query;
    if (category != null && category.isNotEmpty) queryParams['category'] = category;

    final response = await _apiClient.instance.get(
      '/products/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchRecommendations(String userId) async {
    final response = await _apiClient.instance.get('/products/recommendations/$userId');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recommended products');
    }
  }
}