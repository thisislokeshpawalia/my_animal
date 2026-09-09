class PetModel {
  final String? id;
  final String user_id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String health_notes;

  PetModel({
    this.id,
    required this.user_id,
    required this.name,
    required this.species,
    this.breed = '',
    this.age = 0,
    this.health_notes = '',
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'] as String?,
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      health_notes: json['health_notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'user_id': user_id,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'health_notes': health_notes,
    };
  }
}
