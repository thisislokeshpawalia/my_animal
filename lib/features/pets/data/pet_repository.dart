import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/pet_model.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository(ApiClient().instance);
});

class PetRepository {
  final Dio _dio;

  PetRepository(this._dio);

  Future<PetModel> createPet(PetModel pet) async {
    try {
      final response = await _dio.post('/pets/', data: pet.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PetModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create pet');
      }
    } catch (e) {
      throw Exception('Failed to create pet: $e');
    }
  }

  Future<List<PetModel>> getUserPets(String userId) async {
    try {
      final response = await _dio.get('/pets/$userId');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => PetModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch pets');
      }
    } catch (e) {
      throw Exception('Failed to fetch pets: $e');
    }
  }
}
