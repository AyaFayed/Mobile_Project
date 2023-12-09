import 'package:flutter/material.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/widgets/read_post_card.dart';

class news extends StatefulWidget {
  const news({super.key});

  @override
  State<news> createState() => _newsState();
}

class _newsState extends State<news> {
  var newsPosts  = [
    Post(
        authorId: "authId1",
        id: "PostId1",
        content:
            "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem",
        commentIds: [],
        tags: [],
        votes: 2,
        category: "news",
        createdAt: DateTime.now(),
        file: "what is file??"),
    Post(
        authorId: "authId1",
        id: "PostId1",
        content:
            "lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem",
        commentIds: [],
        tags: [],
        votes: 2,
        category: "news",
        createdAt: DateTime.now(),
        file: "what is file??")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text("News"),
      ),
      body: ListView.builder(
                itemCount: newsPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReadPostCard(post: newsPosts[index]);
                },
              ),
    );
  }
}
