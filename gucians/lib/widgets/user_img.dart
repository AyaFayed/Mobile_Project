import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserImg extends StatelessWidget {
  
  final bool anonymous;
  final String? path;
  const UserImg(
      {super.key,  required this.anonymous, this.path});
  static Future<String?> getImageURL(String path) async {
    print('*************************************');
    print(path);
    try {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageURL(
        anonymous
          ? 'Anonymous.png'
          : path ?? 'unassigned.png'), // Fetch the image URL
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }
}
