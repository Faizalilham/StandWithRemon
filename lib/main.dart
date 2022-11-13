import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uts_mobile/home.dart';
import './auth.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false,home: MyApps()));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void email(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    if (token != null && token.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  // @override
  // void initState() {
  //   email(context);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () => email(context));
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/danila.png", height: 150, width: 150) ,
      ),

    );
  }
}

class MyApps extends StatelessWidget {
  const MyApps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
