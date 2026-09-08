import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../data/pet_repository.dart';
import '../models/pet_model.dart';

final petControllerProvider = AsyncNotifierProvider<PetController, List<PetModel>>(PetController.new);

class PetController extends AsyncNotifier<List<PetModel>> {
  @override
  Future<List<PetModel>> build() async {
    return _fetchPets();
  }

  Future<List<PetModel>> _fetchPets() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return [];

    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['sub'];
    if (userId == null) return [];

    final repo = ref.read(petRepositoryProvider);
    return repo.getUserPets(userId);
  }

  Future<void> addPet(String name, String species, String breed, int age, String healthNotes) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return;

    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['sub'];
    if (userId == null) return;

    final newPet = PetModel(
      user_id: userId,
      name: name,
      species: species,
      breed: breed,
      age: age,
      health_notes: healthNotes,
    );

    final repo = ref.read(petRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.createPet(newPet);
      return _fetchPets();
    });
  }
}
