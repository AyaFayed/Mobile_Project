class Location {
  String id;
  String name;
  String directions;
  String mapUrl;

  Location(
      {required this.id,
      required this.name,
      required this.directions,
      required this.mapUrl});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'directions': directions, 'mapUrl': mapUrl};

  static Location fromJson(Map<String, dynamic> json,String id) => Location(
      id: id,
      name: json['name'],
      directions: json['directions'],
      mapUrl: json['mapUrl']);
}
