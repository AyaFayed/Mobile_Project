import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/comment_model.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/models/user_model.dart';

String getTime(DateTime createdAt) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(createdAt);
  int days = difference.inDays;
  int hours = difference.inHours;
  int minutes = difference.inMinutes;
  int months = (days ~/ 30);
  int years = (months ~/ 12);
  if (years > 0) return "${years}y ago";
  if (months > 0) return "${months}mo ago";
  if (days > 0) return "${days}days ago";
  if (hours > 0) return "${hours}h ago";
  if (minutes > 0) return "${minutes}min ago";
  return "few seconds ago";
}

Future<String?> getImageURL(String path) async {
  try {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(path); // Replace with your image path
    String x = await ref.getDownloadURL();
    return x;
  } catch (e) {
    print('Error fetching image URL: $e');
    return null;
  }
}

Future<void> updateReporting(String postId, dynamic reporters) async {
  try {
    DocumentReference postRef = DatabaseReferences.posts.doc(postId);
    await postRef.update({
      'reporters': reporters,
    });

    print('Reporting updated successfully!');
  } catch (e) {
    print('Error updating Reporting: $e');
  }
}

Future<void> updateVoting(
    String postId, dynamic upVoters, dynamic downVoters) async {
  try {
    DocumentReference postRef = DatabaseReferences.posts.doc(postId);
    await postRef.update({
      'upVoters': upVoters,
      'downVoters': downVoters,
    });

    print('Voting updated successfully!');
  } catch (e) {
    print('Error updating post attribute: $e');
  }
}

Future<List<Comment>> fetchComments(List<String> commentIds) async {
  final List<Comment> fetchedComments = [];
  final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
      await Future.wait(commentIds.map(
    (id) => DatabaseReferences.comments.doc(id).get(),
  ));
  for (var snapshot in snapshots) {
    if (snapshot.exists) {
      fetchedComments.add(Comment.fromJson(snapshot.data()!, snapshot.id));
    }
  }
  return fetchedComments;
}

Future<void> deleteCommentInDB(
    String idToDelete, String postId, List<String> commentsIds) async {
  try {
    await DatabaseReferences.comments.doc(idToDelete).delete();
    await DatabaseReferences.posts
        .doc(postId)
        .update({'commentIds': commentsIds});
    print('comment deleted successfully.');
  } catch (e) {
    print('Error deleting post: $e');
  }
}

Future<void> deletePostInDB(String idToDelete) async {
  try {
    await DatabaseReferences.posts.doc(idToDelete).delete();
    print('post deleted successfully.');
  } catch (e) {
    print('Error deleting post: $e');
  }
}

Future<List<Post>> fetchPosts(String category) async {
  final List<Post> fetchedPosts = [];
  final QuerySnapshot<Map<String, dynamic>> querySnapshotPosts =
      await DatabaseReferences.posts
          .where('category', isEqualTo: category)
          .where('approved', isEqualTo: true)
          .get();

  for (var doc in querySnapshotPosts.docs) {
    fetchedPosts.add(Post.fromJson(doc.data(), doc.id));
  }
  fetchedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return fetchedPosts;
}

Future<List<UserModel>> fetchUsers(List<Post> posts) async {
  final List<UserModel> fetchedUsers = [];
  final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
      await Future.wait(posts.map(
    (post) => DatabaseReferences.users.doc(post.authorId).get(),
  ));

  for (var snapshot in snapshots) {
    if (snapshot.exists) {
      fetchedUsers.add(UserModel.fromJson(snapshot.data()!));
    } else {
      fetchedUsers.add(UserModel(
          id: 'id',
          name: 'name',
          email: 'email',
          handle: 'handle',
          type: 'type',
          tokens: [],
          allowNewsNotifications: false,
          userNotifications: [],
          allowLostAndFoundNotifications: false));
    }
  }
  return fetchedUsers;
}
