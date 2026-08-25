import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../domain/vendor_registration_model.dart';

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
          'uid': model.ownerName + "_123", // Mock UID
          'business_name': model.businessName,
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
}
