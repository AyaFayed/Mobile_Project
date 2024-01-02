import 'package:flutter/material.dart';
import 'package:gucians/models/non_database_models/user_to_post.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/services/post_database_services.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:gucians/widgets/read_post_card.dart';

class PostsByCategory extends StatefulWidget {
  final String category;
  const PostsByCategory({Key? key, required this.category}) : super(key: key);

  @override
  _PostsByCategoryState createState() => _PostsByCategoryState();
}

class _PostsByCategoryState extends State<PostsByCategory> {
  bool loading = true;
  var posts = [];
  var users = [];
  String userId = '';

  Future<void> deletePost(String idToDelete) async {
    final idx = posts.indexWhere((element) => element.id == idToDelete);
    posts.removeAt(idx);
    users.removeAt(idx);
    deletePostInDB(idToDelete);
    setState(() {});
  }

  Future<void> getPostsAndOwners() async {
    final fetchedPosts = await fetchPosts(widget.category);
    final List<UserModel> fetchedUsers = await fetchUsers(fetchedPosts);

    setState(() {
      userId = getCurrentUserId();
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
    getPostsAndOwners();
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
      getPostsAndOwners(); // Fetch new posts for the updated category
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : posts.isEmpty
            ? Center(
                child: Text('No ${widget.category} to display'),
              )
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  UserToPost userToPost =
                      UserToPost(post: posts[index], myId: userId);
                  return ReadPostCard(
                      post: posts[index],
                      owner: users[index],
                      userToPost: userToPost,
                      deletePostFunc: deletePost);
                },
              );
  }
}
