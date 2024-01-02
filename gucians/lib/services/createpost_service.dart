import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/services/hashing_service.dart';
import 'package:gucians/services/perspectiveAPI.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gucians/common/enums/notification_type_enum.dart';
import 'package:gucians/controllers/notification_controller.dart';

Future<String> addPost(String content, bool anonymous, String category,
    XFile? image, List<String> tags) async {
  final NotificationController _notificationController =
      NotificationController();
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  String? imageUrl;
  if (image != null) {
    imageUrl = await getImageUrl(image);
  }
  String authorId = getCurrentUserId();
  // check to hash the id before adding the author_id
  if (anonymous) {
    authorId = Hashing.hash(authorId);
  }
  bool approved = true;
  if (category == "confession") approved = false;
  Post post = Post(
    anonymous: anonymous,
    content: content,
    file: imageUrl,
    commentIds: [],
    tags: tags,
    upVoters: [],
    downVoters: [],
    authorId: authorId,
    reporters: [],
    category: category,
    approved: approved,
    createdAt: DateTime.now(),
  );
  ApiResponse response = await perspectiveAPI.sendRequest(content);
  if (response.success && response.clean) {
    try {
      var value = await posts.add(post.toJson());
      print('Document added with ID: ${value.id}');

      switch (category) {
        case 'news':
          await _notificationController.createNewsNotification(
              "New Club Announcement",
              "New club announcement was added.",
              value.id,
              NotificationType.news);
          break;
        case 'lost_and_found':
          print("notification should be sent");
          await _notificationController.createLostAndFoundNotification(
              'Gucians',
              'New Lost and Found Post was added.',
              value.id,
              NotificationType.lostAndFound);
          break;
      }
    } catch (error) {
      print('Failed to add document: $error');
    }

    return 'clean';
  } else {
    if (response.success && !response.clean) {
      return 'dirty';
    } else {
      return 'failed';
    }
  }
}

Future<String?> getImageUrl(XFile imageFile) async {
  try {
    File image = File(imageFile.path);
    String imageName = image.path.split('/').last;
    print(imageName);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('$imageName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageName;
  } catch (error) {
    print('Failed to upload image: $error');
    return null;
  }
}

Future<String> editPost(Post post, XFile? newImage) async {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  if (newImage != null) {
    String? imageUrl = await getImageUrl(newImage);
    post.file = imageUrl;
  }
  ApiResponse response = await perspectiveAPI.sendRequest(post.content);
  if (response.success && response.clean) {
    posts.doc(post.id).update(post.toJson()).then((value) {
      print('Document with ID ${post.id} successfully updated.');
    }).catchError((error) {
      print('Failed to update document: $error');
    });
    return 'clean';
  } else {
    if (response.success && !response.clean) {
      return 'dirty';
    } else {
      return 'failed';
    }
  }
}
