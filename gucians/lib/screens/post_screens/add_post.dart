import 'dart:io';
import 'package:flutter/material.dart';
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
    });
  }

  final _postField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  String error = '';
  String category='';
  bool anonymous = false;
  bool uploading=false;
  List<String> tags = [];
  
  void submitPost() {
    submitted = true;
    
    if (_formKey.currentState!.validate()) {
      uploading=true;
      addPost(_postField.text, false, category, image, tags).then((value) {

      Navigator.of(context).pop();
      switch (category) {
        case 'news':
          Navigator.of(context).pushReplacementNamed('/',arguments: {'selectedIdx':0});
        case 'question':
          Navigator.of(context).pushReplacementNamed('/',arguments: {'selectedIdx':1});
        case 'lost_and_found':
          Navigator.of(context).pushReplacementNamed('/lost_and_found');
          
          break;
        default:
      }
      });
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

  @override
  Widget build(BuildContext context) {
if(ModalRoute.of(context)!.settings.arguments!=null){
      final x=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
      if(x['category']!=null){
        category=x['category']!;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
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
                      child: const Text('Add photo'),
                    ),
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.confirm),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the border radius
                          ),
                        ),
                      ),
                      child: const Text('Post'),
                    ),
                  ],
                ),
                image != null
                    ? Row(
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
                    : const Text(
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
