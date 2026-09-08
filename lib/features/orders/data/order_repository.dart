import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../model/order_model.dart';

class OrderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final response = await _apiClient.instance.post(
      '/orders/',
      data: orderData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create order: ${response.statusMessage}');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await _apiClient.instance.get('/orders/');
    
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
