class VendorRegistrationModel {
  final String vendorName;
  final String phone;
  final String email;
  final String panNumber;
  final String gstNumber;
  final String aadhaarNumber;
  final String address;
  final String pincode;
  final String bankAccountNumber;
  final String ifscCode;

  VendorRegistrationModel({
    required this.vendorName,
    required this.phone,
    required this.email,
    required this.panNumber,
    required this.gstNumber,
    required this.aadhaarNumber,
    required this.address,
    required this.pincode,
    required this.bankAccountNumber,
    required this.ifscCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorName': vendorName,
      'phone': phone,
      'email': email,
      'panNumber': panNumber,
      'gstNumber': gstNumber,
      'aadhaarNumber': aadhaarNumber,
      'address': address,
      'pincode': pincode,
      'bankAccountNumber': bankAccountNumber,
      'ifscCode': ifscCode,
    };
  }
}
