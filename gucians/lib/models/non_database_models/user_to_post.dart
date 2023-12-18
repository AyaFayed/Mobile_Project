import 'package:gucians/models/post_model.dart';
import 'package:gucians/services/hashing_service.dart';

class UserToPost {
  Post post;
  String myId;

  UserToPost({required this.post, required this.myId});

  bool upvoted() {
    return post.upVoters.contains(myId);
  }

  bool downvoted() {
    return post.downVoters.contains(myId);
  }

  bool myPost() {
    return post.category == 'confession' && post.anonymous!
        ? post.authorId == Hashing.hash(myId)
        : post.authorId == myId;
  }

  bool reportedPost() {
    return post.reporters.contains(myId);
  }
}
