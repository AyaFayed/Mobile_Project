class UserModel {
  String id;
  String name;
  String email;
  String handle;
  String? photoUrl;
  bool isStaff;
  String? roomLocationId;
  List<String> ratingIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.handle,
    required this.photoUrl,
    required this.isStaff,
    required this.roomLocationId,
    required this.ratingIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'handle': handle,
        'photoUrl': photoUrl,
        'isStaff': isStaff,
        'roomLocationId': roomLocationId,
        'ratingIds': ratingIds,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      handle: json['handle'],
      photoUrl: json['photoUrl'],
      isStaff: json['isStaff'],
      roomLocationId: json['roomLocationId'],
      ratingIds: json['ratingIds']);
}
