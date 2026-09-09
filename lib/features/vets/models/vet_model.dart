class VetModel {
  final String id;
  final String name;
  final String specialty;
  final int experienceYears;
  final double rating;
  final double consultationFee;
  final String imageUrl;

  VetModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.rating,
    required this.consultationFee,
    required this.imageUrl,
  });

  factory VetModel.fromJson(Map<String, dynamic> json) {
    return VetModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      consultationFee: (json['consultation_fee'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
    );
  }
}
