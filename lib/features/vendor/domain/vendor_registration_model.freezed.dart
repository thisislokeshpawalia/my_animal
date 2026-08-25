// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_registration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorRegistrationModel {

 String get vendorName; String get phone; String get email; String get panNumber; String get gstNumber; String get aadhaarNumber; String get address; String get pincode; String get bankAccountNumber; String get ifscCode;
/// Create a copy of VendorRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorRegistrationModelCopyWith<VendorRegistrationModel> get copyWith => _$VendorRegistrationModelCopyWithImpl<VendorRegistrationModel>(this as VendorRegistrationModel, _$identity);

  /// Serializes this VendorRegistrationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorRegistrationModel&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.panNumber, panNumber) || other.panNumber == panNumber)&&(identical(other.gstNumber, gstNumber) || other.gstNumber == gstNumber)&&(identical(other.aadhaarNumber, aadhaarNumber) || other.aadhaarNumber == aadhaarNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.bankAccountNumber, bankAccountNumber) || other.bankAccountNumber == bankAccountNumber)&&(identical(other.ifscCode, ifscCode) || other.ifscCode == ifscCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendorName,phone,email,panNumber,gstNumber,aadhaarNumber,address,pincode,bankAccountNumber,ifscCode);

@override
String toString() {
  return 'VendorRegistrationModel(vendorName: $vendorName, phone: $phone, email: $email, panNumber: $panNumber, gstNumber: $gstNumber, aadhaarNumber: $aadhaarNumber, address: $address, pincode: $pincode, bankAccountNumber: $bankAccountNumber, ifscCode: $ifscCode)';
}


}

/// @nodoc
abstract mixin class $VendorRegistrationModelCopyWith<$Res>  {
  factory $VendorRegistrationModelCopyWith(VendorRegistrationModel value, $Res Function(VendorRegistrationModel) _then) = _$VendorRegistrationModelCopyWithImpl;
@useResult
$Res call({
 String vendorName, String phone, String email, String panNumber, String gstNumber, String aadhaarNumber, String address, String pincode, String bankAccountNumber, String ifscCode
});




}
/// @nodoc
class _$VendorRegistrationModelCopyWithImpl<$Res>
    implements $VendorRegistrationModelCopyWith<$Res> {
  _$VendorRegistrationModelCopyWithImpl(this._self, this._then);

  final VendorRegistrationModel _self;
  final $Res Function(VendorRegistrationModel) _then;

/// Create a copy of VendorRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vendorName = null,Object? phone = null,Object? email = null,Object? panNumber = null,Object? gstNumber = null,Object? aadhaarNumber = null,Object? address = null,Object? pincode = null,Object? bankAccountNumber = null,Object? ifscCode = null,}) {
  return _then(_self.copyWith(
vendorName: null == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,panNumber: null == panNumber ? _self.panNumber : panNumber // ignore: cast_nullable_to_non_nullable
as String,gstNumber: null == gstNumber ? _self.gstNumber : gstNumber // ignore: cast_nullable_to_non_nullable
as String,aadhaarNumber: null == aadhaarNumber ? _self.aadhaarNumber : aadhaarNumber // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,bankAccountNumber: null == bankAccountNumber ? _self.bankAccountNumber : bankAccountNumber // ignore: cast_nullable_to_non_nullable
as String,ifscCode: null == ifscCode ? _self.ifscCode : ifscCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorRegistrationModel].
extension VendorRegistrationModelPatterns on VendorRegistrationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorRegistrationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorRegistrationModel value)  $default,){
final _that = this;
switch (_that) {
case _VendorRegistrationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorRegistrationModel value)?  $default,){
final _that = this;
switch (_that) {
case _VendorRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String vendorName,  String phone,  String email,  String panNumber,  String gstNumber,  String aadhaarNumber,  String address,  String pincode,  String bankAccountNumber,  String ifscCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorRegistrationModel() when $default != null:
return $default(_that.vendorName,_that.phone,_that.email,_that.panNumber,_that.gstNumber,_that.aadhaarNumber,_that.address,_that.pincode,_that.bankAccountNumber,_that.ifscCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String vendorName,  String phone,  String email,  String panNumber,  String gstNumber,  String aadhaarNumber,  String address,  String pincode,  String bankAccountNumber,  String ifscCode)  $default,) {final _that = this;
switch (_that) {
case _VendorRegistrationModel():
return $default(_that.vendorName,_that.phone,_that.email,_that.panNumber,_that.gstNumber,_that.aadhaarNumber,_that.address,_that.pincode,_that.bankAccountNumber,_that.ifscCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String vendorName,  String phone,  String email,  String panNumber,  String gstNumber,  String aadhaarNumber,  String address,  String pincode,  String bankAccountNumber,  String ifscCode)?  $default,) {final _that = this;
switch (_that) {
case _VendorRegistrationModel() when $default != null:
return $default(_that.vendorName,_that.phone,_that.email,_that.panNumber,_that.gstNumber,_that.aadhaarNumber,_that.address,_that.pincode,_that.bankAccountNumber,_that.ifscCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorRegistrationModel implements VendorRegistrationModel {
  const _VendorRegistrationModel({required this.vendorName, required this.phone, required this.email, required this.panNumber, required this.gstNumber, required this.aadhaarNumber, required this.address, required this.pincode, required this.bankAccountNumber, required this.ifscCode});
  factory _VendorRegistrationModel.fromJson(Map<String, dynamic> json) => _$VendorRegistrationModelFromJson(json);

@override final  String vendorName;
@override final  String phone;
@override final  String email;
@override final  String panNumber;
@override final  String gstNumber;
@override final  String aadhaarNumber;
@override final  String address;
@override final  String pincode;
@override final  String bankAccountNumber;
@override final  String ifscCode;

/// Create a copy of VendorRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorRegistrationModelCopyWith<_VendorRegistrationModel> get copyWith => __$VendorRegistrationModelCopyWithImpl<_VendorRegistrationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorRegistrationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorRegistrationModel&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.panNumber, panNumber) || other.panNumber == panNumber)&&(identical(other.gstNumber, gstNumber) || other.gstNumber == gstNumber)&&(identical(other.aadhaarNumber, aadhaarNumber) || other.aadhaarNumber == aadhaarNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.bankAccountNumber, bankAccountNumber) || other.bankAccountNumber == bankAccountNumber)&&(identical(other.ifscCode, ifscCode) || other.ifscCode == ifscCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendorName,phone,email,panNumber,gstNumber,aadhaarNumber,address,pincode,bankAccountNumber,ifscCode);

@override
String toString() {
  return 'VendorRegistrationModel(vendorName: $vendorName, phone: $phone, email: $email, panNumber: $panNumber, gstNumber: $gstNumber, aadhaarNumber: $aadhaarNumber, address: $address, pincode: $pincode, bankAccountNumber: $bankAccountNumber, ifscCode: $ifscCode)';
}


}

/// @nodoc
abstract mixin class _$VendorRegistrationModelCopyWith<$Res> implements $VendorRegistrationModelCopyWith<$Res> {
  factory _$VendorRegistrationModelCopyWith(_VendorRegistrationModel value, $Res Function(_VendorRegistrationModel) _then) = __$VendorRegistrationModelCopyWithImpl;
@override @useResult
$Res call({
 String vendorName, String phone, String email, String panNumber, String gstNumber, String aadhaarNumber, String address, String pincode, String bankAccountNumber, String ifscCode
});




}
/// @nodoc
class __$VendorRegistrationModelCopyWithImpl<$Res>
    implements _$VendorRegistrationModelCopyWith<$Res> {
  __$VendorRegistrationModelCopyWithImpl(this._self, this._then);

  final _VendorRegistrationModel _self;
  final $Res Function(_VendorRegistrationModel) _then;

/// Create a copy of VendorRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vendorName = null,Object? phone = null,Object? email = null,Object? panNumber = null,Object? gstNumber = null,Object? aadhaarNumber = null,Object? address = null,Object? pincode = null,Object? bankAccountNumber = null,Object? ifscCode = null,}) {
  return _then(_VendorRegistrationModel(
vendorName: null == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,panNumber: null == panNumber ? _self.panNumber : panNumber // ignore: cast_nullable_to_non_nullable
as String,gstNumber: null == gstNumber ? _self.gstNumber : gstNumber // ignore: cast_nullable_to_non_nullable
as String,aadhaarNumber: null == aadhaarNumber ? _self.aadhaarNumber : aadhaarNumber // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,bankAccountNumber: null == bankAccountNumber ? _self.bankAccountNumber : bankAccountNumber // ignore: cast_nullable_to_non_nullable
as String,ifscCode: null == ifscCode ? _self.ifscCode : ifscCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
