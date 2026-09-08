import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<void> login(String email, String password) async {
    final response = await _apiClient.instance.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final token = response.data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
    } else {
      throw Exception('Failed to login: ${response.statusMessage}');
    }
  }

  Future<void> register(String email, String password, String name) async {
    final response = await _apiClient.instance.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    if (response.statusCode == 200) {
      final token = response.data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
    } else {
      throw Exception('Failed to register: ${response.statusMessage}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwt_token');
  }
}
