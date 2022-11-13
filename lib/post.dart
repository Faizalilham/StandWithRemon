import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './auth.dart';
import './main.dart';
import './profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/io_client.dart';

void main() => runApp(Post());

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final ImagePicker _picker = ImagePicker();
  File? images;
  String pathImages = "";

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    images = File(image!.path);
    pathImages = image.path;
    print("lokasi $images");
    setState(() {
      images = File(image.path);
      pathImages = image.path;
      print("lokasies $images");
      print("lokasi $pathImages");
    });
  }

  Future<void> Upload(String name, String address, String desc) async {
    String fileName = pathImages.split('/').last;
    var stream = http.ByteStream(images!.openRead());
    stream.cast();
    var length = await images!.length();

    var uri = Uri.parse("https://api-resto-auth.herokuapp.com/api/v1/resto");

    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile('image', stream, length);
    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['desc'] = desc;
    var p = http.MultipartFile.fromBytes(
        'image', await File.fromUri(Uri.parse(pathImages)).readAsBytes(),
        contentType: MediaType('image', 'jpeg'));
    request.files.add(p);
    var response = await request.send();
    if (response.statusCode == 200) {
      print("image uploaded");
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("datas response $responseString");
    print("response ${response.statusCode}");
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<void> uploadImages(String name, String address, String desc) async {
    print("post ygy $pathImages");
    print("post ygys ${images!.path}");
    String fileName = images!.path.split('/').last;
    FormData formData = FormData.fromMap({
      'name': name,
      'address': address,
      'desc': desc,
      'image': await MultipartFile.fromFile(images!.path, filename: fileName),
    });

    // await MultipartFile.fromFile(pathImages, filename: fileName)
    var dio = Dio();
    var response = await dio.post(
        "https://api-resto-auth.herokuapp.com/api/v1/resto",
        data: formData,
        options: Options(contentType: 'multipart/form-data'));
    if (response.statusCode! > 200 && response.statusCode! < 200) {
      SnackbarGlobal.show("Post Successfully");
    }
  }

  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              images != null
                  ? CircleAvatar(
                      radius: 30,
                      child: Image.file(images!, height: 250, width: 250))
                  : Container(height: 150, width: 150),
              SizedBox(height: 25),
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
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != "" || value != " ") {
                    return "Field cannot be empety";
                  }
                  return null;
                },
              ),
              SizedBox(width: 20, height: 20),
              TextFormField(
                controller: addressController,
                decoration: new InputDecoration(
                  hintText: "Enter Address",
                  labelText: "Address",
                  suffixIcon: const Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(Icons.home_work)),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != "" || value != " ") {
                    return "Field cannot be empety";
                  }
                  return null;
                },
              ),
              SizedBox(width: 20, height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: new InputDecoration(
                  hintText: "Enter Description",
                  labelText: "Description",
                  suffixIcon: const Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(Icons.description)),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != "" || value != " ") {
                    return "Field cannot be empety";
                  }
                  return null;
                },
              ),
              SizedBox(width: 20, height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: () async {
                    await getImage();
                  },
                  child: Text("Pick Image")),
              SizedBox(width: 20, height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: () {
                    String name = nameController.text.toString();
                    String address = addressController.text.toString();
                    String desc = descriptionController.text.toString();

                    print("Images ygy $images");
                    uploadImages(name, address, desc);
                    // Upload(name, address, desc);
                  },
                  child: Text("Post Data"))
            ],
          ),
        ));
  }
}

class Post extends StatelessWidget {
  const Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primaryColor: Colors.white),
      scaffoldMessengerKey: SnackbarGlobal.key,
      home: MyPostPage(),
    );
  }
}
