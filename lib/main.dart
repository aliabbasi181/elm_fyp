import 'package:elm_fyp/BLoc/application_bloc.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:elm_fyp/Views/organization/organization_nav.dart';
import 'package:elm_fyp/Views/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: ((context) => ApplicationBloc()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    ),
  );
}
