import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../domain/vendor_registration_model.dart';
import '../domain/vendor_product_model.dart';

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  return VendorRepository(ApiClient().instance);
});

class VendorRepository {
  final Dio _dio;

  VendorRepository(this._dio);

  Future<void> registerVendor(VendorRegistrationModel model) async {
    try {
      final response = await _dio.post(
        '/vendors/register',
        data: {
          'uid': model.vendorName + "_123", // Mock UID
          'business_name': model.vendorName,
          'email': model.email,
        },
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register vendor: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error during registration: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<VendorProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => VendorProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error fetching products: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<VendorProductModel> createProduct(VendorProductModel product) async {
    try {
      final response = await _dio.post(
        '/products/',
        data: product.toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VendorProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create product: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error creating product: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
