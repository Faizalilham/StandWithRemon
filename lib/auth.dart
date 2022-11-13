import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController emailController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins', primaryColor: Colors.white),
        scaffoldMessengerKey: SnackbarGlobal.key,
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    bottom: TabBar(
                        tabs: [Tab(text: "Login"), Tab(text: "Register")]),
                    title: Text("Iseng App")),
                body: TabBarView(children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                      children: [
                        Image.asset('assets/images/loginIcon.png', height: 150),
                        TextFormField(
                          key: _formKey,
                          controller: emailController,
                          decoration: new InputDecoration(
                            hintText: "Enter Email",
                            labelText: "Email",
                            suffixIcon: const Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(Icons.email)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != "" || value != " ") {
                              return "Field cannot be empety";
                            }
                            return null;
                          },
                        ),
                        SizedBox(width: 20, height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: new InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            suffixIcon: const Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(Icons.key)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value != "" || value != " ") {
                              return "Field cannot be empety";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            minimumSize: Size(300, 50),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            String email = emailController.text.toString();
                            String password =
                                passwordController.text.toString();
                            var myresponse = await http.post(
                              Uri.parse(
                                  "http://api-resto-auth.herokuapp.com/api/v1/user/login"),
                              body: {"email": email, "password": password},
                            );

                            Map<String, dynamic> data =
                                json.decode(myresponse.body)
                                    as Map<String, dynamic>;

                            if (data['token'] != "") {
                              addStringToSF(data['token']);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Home()));
                              setState(() {
                                SnackbarGlobal.show(
                                    "Login Success, Hallo ${data['name']}");
                              });
                            } else {
                              SnackbarGlobal.show(
                                  "Login Failed, please check your username or password");
                            }
                          },
                        )
                      ],
                    ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                      children: [
                        Image.asset('assets/images/loginIcon.png', height: 150),
                        TextFormField(
                          controller: nameController,
                          decoration: new InputDecoration(
                            hintText: "Enter Name",
                            labelText: "Name",
                            suffixIcon: const Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(Icons.person)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != "" || value != " ") {
                              return "Field cannot be empety";
                            }
                            return null;
                          },
                        ),
                        SizedBox(width: 20, height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: new InputDecoration(
                            hintText: "Enter Email",
                            labelText: "Email",
                            suffixIcon: const Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(Icons.email)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != "" || value != " ") {
                              return "Field cannot be empety";
                            }
                            return null;
                          },
                        ),
                        SizedBox(width: 20, height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: new InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            suffixIcon: const Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: const Icon(Icons.key)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value != "" || value != " ") {
                              return "Field cannot be empety";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            minimumSize: Size(300, 50),
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            String name = nameController.text.toString();
                            String email = emailController.text.toString();
                            String password =
                                passwordController.text.toString();
                            var myresponse = await http.post(
                              Uri.parse(
                                  "http://api-resto-auth.herokuapp.com/api/v1/user/register"),
                              body: {
                                "name": name,
                                "email": email,
                                "password": password
                              },
                            );

                            Map<String, dynamic> data =
                                json.decode(myresponse.body)
                                    as Map<String, dynamic>;

                            setState(() {
                              if (data.isNotEmpty) {
                                SnackbarGlobal.show("Register Successfully");
                              } else {
                                SnackbarGlobal.show(
                                    "Register Failed, please check your input field");
                              }
                            });
                          },
                        )
                      ],
                    ),
                    )
                  )
                ]))));
  }
}
