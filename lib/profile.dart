import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './auth.dart';
import './main.dart';
import './profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(Profile());

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final Uri instagram = Uri.parse('https://instagram.com/faizalfalakh');
  final Uri github = Uri.parse('https://github.com/Faizalilham');

  Future<void> _launchIg() async {
    if (!await launchUrl(instagram)) {
      throw 'Could not launch $instagram';
    }
  }

  Future<void> _launchGithub() async {
    if (!await launchUrl(github)) {
      throw 'Could not launch $github';
    }
  }

  Future<List<String>> getProfile() async {
    var url = "https://api-resto-auth.herokuapp.com/api/v1/user/current";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var profile = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var datas = json.decode(profile.body);
    List<String> list = [datas["name"], datas["email"]];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        FutureBuilder<List<String>>(
          future: getProfile(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Image.asset("assets/images/danila.png",
                      height: 100, width: 100),
                  SizedBox(height: 25),
                  Text(snapshot.data[0],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black87)),
                  SizedBox(height: 25),
                  Text(snapshot.data[1],
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal,color: Colors.black87)),
                  SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.blue),
                            ))),
                            onPressed: () async {
                              if (!await launchUrl(instagram)) {
                                throw 'Could not launch $instagram';
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/icons/instagram.png",
                                  height: 35, width: 35),
                            )),
                        SizedBox(width: 25),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.blue),
                            ))),
                            onPressed: () async {
                              if (!await launchUrl(github)) {
                                throw 'Could not launch $github';
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/icons/github.png",
                                  height: 35, width: 35),
                            )),
                        SizedBox(width: 25),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.blue),
                            ))),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove('token');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyApp()));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/icons/logout.png",
                                  height: 35, width: 35),
                            ))
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    ));
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primaryColor: Colors.white),
      home: MyProfilePage(),
    );
  }
}
