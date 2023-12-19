import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gucians/models/post_model.dart';
import 'package:gucians/services/createpost_service.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  void deleteImage() {
    setState(() {
      image = null;
      if (oldPost!.file != "") oldPost!.file = "";
    });
  }

  final _postField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  String error = '';
  String category = '';
  bool anonymous = false;
  List<String> tags = [];
  Post? oldPost;
  void submitPost() {
    submitted = true;
    if (_formKey.currentState!.validate()) {
      OverlayEntry overlayEntry;

      overlayEntry = OverlayEntry(
        builder: (context) => AbsorbPointer(
          absorbing: true,
          child: Material(
            color: Colors.transparent,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry);

      if (oldPost != null) {
        oldPost?.content = _postField.text;
        editPost(oldPost!, image).then((value) {
          if (value == 'dirty' || value == 'failed') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Hate Speech Detected'),
                  content: Text('Please change your content.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(context).pop();
            switch (oldPost!.category) {
              case 'news':
                Navigator.of(context)
                    .pushReplacementNamed('/', arguments: {'selectedIdx': 0});
              case 'question':
                Navigator.of(context)
                    .pushReplacementNamed('/', arguments: {'selectedIdx': 1});
              case 'lost_and_found':
                Navigator.of(context).pushReplacementNamed('/lost_and_found');

                break;
              default:
            }
          }

          overlayEntry.remove();
        });
      } else {
        print(category);
        addPost(_postField.text, false, category, image, tags).then((value) {
          print(value);
          if (value == 'dirty' || value == 'failed') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Hate Speech Detected'),
                  content: Text('Please change your content.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(context).pop();
            switch (category) {
              case 'news':
                Navigator.of(context)
                    .pushReplacementNamed('/', arguments: {'selectedIdx': 0});
              case 'question':
                Navigator.of(context)
                    .pushReplacementNamed('/', arguments: {'selectedIdx': 1});
              case 'lost_and_found':
                Navigator.of(context).pushReplacementNamed('/lost_and_found');

                break;
              default:
            }
          }

          overlayEntry.remove();
        });
      }
    }
  }

  // Alert to take image as parameter
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String?> getImageURL(String path) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(path); // Replace with your image path
      String x = await ref.getDownloadURL();
      print("object");
      return x;
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      oldPost = routeArgs['post'];
      if (routeArgs['category'] != null) {
        category = routeArgs['category'];
      }

      print("object");
      if (oldPost != null) {
        _postField.text = oldPost!.content;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: oldPost == null
            ? Text("Add Post",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.light))
            : Text(
                "Edit Post",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.light),
              ),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Text';
                    }
                    return null;
                  },
                  maxLines: 8,
                  onChanged: (_) {
                    if (submitted) _formKey.currentState!.validate();
                  },
                  controller: _postField,
                  decoration: InputDecoration(
                    focusColor: AppColors.primary,
                    labelText: 'Your Post',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                ),
                Text(
                  error,
                  style:
                      TextStyle(color: AppColors.error, fontSize: Sizes.xsmall),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          myAlert();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.secondary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set the border radius
                            ),
                          ),
                        ),
                        child: Text(
                          'Add photo',
                          style: TextStyle(color: AppColors.dark),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          submitPost();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.confirm),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set the border radius
                            ),
                          ),
                        ),
                        child: Text(
                          'Post',
                          style: TextStyle(color: AppColors.light),
                        )),
                  ],
                ),
                if (image != null)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: 250,
                            height: 250,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            deleteImage();
                          },
                          style: ButtonStyle(
                            maximumSize:
                                MaterialStateProperty.all(Size(80, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set the border radius
                              ),
                            ),
                          ),
                          child: const Icon(Icons.clear),
                        ),
                      ),
                    ],
                  )
                else if (oldPost != null &&
                    oldPost!.file != null &&
                    oldPost!.file != "")
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FutureBuilder(
                              future: getImageURL(
                                  oldPost!.file!), // Fetch the image URL
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Display a loading indicator while fetching the image
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('No Image');
                                } else {
                                  print(snapshot.data);
                                  return Image.network(
                                    snapshot.data.toString(),
                                    height: 250,
                                    width: 250,
                                  ); // Display the image using the retrieved URL
                                }
                              },
                            )),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            deleteImage();
                          },
                          style: ButtonStyle(
                            maximumSize:
                                MaterialStateProperty.all(Size(80, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set the border radius
                              ),
                            ),
                          ),
                          child: const Icon(Icons.clear),
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    "No Image",
                    style: TextStyle(fontSize: 20),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
