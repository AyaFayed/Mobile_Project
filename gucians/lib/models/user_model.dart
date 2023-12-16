class UserModel {
  String id;
  String name;
  String handle;
  String? photoUrl;
  String type;
  String? roomLocationId;
  int rating;
  int ratingsCount;

  UserModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.photoUrl,
    required this.type,
    required this.roomLocationId,
    required this.rating,
    required this.ratingsCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'handle': handle,
        'photoUrl': photoUrl,
        'type': type,
        'roomLocationId': roomLocationId,
        'rating': rating,
        'ratingsCount': ratingsCount
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      // id: json['id'],
      id:'id123',
      name: json['name'],
      handle: json['handle'],
      photoUrl: json['photoUrl'],
      type: json['type'],
      roomLocationId: json['roomLocationId'],
      rating: json['rating'],
      ratingsCount: json['ratingsCount']);
}
