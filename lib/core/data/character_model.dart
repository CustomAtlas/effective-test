import 'dart:convert';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String image;
  final bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.image,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': origin,
      'image': image,
      'isFavorite': isFavorite,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      gender: map['gender'] as String,
      origin: map['origin'] is String ? map['origin'] : map['origin']['name'] as String,
      image: map['image'] as String,
      isFavorite: map['isFavorite'] != null ? map['isFavorite'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) => Character.fromMap(json.decode(source) as Map<String, dynamic>);

  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? origin,
    String? image,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
