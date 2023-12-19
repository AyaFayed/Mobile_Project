import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:gucians/theme/colors.dart';

// ignore: must_be_immutable
class StaffProfile extends StatefulWidget {
  UserModel user;
  final Function reload;
  StaffProfile({super.key, required this.user, required this.reload});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  // int people = 92;
  // double rates = 430;
  bool floating = true;
  double curRate = 0;

  Future<void> updateRatings(dynamic ratings) async {
    try {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('users').doc(widget.user.id);
      await postRef.update({
        'ratings': ratings,
      });

      print('Ratings updated successfully!');
    } catch (e) {
      print('Error updating Ratings: $e');
    }
  }

  void addRating(double newRating) {
    curRate = newRating;
    widget.user.ratings![UserInfoService.getCurrentUserId()] =
        newRating.toDouble();
    updateRatings(widget.user.ratings!);
    setState(() {
      // widget.user.rating += newRating.toInt();
      widget.reload();
    });
  }

  double getSumRates() {
    double sum = 0.0;
    widget.user.ratings!.forEach((key, value) {
      sum += value;
    });
    return sum;
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.user.ratings!.containsKey(UserInfoService.getCurrentUserId())) {
      curRate = widget.user.ratings![UserInfoService.getCurrentUserId()] ?? 0;
    }
    super.initState();
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double userRating = curRate;

        return AlertDialog(
          content: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: userRating,
                  minRating: 1,
                  itemPadding: const EdgeInsets.symmetric(
                      horizontal: 0.5, vertical: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    userRating = rating;
                  },
                  itemSize: 50,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    addRating(userRating);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professor's profile"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25),
            height: 450,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //                     Container(
                      //                       margin: EdgeInsets.only(top: 20.0),
                      //                       width: 100.0,
                      //                       height: 100.0,
                      //                       decoration: BoxDecoration(
                      //                         shape: BoxShape.circle,
                      //                         image: DecorationImage(
                      //                           fit: BoxFit.cover,
                      //                           image: NetworkImage(
                      // "https://scontent.fcai27-1.fna.fbcdn.net/v/t39.30808-6/273925170_10105801228523810_3734447585585205891_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeGHK9KKeBpTLHzByUwwdISbVtdDYsKhnzBW10NiwqGfMJeHcCoppTC-fEY9TcfGvKTkHgAtg_8bq3m-hOYDAprh&_nc_ohc=BOb6lDNPVQYAX-S9mw5&_nc_ht=scontent.fcai27-1.fna&oh=00_AfCQ9kOswLw_a0TbK6q6N3yHx6cUkx3tCbc5oq03I7QH5Q&oe=657C86E3"),
                      //                         ),
                      //                       ),
                      //                     ),
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 20.0),
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.light,
                          child: Text(
                            widget.user.name[0],
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.user.email!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.user.office!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RatingBar.builder(
                            initialRating:
                                (getSumRates() / widget.user.ratings!.length),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.5),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                            ignoreGestures: true,
                            itemSize: 30,
                          ),
                          const SizedBox(
                              width: 5), // Add space between rating and text
                          Text(
                            "${widget.user.ratings!.isEmpty?'0':(getSumRates() / widget.user.ratings!.length).toStringAsFixed(1)} (${widget.user.ratings!.length})",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showRatingDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Rate'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floating
          ? FloatingActionButton(
              onPressed: () {
                _showRatingDialog();
              },
              tooltip: 'Add Rating',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
