import 'package:freezed_annotation/freezed_annotation.dart';

part 'vet_consultation_model.freezed.dart';
part 'vet_consultation_model.g.dart';

@freezed
class VetConsultationModel with _$VetConsultationModel {
  const factory VetConsultationModel({
    @JsonKey(name: '_id') String? id,
    required String user_id,
    required String pet_id,
    required String vet_id,
    required DateTime appointment_date,
    @Default('scheduled') String status, // scheduled, completed, cancelled
  }) = _VetConsultationModel;

  factory VetConsultationModel.fromJson(Map<String, dynamic> json) => _$VetConsultationModelFromJson(json);
}
