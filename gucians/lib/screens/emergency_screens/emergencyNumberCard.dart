import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gucians/models/emergency_num.dart';
import 'package:gucians/theme/colors.dart';

// ignore: must_be_immutable, camel_case_types
class EmergencyNumberCard extends StatelessWidget {
  EmergencyNum number;
  EmergencyNumberCard({super.key, required this.number});

  void callNumber() {
    print("calling: ${number.number}");
    _launchDialer2(number.number);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(number.name),
        subtitle: Text(number.number),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.light,
              backgroundColor: AppColors.dark),
          onPressed: callNumber,
          child: const Text("Call"),
        ),
      ),
    );
  }

  // void _launchDialer(String phoneNumber) async {
  //   Uri url = Uri(scheme: "tel", path: phoneNumber);
  //   try {
  //     await launchUrl(url);
  //   } catch (error) {
  //     print("Can't open dial pad." + error.toString());
  //   }
  // }

  void _launchDialer2(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      print('Error calling phone number: $e');
      // Handle the error as needed
    }
  }
}
