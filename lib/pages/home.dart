import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  Home({super.key, required String title});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  File? _selectedImage = null;
  XFile? _image;
  File? file;
  var _recognitions;
  //var v = "";
  // var dataList = [];
  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future detectimage(File image) async {
    //int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      //v = recognitions.toString();
      // dataList = List<Map<String, dynamic>>.from(jsonDecode(v));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
          child: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          width: 220,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset (x, y)
              ),
            ],
            color: Colors.amber,
          ),
          child: _selectedImage != null
              ? Image.file(_selectedImage!)
              : const Text(
                  "Select an image",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "SF",
                      fontWeight: FontWeight.w300),
                ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          width: 220,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset (x, y)
              ),
            ],
            color: Colors.amber,
          ),
          child: _recognitions != null
              ? Text(_recognitions.toString())
              : const Text(
                  "Select an image",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "SF",
                      fontWeight: FontWeight.w300),
                ),
        ),
        Container(
          //margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: MaterialButton(
            splashColor: Colors.transparent,
            minWidth: 70,
            height: 30,
            color: Color.fromARGB(255, 247, 135, 37),
            child: const Text(
              'Select an image from files',
              style: TextStyle(
                fontFamily: "SF",
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            onPressed: () {
              _pickImageFromGallery();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: MaterialButton(
            splashColor: Colors.transparent,
            minWidth: 70,
            height: 30,
            color: Color.fromARGB(255, 247, 135, 37),
            child: const Text(
              'Take a photo',
              style: TextStyle(
                fontFamily: "SF",
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            onPressed: () {
              _pickImageFromCamera();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: MaterialButton(
            splashColor: Colors.transparent,
            minWidth: 70,
            height: 30,
            color: Color.fromARGB(255, 247, 135, 37),
            child: const Text(
              'Recognize',
              style: TextStyle(
                fontFamily: "SF",
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            onPressed: () {
              detectimage(_selectedImage!);
            },
          ),
        ),
      ])),
      backgroundColor: Color.fromARGB(255, 34, 34, 34),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() => _selectedImage = File(returnedImage.path));
    detectimage(_selectedImage!);
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() => _selectedImage = File(returnedImage.path));
    detectimage(_selectedImage!);
  }
}

AppBar appBar() {
  return AppBar(
    title: const Text(
      "Cats/Dogs",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 21,
      ),
    ),
    backgroundColor: Color.fromARGB(255, 92, 91, 91),
    leading: GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 247, 135, 37),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/cat.svg',
          alignment: Alignment.center,
        ),
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 37,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 135, 37),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/dog.svg',
            alignment: Alignment.center,
            width: 30,
            height: 25,
          ),
        ),
      ),
    ],
  );
}
