import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await LocalStorage.removeUser();
                },
                child: Text("remove user")),
            ElevatedButton(
                onPressed: () async {
                  print(await LocalStorage.getUser());
                },
                child: Text("get user")),
          ],
        ),
      ),
    );
  }
}
