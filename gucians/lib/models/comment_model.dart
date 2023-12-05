class Comment {
  String id;
  String content;
  String authorId;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'authorId': authorId,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Comment fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        content: json['content'],
        authorId: json['authorId'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}
