class UserModel {
  String id;
  String name;
  String email;
  String handle;
  String? photoUrl;
  String type;
  String? roomLocationId;
  Map<String,double>? ratings;
  List<String> tokens;
  bool allowNewsNotifications;
  bool allowLostAndFoundNotifications;
  List<UserNotification> userNotifications;
  String? office;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.handle,
    required this.photoUrl,
    required this.photoUrl,
    required this.type,
    required this.roomLocationId,
    required this.ratings,
    required this.tokens,
    required this.allowNewsNotifications,
    required this.allowLostAndFoundNotifications,
    required this.userNotifications,
    this.office
  });


  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'handle': handle,
        'photoUrl': photoUrl,
        'type': type,
        'roomLocationId': roomLocationId,
        'ratings':ratings,
        'office': office,
        'tokens': tokens,
        'allowNewsNotifications': allowNewsNotifications,
        'allowLostAndFoundNotifications': allowLostAndFoundNotifications,
        'userNotifications': userNotifications
            .map((notification) => notification.toJson())
            .toList(),
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        handle: json['handle'],
        photoUrl: json['photoUrl'],
        type: json['type'],
        roomLocationId: json['roomLocationId'],
        ratings: (json['ratings'] as Map<String, dynamic>).cast<String, double>(),
        tokens: (json['tokens'] as List<dynamic>).cast<String>(),
        allowNewsNotifications: json['allowNewsNotifications'],
        allowLostAndFoundNotifications: json['allowLostAndFoundNotifications'],
        userNotifications: ((json['userNotifications'] ?? []) as List<dynamic>)
            .map((notification) => UserNotification.fromJson(notification))
            .toList(),
    office: json['office']
      );
}

class UserNotification {
  String id;
  bool seen;

  UserNotification({required this.id, required this.seen});

  Map<String, dynamic> toJson() => {'id': id, 'seen': seen};

  static UserNotification fromJson(Map<String, dynamic> json) =>
      UserNotification(id: json['id'], seen: json['seen']);
}
