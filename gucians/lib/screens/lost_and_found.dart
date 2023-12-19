import 'package:flutter/material.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/widgets/posts_by_category.dart';

class LostAndFound extends StatelessWidget {
  const LostAndFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lost & Found',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.light),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add_post',
                    arguments: {'category': 'lost_and_found'});
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: const PostsByCategory(category: 'lost_and_found'),
    );
  }
}
