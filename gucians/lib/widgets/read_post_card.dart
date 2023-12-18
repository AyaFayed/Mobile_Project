import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gucians/models/comment_model.dart';
import 'package:gucians/models/non_database_models/user_to_post.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/widgets/user_img.dart';

import '../models/post_model.dart';
import 'package:flutter/material.dart';

class ReadPostCard extends StatefulWidget {
  final Post post;
  final UserModel owner;
  UserToPost userToPost;
  Function func;
  // var comments=post.commentIds;
  ReadPostCard(
      {super.key,
      required this.post,
      required this.owner,
      required this.userToPost,
      required this.func});

  @override
  State<ReadPostCard> createState() => _ReadPostCardState();
}

class _ReadPostCardState extends State<ReadPostCard> {
  final commentController = TextEditingController();

  static String getTime(DateTime createdAt) {
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
    print('*************************************');
    print(path);
    try {
      print(widget.owner.photoUrl);
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
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'reporters': reporters,
      });

      print('Reporting updated successfully!');
    } catch (e) {
      print('Error updating Reporting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipOval(
                    child: FutureBuilder(
                      future: getImageURL(
                          widget.post.category == 'confession' &&
                                  widget.post.anonymous!
                              ? 'Anonymous.png'
                              : widget.owner.photoUrl ??
                                  'unassigned.png'), // Fetch the image URL
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Display a loading indicator while fetching the image
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Text('No Image');
                        } else {
                          print(snapshot.data);
                          return Image.network(
                            snapshot.data.toString(),
                            height: 45,
                            width: 45,
                          ); // Display the image using the retrieved URL
                        }
                      },
                    ),
                    // Image.asset(
                    //   'lib/icons/AYB.jpg', // Replace with your image URL
                    //   width: 45, // Set the desired width
                    //   height: 45, // Set the desired height
                    //   fit: BoxFit
                    //       .cover, // Adjust the fit of the image within the circle
                    // ),
                  ),
                ),
                Container(
                  //  decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 0),
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.post.category == 'confession' &&
                                    widget.post.anonymous! &&
                                    !widget.userToPost.myPost()
                                ? 'Anonymous Gucian'
                                : widget.post.category == 'confession' &&
                                        widget.post.anonymous!
                                    ? 'Me Anonymously'
                                    : widget.owner.handle,
                            style: const TextStyle(),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.ltr,
                          )),
                      Text(getTime(widget.post.createdAt))
                    ],
                  ),
                ),
                const Spacer(),
                (widget.userToPost.myPost())
                    ? PopupMenuButton<String>(
                        onSelected: (String result) {
                          print('Selected: $result');
                          if (result == 'Delete') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Confession'),
                                  content: const Text(
                                      'Are you sure you want to delete this confession?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        widget.func(widget.post.id);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          // Perform an action based on the selected item
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Modify',
                            child: Text('Modify Post'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete Post'),
                          ),
                        ],
                      )
                    : PopupMenuButton<String>(
                        onSelected: (String result) {
                          print('Selected: $result');
                          widget.userToPost.reportedPost()
                              ? widget.post.reporters.removeWhere((element) =>
                                  element == widget.userToPost.myId)
                              : widget.post.reporters
                                  .add(widget.userToPost.myId);

                          updateReporting(
                              widget.post.id!, widget.post.reporters);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'report',
                            child: Text(widget.userToPost.reportedPost()
                                ? 'Unreport Post'
                                : 'Report To Admin'),
                          ),
                        ],
                      )
              ]),
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 5, 10, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.post.content,
                    textAlign: TextAlign.start,
                  )),
              if (widget.post.file != null)
                Container(
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: FutureBuilder(
                      future: getImageURL(widget.post.file ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Text('No Image');
                        } else {
                          print(snapshot.data);
                          print('/*/*/*/*/*/*/*/*/*/*');
                          return CachedNetworkImage(
                            imageUrl: snapshot.data.toString(),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          );
                        }
                      },
                    )

                    // FutureBuilder(
                    //     future: getImageURL(widget.post.file??''), // Fetch the image URL
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return CircularProgressIndicator(); // Display a loading indicator while fetching the image
                    //       } else if (snapshot.hasError) {
                    //         return Text('Error: ${snapshot.error}');
                    //       } else if (!snapshot.hasData || snapshot.data == null) {
                    //         return Text('No Image');
                    //       } else {
                    //         print(snapshot.data);
                    //         return Image.network(snapshot.data.toString()); // Display the image using the retrieved URL
                    //       }
                    //     },
                    //   ),

                    ),
              SizedBox(
                width: double.infinity, // To take the full width of the card
                child: Divider(
                  color: AppColors.darkGrey, // Color of the line
                  thickness: 1, // Thickness of the line
                ),
              ),
              Container(
                child: Row(
                  children: [
                    voteComponent(
                      userToPost: widget.userToPost,
                      post: widget.post,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                // Set your preferred height for the bottom sheet
                                child: commentsComponent(
                                    commentIds: widget.post.commentIds,
                                    category: widget.post.category,
                                    anonymous: widget.post.anonymous ?? false,
                                    postOwnerId: widget.post.authorId));
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chat_outlined, color: AppColors.darkGrey),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Comment")
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class voteComponent extends StatefulWidget {
  UserToPost userToPost;
  Post post;

  voteComponent({super.key, required this.userToPost, required this.post});

  @override
  State<voteComponent> createState() => _voteComponentState();
}

class _voteComponentState extends State<voteComponent> {
  Future<void> updateVoting(
      String postId, dynamic upVoters, dynamic downVoters) async {
    try {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'upVoters': upVoters,
        'downVoters': downVoters,
      });

      print('Voting updated successfully!');
    } catch (e) {
      print('Error updating post attribute: $e');
    }
  }

  Future<void> vote(int v) async {
    if (v > 0) {
      //upvote
      if (widget.userToPost.upvoted()) {
        widget.post.upVoters
            .removeWhere((element) => element == widget.userToPost.myId);
      } else {
        widget.post.upVoters.add(widget.userToPost.myId);
        widget.post.downVoters
            .removeWhere((element) => element == widget.userToPost.myId);
      }
    } else {
      //downvote
      if (widget.userToPost.downvoted()) {
        widget.post.downVoters
            .removeWhere((element) => element == widget.userToPost.myId);
      } else {
        widget.post.downVoters.add(widget.userToPost.myId);
        widget.post.upVoters
            .removeWhere((element) => element == widget.userToPost.myId);
      }
    }

    //update the database
    setState(() {
      widget.userToPost =
          UserToPost(post: widget.post, myId: widget.userToPost.myId);
    });

    updateVoting(widget.post.id!, widget.post.upVoters, widget.post.downVoters);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            vote(1);
          },
          icon: Icon(widget.userToPost.upvoted()
              ? Icons.thumb_up_rounded
              : Icons.thumb_up_outlined),
          color: AppColors.darkGrey,
        ),
        Text((widget.post.upVoters.length - widget.post.downVoters.length)
            .toString()),
        IconButton(
            onPressed: () {
              vote(-1);
            },
            icon: Icon(widget.userToPost.downvoted()
                ? Icons.thumb_down_alt_rounded
                : Icons.thumb_down_outlined),
            color: AppColors.darkGrey),
      ],
    );
  }
}

class commentsComponent extends StatefulWidget {
  List<String> commentIds;
  String postOwnerId;
  String category;
  bool anonymous;
  commentsComponent(
      {super.key,
      required this.commentIds,
      required this.category,
      required this.anonymous,
      required this.postOwnerId});

  @override
  State<commentsComponent> createState() => _commentsComponentState();
}

class _commentsComponentState extends State<commentsComponent> {
  var comments = [];
  bool loading = true;

  Future<void> getComments() async {
    final firestore = FirebaseFirestore.instance;
    final List<Comment> fetchedComments = [];
    final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        await Future.wait(widget.commentIds.map(
      (id) => firestore.collection('comments').doc(id).get(),
    ));

    for (var snapshot in snapshots) {
      if (snapshot.exists) {
        fetchedComments.add(Comment.fromJson(snapshot.data()!, snapshot.id));
      }
    }
    setState(() {
      comments = fetchedComments;
      loading = false;
    });
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
            heightFactor: 10.0,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.commentIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          leading: ClipOval(
                              child: UserImg(
                            anonymous: widget.category == 'confession' &&
                                widget.anonymous,
                            path: comments[index].authorImgUrl,
                          )
                              ),
                          title: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.lightGrey,
                              ),
                              margin: const EdgeInsets.only(top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        comments[index].authorHandle,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Text(comments[index].content),
                                ],
                              )),
                        ));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'What do you think?',
                    border: OutlineInputBorder(
                      // Border configuration
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.8), // Set border color and width
                    ),
                  ),
                ),
              ),
              // Add your comment widgets here
            ],
          );
  }
}
