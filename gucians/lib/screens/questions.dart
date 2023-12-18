import 'package:flutter/material.dart';
import 'package:gucians/widgets/posts_by_category.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return const PostsByCategory(category: 'question');
  }
}