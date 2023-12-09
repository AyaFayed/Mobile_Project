import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/themes.dart';

import '../models/post_model.dart';
import 'package:flutter/material.dart';

class ReadPostCard extends StatelessWidget {
  final Post post;
  // var comments=post.commentIds;
  const ReadPostCard({super.key, required this.post});

  void _showComments(BuildContext context) {
    final comments = [1, 2, 3];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,

            // Replace this with your list of comments widget
            child: 
            ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(top: 5, bottom: 10),
                    child: ListTile(
                     contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading:
                        ClipOval(
                          child: Image.asset(
                            'lib/icons/AYB.jpg', // Replace with your image URL
                            width: 45, // Set the desired width
                            height: 45, // Set the desired height
                            fit: BoxFit
                                .cover, // Adjust the fit of the image within the circle
                          ),
                        ),
                        title:Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColors.lightGrey, ),
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
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
    int seconds = difference.inSeconds;
    int months = (days ~/ 30) as int;
    int years = (months ~/ 12) as int;
    if (years > 0) return years.toString() + "y ago";
    if (months > 0) return months.toString() + "mo ago";
    if (days > 0) return days.toString() + "days ago";
    if (hours > 0) return hours.toString() + "h ago";
    if (minutes > 0) return minutes.toString() + "52min ago";
    return "few seconds ago";
  }

  bool myOwnPost() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/icons/AYB.jpg', // Replace with your image URL
                      width: 45, // Set the desired width
                      height: 45, // Set the desired height
                      fit: BoxFit
                          .cover, // Adjust the fit of the image within the circle
                    ),
                  ),
                ),
                Container(
                  //  decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 0),
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "AYB Club",
                            style: TextStyle(),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.ltr,
                          )),
                      Text(getTime(post.createdAt))
                    ],
                  ),
                ),
                Spacer(),
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
                  margin: EdgeInsets.fromLTRB(15, 5, 10, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    post.content,
                    textAlign: TextAlign.start,
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
                  child: Image.asset('lib/icons/ClubPost.jpg')),
              Container(
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
                      icon: Icon(Icons.thumb_up_outlined),
                      color: AppColors.darkGrey,
                    ),
                    Text(post.votes.toString()),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.thumb_down_outlined),
                        color: AppColors.darkGrey),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        _showComments(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chat_outlined, color: AppColors.darkGrey),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Comment")
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
