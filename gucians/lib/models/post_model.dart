class Post {
  String id;
  String content;
  String? file;
  String authorId;
  List<String> commentIds;
  List<String> tags;
  int votes;
  DateTime createdAt;

  Post(
      {required this.id,
      required this.content,
      required this.file,
      required this.authorId,
      required this.commentIds,
      required this.tags,
      required this.votes,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'file': file,
        'authorId': authorId,
        'commentIds': commentIds,
        'tags': tags,
        'votes': votes,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        content: json['content'],
        file: json['file'],
        authorId: json['authorId'],
        commentIds: (json['commentIds'] as List<dynamic>).cast<String>(),
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        votes: json['votes'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}
