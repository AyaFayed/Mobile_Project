import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/models/user_model.dart';
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

  Future<void> getPosts() async {
    final List<Post> fetchedPosts = [];
    final List<UserModel> fetchedUsers = [];
    final _firestore = FirebaseFirestore.instance;

    print('///////////////////////////////////');
    print(this.widget.category);
    final QuerySnapshot<Map<String, dynamic>> querySnapshotPosts =
        await _firestore
            .collection('posts')
            .where('category', isEqualTo: this.widget.category)
            .get();

    querySnapshotPosts.docs.forEach((doc) {
      fetchedPosts.add(Post.fromJson(doc.data(), doc.id));
    });

    final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        await Future.wait(fetchedPosts.map(
      (post) => _firestore.collection('user').doc(post.authorId).get(),
    ));

    for (var snapshot in snapshots) {
      if (snapshot.exists) {
        fetchedUsers.add(UserModel.fromJson(snapshot.data()!));
      }
    }

    setState(() {
      print("UnBlock ${this.widget.category}");
      loading = false;
      posts = fetchedPosts;
      users = fetchedUsers;
      
    });
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
    print("Building for ${this.widget.category} +++++++++++++++++++++++++++++");
    print(posts);
    return loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return ReadPostCard(post: posts[index], owner: users[index]);
            },
          );
  }
}
