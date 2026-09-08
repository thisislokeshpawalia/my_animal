// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vet_consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VetConsultationModel _$VetConsultationModelFromJson(
  Map<String, dynamic> json,
) => _VetConsultationModel(
  id: json['_id'] as String?,
  user_id: json['user_id'] as String,
  pet_id: json['pet_id'] as String,
  vet_id: json['vet_id'] as String,
  appointment_date: DateTime.parse(json['appointment_date'] as String),
  status: json['status'] as String? ?? 'scheduled',
);

Map<String, dynamic> _$VetConsultationModelToJson(
  _VetConsultationModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'user_id': instance.user_id,
  'pet_id': instance.pet_id,
  'vet_id': instance.vet_id,
  'appointment_date': instance.appointment_date.toIso8601String(),
  'status': instance.status,
};
