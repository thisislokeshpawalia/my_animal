import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

final loyaltyPointsProvider = FutureProvider<int>((ref) async {
  final apiClient = ApiClient();
  try {
    final response = await apiClient.instance.get('/auth/me');
    if (response.statusCode == 200) {
      return response.data['loyalty_points'] ?? 0;
    }
  } catch (e) {
    // ignore
  }
  return 0;
});
