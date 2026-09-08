// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetModel _$PetModelFromJson(Map<String, dynamic> json) => _PetModel(
  id: json['_id'] as String?,
  user_id: json['user_id'] as String,
  name: json['name'] as String,
  species: json['species'] as String,
  breed: json['breed'] as String? ?? '',
  age: (json['age'] as num?)?.toInt() ?? 0,
  health_notes: json['health_notes'] as String? ?? '',
);

Map<String, dynamic> _$PetModelToJson(_PetModel instance) => <String, dynamic>{
  '_id': instance.id,
  'user_id': instance.user_id,
  'name': instance.name,
  'species': instance.species,
  'breed': instance.breed,
  'age': instance.age,
  'health_notes': instance.health_notes,
};
