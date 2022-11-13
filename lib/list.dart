import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

void main() => runApp(Lists());

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  final String baseUrl = "https://api-resto-auth.herokuapp.com/api/v1/resto";
  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(Uri.parse(baseUrl));
    return json.decode(result.body)['data']['resto'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(snapshot.data[index]['image'] ?? ''),
                      ),
                      title: Text(snapshot.data[index]['name']),
                      subtitle: Text(snapshot.data[index]['address']),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class Lists extends StatelessWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primaryColor: Colors.white),
      home: MyListPage(),
    );
  }
}
