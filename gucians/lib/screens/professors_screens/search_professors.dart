import 'package:flutter/material.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/screens/professors_screens/professor_rating_card.dart';
import 'package:gucians/services/professors_service.dart';
import 'package:gucians/theme/colors.dart';

class ProfessorRatingList extends StatefulWidget {
  const ProfessorRatingList({super.key});

  @override
  State<ProfessorRatingList> createState() => _ProfessorRatingListState();
}

class _ProfessorRatingListState extends State<ProfessorRatingList> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  String searchValue = "";
  final TextEditingController _searchBar = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    List<UserModel> tempUsers = await getUsers();
    setState(() {
      users = tempUsers;
      filteredUsers = users;
      loading = false;
    });
  }

  Future<List<UserModel>> getUsers() async {
    return await getStaffUsers();
  }

  void filterUsersList(String query) {
    setState(() {
      if (query == "") _searchBar.text = query;
      searchValue = query;
      filteredUsers = users
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> reloadUsers() async {
    loading = true;
    List<UserModel> reloadedUsers = await getUsers();
    setState(() {
      users = reloadedUsers;
      filteredUsers = users;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professors Rating"),
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
              hintText: 'Search professors',
              overlayColor: MaterialStateProperty.all(AppColors.lightGrey),
              trailing: [
                if (_searchBar.text.isNotEmpty)
                  TextButton(
                      onPressed: () => filterUsersList(""),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ))
              ],
              onChanged: (String value) {
                filterUsersList(value);
              },
            ),
          ),
          if (filteredUsers.isNotEmpty && !loading)
            Expanded(
                child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (ctx, index) => ProfessorRatingCard(
                        user: filteredUsers[index], reload: reloadUsers)))
          else if (filteredUsers.isEmpty && !loading)
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: Center(child: Text("Ther is no results for $searchValue")),
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
