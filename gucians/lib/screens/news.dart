// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gucians/models/non_database_models/user_to_post.dart';
// import 'package:gucians/models/post_model.dart';
// import 'package:gucians/models/user_model.dart';
// import 'package:gucians/widgets/read_post_card.dart';

// class news extends StatefulWidget {
//   const news({super.key});

//   @override
//   State<news> createState() => _newsState();
// }

// class _newsState extends State<news> {
//   bool loading=true;
//   var newsPosts =[]; 
//   // [
//   //   Post(
//   //       authorId: "authId1",
//   //       id: "PostId1",
//   //       content:
//   //           "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem",
//   //       commentIds: [],
//   //       tags: [],
//   //       votes: 2,
//   //       category: "news",
//   //       createdAt: DateTime.now(),
//   //       file: "what is file??"),
//   //   Post(
//   //       authorId: "authId1",
//   //       id: "PostId1",
//   //       content:
//   //           "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem",
//   //       commentIds: [],
//   //       tags: [],
//   //       votes: 2,
//   //       category: "news",
//   //       createdAt: DateTime.now(),
//   //       file: "what is file??")
//   // ];
//   var newsUsers=[];
//   Future<void> getPosts() async {
//     final List<Post> posts = [];
//     final List<UserModel> users = [];
//     final _firestore = FirebaseFirestore.instance;
//     final QuerySnapshot<Map<String, dynamic>> querySnapshotPosts =
//         await _firestore.collection('posts').where('category', isEqualTo: 'news').get();
//     querySnapshotPosts.docs.forEach((doc) {
//       posts.add(Post.fromJson(doc.data(), doc.id));
//     });
    
    
//     final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
//         await Future.wait(posts.map(
//             (post) => _firestore.collection('user').doc(post.authorId).get()));
//     for (var snapshot in snapshots) {
//       if (snapshot.exists) {
//         users.add(UserModel.fromJson(snapshot.data()!));
//       }
//       setState(() {
//         loading=false;
//         newsPosts = posts;
//         newsUsers = users;
//       });
//     }
//   }
//   @override
//   void initState() {
//     getPosts();
//     // var x = FirebaseFirestore.instance
//     //     .collection('post')
//     //     .get()
//     //     .then((QuerySnapshot querySnapshot) {
//     //   querySnapshot.docs.forEach((doc) {
//     //     // Accessing content of each document
//     //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     //     print(
//     //         "***************+++++++++++++++++******************"); // Accessing 'content' field
//     //     // You can do further operations with the data here
//     //   });
//     // }).catchError((err) {
//     //   print("88888888888888888888888888877777777777777777777");
//     // });
//     // print(
//     //     "//////////////////////////////////////////////////////////////////////");
//     // print(x);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(newsUsers.length);
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {},
//         ),
//         title: const Text("News"),
//       ),
//       body:loading?Center(child: CircularProgressIndicator()): ListView.builder(
//         itemCount: newsPosts.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ReadPostCard(post: newsPosts[index],owner: newsUsers[index],userToPost: UserToPost(post: newsPosts[index],myId: ''),);
//         },
//       ),
//     );
//   }
// }
