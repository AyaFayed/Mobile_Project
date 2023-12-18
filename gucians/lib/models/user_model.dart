class UserModel {
  String id;
  String name;
  String handle;
  String? photoUrl;
  String type;
  String? roomLocationId;
  Map<String,double>? ratings;

  // int? rating;
  // int? ratingsCount;


  String? email;
  String? office;

  UserModel(
      {required this.id,
      required this.name,
      required this.handle,
      this.photoUrl,
      required this.type,
      this.roomLocationId,
      this.ratings,
      //  this.rating,
      //  this.ratingsCount,
      this.email,
      this.office});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'handle': handle,
        'photoUrl': photoUrl,
        'type': type,
        'roomLocationId': roomLocationId,
        'ratings':ratings,
        // 'rating': rating,
        // 'ratingsCount': ratingsCount,
        'office': office,
        'email': email,
      };

  static UserModel fromJson(Map<String, dynamic> json, String userId) =>
      UserModel(
          id: userId,
          // id:'id123',
          name: json['name'],
          handle: json['handle'],
          photoUrl: json['photoUrl'],
          type: json['type'],
          roomLocationId: json['roomLocationId'],
          ratings: (json['ratings'] as Map<String, dynamic>).cast<String, double>(),
          // rating: json['rating'],
          // ratingsCount: json['ratingsCount'],
          office: json['office'],
          email: json['email'],
          );

}
