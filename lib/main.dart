import 'package:cloud/model/Model.dart';
import 'package:cloud/screens/CSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

List<DataModel> getcloudList = getcloudData();
List<DataModel> getfullList = getfullData();
List<DrawerModel> getCSDrawerList = getCSDrawer();

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FireCloud', // Title of the application
      home: SplashScreen(), // Home page of the application
      debugShowCheckedModeBanner: false, // Disabling the debug banner
    );
  }
}