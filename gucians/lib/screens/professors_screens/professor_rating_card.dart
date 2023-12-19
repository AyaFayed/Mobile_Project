import 'package:flutter/material.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/screens/professors_screens/professor_profile_screen.dart';
import 'package:gucians/theme/colors.dart';

// ignore: must_be_immutable
class ProfessorRatingCard extends StatelessWidget {
  UserModel user;
  final Function reload;
  ProfessorRatingCard({super.key, required this.user, required this.reload});

  double getSumRates(){
    double sum=0.0;
    user.ratings!.forEach((key, value) { 
      sum+=value;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.light,
            child: Text(user.name[0]),
          ),
          title: Text("Dr ${user.name}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                  "${user.ratings!.isEmpty?0:(getSumRates() / user.ratings!.length).toStringAsFixed(1)} (${user.ratings!.length})")
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffProfile(
                  user: user,
                  reload : reload
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
