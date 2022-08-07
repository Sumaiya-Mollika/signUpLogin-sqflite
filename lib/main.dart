import 'package:flutter/material.dart';
import 'package:login_ui/screens/home_screen.dart';
import 'package:login_ui/screens/login_screen.dart';
import 'package:overlay_support/overlay_support.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false,
        home: LogInScreen(),
      ),
    );
  }
}
