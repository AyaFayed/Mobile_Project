import 'package:flutter/material.dart';
import 'package:gucians/models/location_model.dart';
import 'package:gucians/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class LocationCard extends StatelessWidget {
  Location location;
  LocationCard({super.key, required this.location});

  openLocation(BuildContext context) {
    print("opening location");
    _showLocationInfo(context);
  }

  openMaps() {
    print("opening maps");
    _launchMaps(location.mapUrl);
  }

  void _launchMaps(String mapLink) async {
    Uri url = Uri.parse(mapLink);
    try {
      await launchUrl(url);
    } catch (error) {
      print("Can't open url.$error");
    }
  }

  void _showLocationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(location.name),
          content: Text(location.directions),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.light,
      child: ListTile(
        title: Text(location.name),
        trailing: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () => openLocation(context),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.light,
                      backgroundColor: AppColors.dark),
                  child: const Text("Location")),
              const Divider(
                indent: 20,
              ),
              ElevatedButton(
                onPressed: openMaps,
                style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.light,
                    backgroundColor: AppColors.dark),
                child: Text(
                  "open in maps",
                  style: TextStyle(color: AppColors.light),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
