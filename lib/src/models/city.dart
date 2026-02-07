/// City model representing an emirate/city from the API
class City {
  /// Unique identifier for the city/emirate
  final int id;

  /// English name of the city/emirate
  final String name;

  /// Arabic name of the city/emirate
  final String nameArabic;

  /// Creates a City instance
  const City({
    required this.id,
    required this.name,
    required this.nameArabic,
  });

  /// Creates a City instance from JSON map
  /// Maps from API's "emirate" terminology to "City"
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['emirateName'] as String,
      nameArabic: json['emirateNameArabic'] as String,
    );
  }

  /// Converts City instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameArabic': nameArabic,
    };
  }

  @override
  String toString() => 'City(id: $id, name: $name, nameArabic: $nameArabic)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          nameArabic == other.nameArabic;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ nameArabic.hashCode;
}
