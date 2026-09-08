import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/vet_consultation_model.dart';

final vetRepositoryProvider = Provider<VetRepository>((ref) {
  return VetRepository(ApiClient().instance);
});

class VetRepository {
  final Dio _dio;

  VetRepository(this._dio);

  Future<VetConsultationModel> bookConsultation(VetConsultationModel consultation) async {
    try {
      final response = await _dio.post('/vets/consultations/', data: consultation.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VetConsultationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to book consultation');
      }
    } catch (e) {
      throw Exception('Failed to book consultation: $e');
    }
  }

  Future<List<VetConsultationModel>> getUserConsultations(String userId) async {
    try {
      final response = await _dio.get('/vets/consultations/user/$userId');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => VetConsultationModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch consultations');
      }
    } catch (e) {
      throw Exception('Failed to fetch consultations: $e');
    }
  }
}
