class Post {
  String? id;
  String content;
  String? file;
  String authorId;
  List<String> commentIds;
  List<String> tags;
  List<String> upVoters;
  List<String> downVoters;
  List<String> reporters;
  String category;
  bool? approved;
  bool? anonymous;
  DateTime createdAt;

  Post(
      {this.id,
      required this.content,
      this.file,
      required this.authorId,
      required this.commentIds,
      required this.tags,
      required this.upVoters,
      required this.downVoters,
      required this.reporters,
      required this.category,
      this.approved,
      this.anonymous,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'file': file,
        'authorId': authorId,
        'commentIds': commentIds,
        'tags': tags,
        'upVoters': upVoters,
        'downVoters': downVoters,
        'reporters': reporters,
        'category': category,
        'approved': approved,
        'anonymous': anonymous,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Post fromJson(Map<String, dynamic> json, String docId) => Post(
        id: docId,
        content: json['content'],
        file: json['file'],
        authorId: json['authorId'],
        commentIds: (json['commentIds'] as List<dynamic>).cast<String>(),
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        upVoters: (json['upVoters'] as List<dynamic>).cast<String>(),
        downVoters: (json['downVoters'] as List<dynamic>).cast<String>(),
        reporters: (json['reporters'] as List<dynamic>).cast<String>(),
        category: json['category'],
        approved: json['approved'],
        anonymous: json['anonymous'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}
