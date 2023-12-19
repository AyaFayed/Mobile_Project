class Comment {
  String id;
  String content;
  // String authorId;
  String authorHandle;
  String? authorImgUrl;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.authorHandle,
    this.authorImgUrl,
    // required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        // 'authorId': authorId,
        'authorHandle':authorHandle,
        'authorImgUrl':authorImgUrl,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Comment fromJson(Map<String, dynamic> json,String id) => Comment(
        id: id,
        content: json['content'],
        authorHandle: json['authorHandle'],
        authorImgUrl: json['authorImgUrl'],
        // authorId: json['authorId'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}
