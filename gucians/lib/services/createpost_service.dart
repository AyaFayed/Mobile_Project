import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/services/hashing_service.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:image_picker/image_picker.dart';

Future<void> addPost(String content, bool anonymous, String category, XFile? image,
    List<String> tags) async{
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  String? imageUrl;
  if(image != null) {
     imageUrl = await getImageUrl(image);
  }
  String authorId = UserInfoService.getCurrentUserId();
  // check to hash the id before adding the author_id
  if (anonymous) {
    authorId = Hashing.hash(authorId);
  }
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
    createdAt: DateTime.now(),
  );
  posts
      .add(post.toJson())
      .then((value) => print('Document added with ID: ${value.id}'))
      .catchError((error) => print('Failed to add document: $error'));
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