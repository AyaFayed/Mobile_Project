class UserModel {
  String id;
  String name;
  String email;
  String handle;
  String? photoUrl;
  bool isStaff;
  String? roomLocationId;
  List<String> ratingIds;
  List<String> tokens;
  bool allowNewsNotifications;
  bool allowLostAndFoundNotifications;
  List<UserNotification> userNotifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.handle,
    required this.photoUrl,
    required this.isStaff,
    required this.roomLocationId,
    required this.ratingIds,
    required this.tokens,
    required this.allowNewsNotifications,
    required this.allowLostAndFoundNotifications,
    required this.userNotifications,
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
        isStaff: json['isStaff'],
        roomLocationId: json['roomLocationId'],
        ratingIds: (json['ratingIds'] as List<dynamic>).cast<String>(),
        tokens: (json['tokens'] as List<dynamic>).cast<String>(),
        allowNewsNotifications: json['allowNewsNotifications'],
        allowLostAndFoundNotifications: json['allowLostAndFoundNotifications'],
        userNotifications: ((json['userNotifications'] ?? []) as List<dynamic>)
            .map((notification) => UserNotification.fromJson(notification))
            .toList(),
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
