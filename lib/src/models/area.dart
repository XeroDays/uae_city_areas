/// Area model representing an area within a city/emirate
class Area {
  /// Unique identifier for the area
  final int id;

  /// Name of the area
  final String name;

  /// ID of the emirate/city this area belongs to
  final int emirateId;

  /// Creates an Area instance
  const Area({
    required this.id,
    required this.name,
    required this.emirateId,
  });

  /// Creates an Area instance from JSON map.
  /// Tolerates null or missing fields and alternate keys (e.g. areaId, areaName).
  factory Area.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['areaId'];
    final name = json['name'] ?? json['areaName'] ?? '';
    final emirateId = json['emirateId'] ?? json['emirateID'];
    return Area(
      id: id is int ? id : int.tryParse(id?.toString() ?? '0') ?? 0,
      name: name is String ? name : (name?.toString() ?? ''),
      emirateId: emirateId is int
          ? emirateId
          : int.tryParse(emirateId?.toString() ?? '0') ?? 0,
    );
  }

  /// Converts Area instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emirateId': emirateId,
    };
  }

  @override
  String toString() => 'Area(id: $id, name: $name, emirateId: $emirateId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Area &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          emirateId == other.emirateId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ emirateId.hashCode;
}
