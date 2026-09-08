import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../data/vet_repository.dart';
import '../models/vet_consultation_model.dart';

final vetControllerProvider = AsyncNotifierProvider<VetController, List<VetConsultationModel>>(VetController.new);

class VetController extends AsyncNotifier<List<VetConsultationModel>> {
  @override
  Future<List<VetConsultationModel>> build() async {
    return _fetchConsultations();
  }

  Future<List<VetConsultationModel>> _fetchConsultations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return [];

    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['sub'];
    if (userId == null) return [];

    final repo = ref.read(vetRepositoryProvider);
    return repo.getUserConsultations(userId);
  }

  Future<void> bookConsultation(String petId, String vetId, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return;

    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['sub'];
    if (userId == null) return;

    final newBooking = VetConsultationModel(
      user_id: userId,
      pet_id: petId,
      vet_id: vetId,
      appointment_date: date,
      status: 'scheduled',
    );

    final repo = ref.read(vetRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.bookConsultation(newBooking);
      return _fetchConsultations();
    });
  }
}
