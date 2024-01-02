import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/comment_model.dart';
import 'package:gucians/models/non_database_models/user_to_post.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/services/post_database_services.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/widgets/user_img.dart';

import '../models/post_model.dart';
import 'package:flutter/material.dart';

class ReadPostCard extends StatefulWidget {
  final Post post;
  final UserModel owner;
  UserToPost userToPost;
  Function deletePostFunc;
  ReadPostCard(
      {super.key,
      required this.post,
      required this.owner,
      required this.userToPost,
      required this.deletePostFunc});

  @override
  State<ReadPostCard> createState() => _ReadPostCardState();
}

class _ReadPostCardState extends State<ReadPostCard> {
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
                          return Image.network(
                            snapshot.data.toString(),
                            height: 45,
                            width: 45,
                          ); // Display the image using the retrieved URL
                        }
                      },
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.ltr,
                        )),
                    Text(getTime(widget.post.createdAt))
                  ],
                ),
                const Spacer(),
                (widget.userToPost.myPost())
                    ? PopupMenuButton<String>(
                        onSelected: (String result) {
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
                                        widget.deletePostFunc(widget.post.id);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (result == "Modify") {
                            Navigator.pushNamed(context, ('/add_post'),
                                arguments: {'post': widget.post});
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
                      future: getImageURL(widget.post.file!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Text('No Image');
                        } else {
                          return CachedNetworkImage(
                            imageUrl: snapshot.data.toString(),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          );
                        }
                      },
                    )),
              SizedBox(
                width: double.infinity, // To take the full width of the card
                child: Divider(
                  color: AppColors.darkGrey, // Color of the line
                  thickness: 1, // Thickness of the line
                ),
              ),
              Row(
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: commentsComponent(
                                post: widget.post,
                              ));
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
  Post post;

  commentsComponent({
    super.key,
    required this.post,
  });

  @override
  State<commentsComponent> createState() => _commentsComponentState();
}

class _commentsComponentState extends State<commentsComponent> {
  var comments = [];
  bool loading = true;
  var commentContentCtrl = TextEditingController();
  var myHandle = '';
  var myImgUrl = '';

  Future<void> getComments() async {
    final List<Comment> fetchedComments =
        await fetchComments(widget.post.commentIds);
    setState(() {
      comments = fetchedComments;
      loading = false;
    });
  }

  Future<void> deleteComment(String idToDelete) async {
    comments.removeWhere((element) => element.id == idToDelete);
    widget.post.commentIds.removeWhere((element) => element == idToDelete);
    deleteCommentInDB(idToDelete, widget.post.id!, widget.post.commentIds);
    setState(() {});
  }

  @override
  void initState() {
    getUserAttribute('handle').then((value) => myHandle = value);
    getUserAttribute('photoUrl').then((value) => myImgUrl = value);
    getComments();
    super.initState();
  }

  Future<void> createComment(String content) async {
    commentContentCtrl.text = '';
    var authHandle = await getUserAttribute('handle');
    var authImgUrl = await getUserAttribute('photoUrl');

    var newComment = Comment(
        content: content,
        authorHandle: authHandle,
        authorImgUrl: authImgUrl != '' ? authImgUrl : null,
        createdAt: DateTime.now());
    DatabaseReferences.comments
        .add(newComment.toJson())
        .then((value) {
      widget.post.commentIds.add(value.id);
      comments.add(newComment);
      DatabaseReferences.posts
          .doc(widget.post.id)
          .update({'commentIds': widget.post.commentIds});
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            heightFactor: 10.0,
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 300,
                child: widget.post.commentIds.isEmpty
                    ?  Center(
                        child: Text('No Comments for This ${widget.post.category} Yet'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.post.commentIds.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 10),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                leading: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: ClipOval(
                                      child: UserImg(
                                    anonymous:
                                        widget.post.category == 'confession' &&
                                            widget.post.anonymous!,
                                    path: comments[index].authorImgUrl,
                                  )),
                                ),
                                title: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.lightGrey,
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  comments[index].authorHandle,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Spacer(),
                                            Text(getTime(
                                                comments[index].createdAt)),
                                            if (comments[index].authorHandle ==
                                                myHandle)
                                              PopupMenuButton<String>(
                                                onSelected: (String result) {
                                                  print('Selected: $result');
                                                  if (result == 'Delete') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Delete Comment'),
                                                          content: const Text(
                                                              'Are you sure you want to delete this comment?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                // widget.deletePostFunc(widget.post.id);
                                                                deleteComment(widget
                                                                        .post
                                                                        .commentIds[
                                                                    index]);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: const Text(
                                                                  'Delete'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String>>[
                                                  const PopupMenuItem<String>(
                                                    value: 'Delete',
                                                    child:
                                                        Text('Delete comment'),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
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
                  autofocus: true,
                  controller: commentContentCtrl,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        createComment(commentContentCtrl.text);
                      },
                    ),
                    hintText: 'What do you think?',
                    border: OutlineInputBorder(
                      // Border configuration
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                      borderSide: const BorderSide(
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
