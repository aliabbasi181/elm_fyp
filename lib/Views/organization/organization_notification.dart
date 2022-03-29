import 'package:elm_fyp/SharedPreferences/local_storage.dart';
import 'package:flutter/material.dart';

class OrganizationNotification extends StatefulWidget {
  const OrganizationNotification({Key? key}) : super(key: key);

  @override
  State<OrganizationNotification> createState() =>
      _OrganizationNotificationState();
}

class _OrganizationNotificationState extends State<OrganizationNotification> {
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
                child: Text("get id")),
          ],
        ),
      ),
    );
  }
}
