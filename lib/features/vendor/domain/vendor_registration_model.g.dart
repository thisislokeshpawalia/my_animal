// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorRegistrationModel _$VendorRegistrationModelFromJson(
  Map<String, dynamic> json,
) => _VendorRegistrationModel(
  vendorName: json['vendorName'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  panNumber: json['panNumber'] as String,
  gstNumber: json['gstNumber'] as String,
  aadhaarNumber: json['aadhaarNumber'] as String,
  address: json['address'] as String,
  pincode: json['pincode'] as String,
  bankAccountNumber: json['bankAccountNumber'] as String,
  ifscCode: json['ifscCode'] as String,
);

Map<String, dynamic> _$VendorRegistrationModelToJson(
  _VendorRegistrationModel instance,
) => <String, dynamic>{
  'vendorName': instance.vendorName,
  'phone': instance.phone,
  'email': instance.email,
  'panNumber': instance.panNumber,
  'gstNumber': instance.gstNumber,
  'aadhaarNumber': instance.aadhaarNumber,
  'address': instance.address,
  'pincode': instance.pincode,
  'bankAccountNumber': instance.bankAccountNumber,
  'ifscCode': instance.ifscCode,
};
