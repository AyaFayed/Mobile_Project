class Confession {
  String id;
  String content;
  String authorId;
  bool isAnon;
  bool isApproved;
  List<String> commentIds;
  DateTime createdAt;

  Confession(
      {required this.id,
      required this.content,
      required this.authorId,
      required this.isAnon,
      required this.isApproved,
      required this.commentIds,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'authorId': authorId,
        'isAnon': isAnon,
        'isApproved': isApproved,
        'commentIds': commentIds,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Confession fromJson(Map<String, dynamic> json) => Confession(
        id: json['id'],
        content: json['content'],
        authorId: json['authorId'],
        isAnon: json['isAnon'],
        isApproved: json['isApproved'],
        commentIds: (json['commentIds'] as List<dynamic>).cast<String>(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}
