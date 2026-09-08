import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_model.freezed.dart';
part 'pet_model.g.dart';

@freezed
class PetModel with _$PetModel {
  const factory PetModel({
    @JsonKey(name: '_id') String? id,
    required String user_id,
    required String name,
    required String species,
    @Default('') String breed,
    @Default(0) int age,
    @Default('') String health_notes,
  }) = _PetModel;

  factory PetModel.fromJson(Map<String, dynamic> json) => _$PetModelFromJson(json);
}
