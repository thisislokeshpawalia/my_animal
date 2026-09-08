// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vet_consultation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VetConsultationModel {

@JsonKey(name: '_id') String? get id; String get user_id; String get pet_id; String get vet_id; DateTime get appointment_date; String get status;
/// Create a copy of VetConsultationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VetConsultationModelCopyWith<VetConsultationModel> get copyWith => _$VetConsultationModelCopyWithImpl<VetConsultationModel>(this as VetConsultationModel, _$identity);

  /// Serializes this VetConsultationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VetConsultationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.pet_id, pet_id) || other.pet_id == pet_id)&&(identical(other.vet_id, vet_id) || other.vet_id == vet_id)&&(identical(other.appointment_date, appointment_date) || other.appointment_date == appointment_date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user_id,pet_id,vet_id,appointment_date,status);

@override
String toString() {
  return 'VetConsultationModel(id: $id, user_id: $user_id, pet_id: $pet_id, vet_id: $vet_id, appointment_date: $appointment_date, status: $status)';
}


}

/// @nodoc
abstract mixin class $VetConsultationModelCopyWith<$Res>  {
  factory $VetConsultationModelCopyWith(VetConsultationModel value, $Res Function(VetConsultationModel) _then) = _$VetConsultationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String? id, String user_id, String pet_id, String vet_id, DateTime appointment_date, String status
});




}
/// @nodoc
class _$VetConsultationModelCopyWithImpl<$Res>
    implements $VetConsultationModelCopyWith<$Res> {
  _$VetConsultationModelCopyWithImpl(this._self, this._then);

  final VetConsultationModel _self;
  final $Res Function(VetConsultationModel) _then;

/// Create a copy of VetConsultationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? user_id = null,Object? pet_id = null,Object? vet_id = null,Object? appointment_date = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as String,pet_id: null == pet_id ? _self.pet_id : pet_id // ignore: cast_nullable_to_non_nullable
as String,vet_id: null == vet_id ? _self.vet_id : vet_id // ignore: cast_nullable_to_non_nullable
as String,appointment_date: null == appointment_date ? _self.appointment_date : appointment_date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VetConsultationModel].
extension VetConsultationModelPatterns on VetConsultationModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VetConsultationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VetConsultationModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VetConsultationModel value)  $default,){
final _that = this;
switch (_that) {
case _VetConsultationModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VetConsultationModel value)?  $default,){
final _that = this;
switch (_that) {
case _VetConsultationModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id,  String user_id,  String pet_id,  String vet_id,  DateTime appointment_date,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VetConsultationModel() when $default != null:
return $default(_that.id,_that.user_id,_that.pet_id,_that.vet_id,_that.appointment_date,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id,  String user_id,  String pet_id,  String vet_id,  DateTime appointment_date,  String status)  $default,) {final _that = this;
switch (_that) {
case _VetConsultationModel():
return $default(_that.id,_that.user_id,_that.pet_id,_that.vet_id,_that.appointment_date,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String? id,  String user_id,  String pet_id,  String vet_id,  DateTime appointment_date,  String status)?  $default,) {final _that = this;
switch (_that) {
case _VetConsultationModel() when $default != null:
return $default(_that.id,_that.user_id,_that.pet_id,_that.vet_id,_that.appointment_date,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VetConsultationModel implements VetConsultationModel {
  const _VetConsultationModel({@JsonKey(name: '_id') this.id, required this.user_id, required this.pet_id, required this.vet_id, required this.appointment_date, this.status = 'scheduled'});
  factory _VetConsultationModel.fromJson(Map<String, dynamic> json) => _$VetConsultationModelFromJson(json);

@override@JsonKey(name: '_id') final  String? id;
@override final  String user_id;
@override final  String pet_id;
@override final  String vet_id;
@override final  DateTime appointment_date;
@override@JsonKey() final  String status;

/// Create a copy of VetConsultationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VetConsultationModelCopyWith<_VetConsultationModel> get copyWith => __$VetConsultationModelCopyWithImpl<_VetConsultationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VetConsultationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VetConsultationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.pet_id, pet_id) || other.pet_id == pet_id)&&(identical(other.vet_id, vet_id) || other.vet_id == vet_id)&&(identical(other.appointment_date, appointment_date) || other.appointment_date == appointment_date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user_id,pet_id,vet_id,appointment_date,status);

@override
String toString() {
  return 'VetConsultationModel(id: $id, user_id: $user_id, pet_id: $pet_id, vet_id: $vet_id, appointment_date: $appointment_date, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VetConsultationModelCopyWith<$Res> implements $VetConsultationModelCopyWith<$Res> {
  factory _$VetConsultationModelCopyWith(_VetConsultationModel value, $Res Function(_VetConsultationModel) _then) = __$VetConsultationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String? id, String user_id, String pet_id, String vet_id, DateTime appointment_date, String status
});




}
/// @nodoc
class __$VetConsultationModelCopyWithImpl<$Res>
    implements _$VetConsultationModelCopyWith<$Res> {
  __$VetConsultationModelCopyWithImpl(this._self, this._then);

  final _VetConsultationModel _self;
  final $Res Function(_VetConsultationModel) _then;

/// Create a copy of VetConsultationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? user_id = null,Object? pet_id = null,Object? vet_id = null,Object? appointment_date = null,Object? status = null,}) {
  return _then(_VetConsultationModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as String,pet_id: null == pet_id ? _self.pet_id : pet_id // ignore: cast_nullable_to_non_nullable
as String,vet_id: null == vet_id ? _self.vet_id : vet_id // ignore: cast_nullable_to_non_nullable
as String,appointment_date: null == appointment_date ? _self.appointment_date : appointment_date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
