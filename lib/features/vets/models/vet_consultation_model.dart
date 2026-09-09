class VetConsultationModel {
  final String? id;
  final String user_id;
  final String pet_id;
  final String vet_id;
  final DateTime appointment_date;
  final String status;

  VetConsultationModel({
    this.id,
    required this.user_id,
    required this.pet_id,
    required this.vet_id,
    required this.appointment_date,
    this.status = 'scheduled',
  });

  factory VetConsultationModel.fromJson(Map<String, dynamic> json) {
    return VetConsultationModel(
      id: json['_id'] as String?,
      user_id: json['user_id'] as String,
      pet_id: json['pet_id'] as String,
      vet_id: json['vet_id'] as String,
      appointment_date: DateTime.parse(json['appointment_date'] as String),
      status: json['status'] as String? ?? 'scheduled',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'user_id': user_id,
      'pet_id': pet_id,
      'vet_id': vet_id,
      'appointment_date': appointment_date.toIso8601String(),
      'status': status,
    };
  }
}
