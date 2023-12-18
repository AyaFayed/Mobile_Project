import 'package:flutter/material.dart';
import 'package:gucians/widgets/posts_by_category.dart';

class LostAndFound extends StatelessWidget {
  const LostAndFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add_post',arguments: {'category':'lost_and_found'});
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: const PostsByCategory(category: 'lost_and_found'),
    );
  }
}
