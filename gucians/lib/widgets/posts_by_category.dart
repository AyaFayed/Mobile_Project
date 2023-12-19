import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/models/non_database_models/user_to_post.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:gucians/widgets/read_post_card.dart';

class PostsByCategory extends StatefulWidget {
  final String category;
  const PostsByCategory({Key? key, required this.category})
      : super(key: key);

  @override
  _PostsByCategoryState createState() => _PostsByCategoryState();
}

class _PostsByCategoryState extends State<PostsByCategory> {
  bool loading = true;
  var posts = [];
  var users = [];
String userId='';

 Future<void> deletePost(String idToDelete) async {
  final idx=posts.indexWhere((element) => element.id==idToDelete);
  posts.removeAt(idx);
  users.removeAt(idx);
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('posts').doc(idToDelete).delete();
    print('post deleted successfully.');
  } catch (e) {
    print('Error deleting post: $e');
  }
  setState(() {
    
  });
}
  Future<void> getPosts() async {
    final List<Post> fetchedPosts = [];
    final List<UserModel> fetchedUsers = [];
    final firestore = FirebaseFirestore.instance;

    print('///////////////////////////////////');
    print(widget.category);
    final QuerySnapshot<Map<String, dynamic>> querySnapshotPosts =
        await firestore
            .collection('posts')
            .where('category', isEqualTo: widget.category)
            .get();

    for (var doc in querySnapshotPosts.docs) {
      fetchedPosts.add(Post.fromJson(doc.data(), doc.id));
    }

    final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        await Future.wait(fetchedPosts.map(
      (post) => firestore.collection('users').doc(post.authorId).get(),
    ));

    for (var snapshot in snapshots) {
      if (snapshot.exists) {
        fetchedUsers.add(UserModel.fromJson(snapshot.data()!));
      }
      else{
        fetchedUsers.add(UserModel(id: 'id', name: 'name', email: 'email', handle: 'handle', type: 'type', tokens: [], allowNewsNotifications: false, userNotifications: [], allowLostAndFoundNotifications: false));
      }
    }

    setState(() {
      print("UnBlock ${widget.category}");
      getCurrentUserId();
      loading = false;
      posts = fetchedPosts;
      users = fetchedUsers;
      
    });
  }


  void getCurrentUserId() {
  
    userId=UserInfoService.getCurrentUserId();
  
}
  @override
  void initState() {
   loading = true;
   posts = [];
   users = [];

    getPosts();
    super.initState();

    // loading=true;
  }
  
   @override
  void didUpdateWidget(covariant PostsByCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      // If the category changes, fetch new posts
      setState(() {
        loading = true; // Set loading state before fetching new posts
        posts.clear(); // Clear previous posts
        users.clear(); // Clear previous users
      });
      getPosts(); // Fetch new posts for the updated category
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building for ${widget.category} +++++++++++++++++++++++++++++");
    print(posts);
    return loading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              UserToPost userToPost=UserToPost(post: posts[index], myId: userId);
              return ReadPostCard(post: posts[index], owner: users[index],userToPost: userToPost,func:deletePost);
            },
          );
  }
}
