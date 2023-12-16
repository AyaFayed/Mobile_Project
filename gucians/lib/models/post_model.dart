class Post {
  String id;
  String content;
  String? file;
  String authorId;
  List<String> commentIds;
  List<String> tags;
  int votes;
  String category;
  bool? approved;
  DateTime createdAt;

  Post(
      {required this.id,
      required this.content,
      required this.file,
      required this.authorId,
      required this.commentIds,
      required this.tags,
      required this.votes,
      required this.category,
      required this.approved,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'file': file,
        'authorId': authorId,
        'commentIds': commentIds,
        'tags': tags,
        'votes': votes,
        'category':category,
        'approved':approved,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Post fromJson(Map<String, dynamic> json,String docId) => Post(
        id:docId,
        content: json['content'],
        file: json['file'],
        authorId: json['authorId'],
        commentIds: (json['commentIds'] as List<dynamic>).cast<String>(),
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        votes: json['votes'],
        category: json['category'],
        approved: json['approved']??true,
        createdAt: json['createdAt'].toDate(),
      );
}
