import 'package:flutter/material.dart';
import 'package:gucians/services/createpost_service.dart';
import 'package:gucians/theme/sizes.dart';
import 'package:gucians/theme/colors.dart';

class AddConfession extends StatefulWidget {
  const AddConfession({super.key});

  @override
  State<AddConfession> createState() => _AddConfessionState();
}

class _AddConfessionState extends State<AddConfession> {
  final _postField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  String error = '';
  bool anonymous = false;
  List<String> tags = [];
  void submitPost() {
    submitted = true;
    if (_formKey.currentState!.validate()) {
      addPost(_postField.text, anonymous, 'confession', null, tags);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/',arguments: {'selectedIdx':2});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Confession"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Switch(
                        activeColor: AppColors.primary,
                        value: anonymous,
                        onChanged: ((value) {
                          setState(() {
                            anonymous = value;
                            print(anonymous);
                          });
                        })),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text("Anonymous")
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Confession';
                    }
                    return null;
                  },
                  maxLines: 10,
                  onChanged: (_) {
                    if (submitted) _formKey.currentState!.validate();
                  },
                  controller: _postField,
                  decoration: InputDecoration(
                    focusColor: AppColors.primary,
                    labelText: 'Your Confession',
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
                const SizedBox(
                    height: 16.0), // Adding space between text field and button
                // Button to post
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        submitPost();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black87),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the border radius
                          ),
                        ),
                      ),
                      child: const Text('Confess'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
