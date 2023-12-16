import 'package:firebase_storage/firebase_storage.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/theme/colors.dart';

import '../models/post_model.dart';
import 'package:flutter/material.dart';

class ReadPostCard extends StatelessWidget {
  final commentController = TextEditingController();
  final Post post;
  final UserModel owner;
  // var comments=post.commentIds;
  ReadPostCard({super.key, required this.post,required this.owner});

  void _showComments(BuildContext context) {
    final comments = [1, 2, 3];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Comments'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,

                // Replace this with your list of comments widget
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          leading: ClipOval(
                            child: Image.asset(
                              'lib/icons/AYB.jpg', // Replace with your image URL
                              width: 45, // Set the desired width
                              height: 45, // Set the desired height
                              fit: BoxFit
                                  .cover, // Adjust the fit of the image within the circle
                            ),
                          ),
                          title: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.lightGrey,
                            ),
                            margin: const EdgeInsets.only(top: 10),
                            child: const Text(
                              "I see this is tooo interesting, i feel that i strongly want to take part and start voluteering to save people",
                            ),
                          ),
                        ));
                  },
                ),
                //  ListView(
                //   children: [
                //     ListTile(
                //       title: Text('Comment 1'),
                //     ),
                //     ListTile(
                //       title: Text('Comment 2'),
                //     ),
                //     // Add more comments here
                //   ],
                // ),
              ),
              TextField(controller: commentController)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

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

  bool myOwnPost() {
    return false;
  }

  Future<String?> getImageURL(String path) async {
    print('*************************************');
    print(path);
    try {
      print(owner.photoUrl);
      Reference ref = FirebaseStorage.instance.ref().child(path); // Replace with your image path
      String x= await ref.getDownloadURL();
      return x;
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
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
                    child: 
                    FutureBuilder(
                      future: getImageURL(owner.photoUrl??''), // Fetch the image URL
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Display a loading indicator while fetching the image
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('No Image');
                        } else {
                          print(snapshot.data);
                          return Image.network(snapshot.data.toString(),height: 45,width: 45,); // Display the image using the retrieved URL
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
                            owner.handle??'',
                            style: TextStyle(),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.ltr,
                          )),
                      Text(getTime(post.createdAt))
                    ],
                  ),
                ),
                const Spacer(),
                (myOwnPost())
                    ? PopupMenuButton<String>(
                        onSelected: (String result) {
                          print('Selected: $result');
                          // Perform an action based on the selected item
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'option_1',
                            child: Text('Modify Post'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'option_2',
                            child: Text('Delete Post'),
                          ),
                        ],
                      )
                    : PopupMenuButton<String>(
                        onSelected: (String result) {
                          print('Selected: $result');
                          // Perform an action based on the selected item
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'option_1',
                            child: Text('Report To Admin'),
                          ),
                        ],
                      )
              ]),
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 5, 10, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    post.content,
                    textAlign: TextAlign.start,
                  )),
                  if(post.file!=null)
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: FutureBuilder(
                      future: getImageURL(post.file??''), // Fetch the image URL
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Display a loading indicator while fetching the image
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('No Image');
                        } else {
                          print(snapshot.data);
                          return Image.network(snapshot.data.toString()); // Display the image using the retrieved URL
                        }
                      },
                    ),),
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_outlined),
                      color: AppColors.darkGrey,
                    ),
                    Text(post.votes.toString()),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_down_outlined),
                        color: AppColors.darkGrey),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        _showComments(context);
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
