class UserModel {
  String id;
  String name;
  String handle;
  String? photoUrl;
  bool isStaff;
  String? roomLocationId;
  int rating;
  int ratingsCount;

  UserModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.photoUrl,
    required this.isStaff,
    required this.roomLocationId,
    required this.rating,
    required this.ratingsCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'handle': handle,
        'photoUrl': photoUrl,
        'isStaff': isStaff,
        'roomLocationId': roomLocationId,
        'rating': rating,
        'ratingsCount': ratingsCount
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      handle: json['handle'],
      photoUrl: json['photoUrl'],
      isStaff: json['isStaff'],
      roomLocationId: json['roomLocationId'],
      rating: json['rating'],
      ratingsCount: json['ratingsCount']);
}
