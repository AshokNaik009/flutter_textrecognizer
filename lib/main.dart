import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase MLKIT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  bool isImageLoaded = false;
  List<String> imageText = ['PlaceHolder Text'];

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer text = FirebaseVision.instance.textRecognizer();
    VisionText readText = await text.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
          setState(() {
            imageText.add(word.text);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          isImageLoaded
              ? Center(
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover)),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text('Pick an Image'),
            onPressed: pickImage,
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text('Read text'),
            onPressed: readText,
          ),
          SizedBox(
            height: 10.0,
          ),
          Flexible(
            child: Center(
              child: ListView.builder(
                itemCount: imageText.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Center(child: new Text(imageText[index]));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
