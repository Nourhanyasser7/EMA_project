
class Store {
  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;

  Store({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
