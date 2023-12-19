import 'package:flutter/material.dart';
import 'package:gucians/models/emergency_num.dart';
import 'package:gucians/services/emergency_service.dart';
import 'package:gucians/theme/colors.dart';
import 'emergencyNumberCard.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<EmergencyNum> en = [];
  List<EmergencyNum> filteredNumbers = [];
  String searchValue = "";
  bool loading = true;
  final TextEditingController _searchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    List<EmergencyNum> tempNums = await getNums();
    setState(() {
      en = tempNums;
      filteredNumbers = en;
      loading = false;
    });
  }

  Future<List<EmergencyNum>> getNums() async {
    return await getemergencyNums();
  }

  void filterNumbersList(String query) {
    setState(() {
      if (query == "") _searchBar.text = query;
      searchValue = query;
      filteredNumbers = en
          .where((number) =>
              number.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // handleText(String value) {
  //   setState(() {
  //     searchValue = value;
  //     filteredNumbers = en
  //         .map((e) => e.name.matchAsPrefix(value))
  //         .cast<EmergencyNum>()
  //         .toList();
  //   });
  //   print("value:" + value);
  //   print("search value:" + searchValue);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emergency numbers",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.light),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: SearchBar(
              controller: _searchBar,
              leading: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(Icons.search),
              ),
              hintText: 'Search numbers',
              overlayColor: MaterialStateProperty.all(AppColors.lightGrey),
              trailing: [
                if (_searchBar.text.isNotEmpty)
                  TextButton(
                      onPressed: () => filterNumbersList(""),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ))
              ],
              onChanged: (String value) {
                filterNumbersList(value);
              },
            ),
          ),
          if (filteredNumbers.isNotEmpty)
            Expanded(
                child: ListView.builder(
                    itemCount: filteredNumbers.length,
                    itemBuilder: (ctx, index) =>
                        EmergencyNumberCard(number: filteredNumbers[index])))
          else if (filteredNumbers.isEmpty && !loading)
            Container(
              margin: const EdgeInsets.only(top: 150),
              child:
                  Center(child: Text("There is no results for $searchValue")),
            )
          else
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
