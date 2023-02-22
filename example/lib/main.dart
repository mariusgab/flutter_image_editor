import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_editor/flutter_image_editor.dart';

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerDefaultImage = TextEditingController();
  File _defaultImage;
  File _image;

  Future<void> getimageditor() => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterImageEditor(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          pathSave: null,
          defaultImage: _defaultImage,
        );
      })).then((geteditimage) {
        if (geteditimage != null) {
          setState(() {
            _image = geteditimage;
          });
        }
      }).catchError((er) {
        print(er);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Editor example',style: TextStyle(color: Colors.white),),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {},child: Icon(Icons.add),),
      body: condition(condtion: _image == null,isTrue: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: controllerDefaultImage,
                readOnly: true,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'No default image',
                ),
              ),
              SizedBox(height: 16,),
              TextButton(onPressed: () async {
                final imageGallery = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (imageGallery != null) {
                  _defaultImage = File(imageGallery.path);
                  setState(() => controllerDefaultImage.text = _defaultImage.path);
                }
              }, child: Text('Set Default Image')),
              TextButton(onPressed: () {
                getimageditor();
              }, child: Text('Open Editor'))
            ],
          ),
        ),
      ),isFalse: _image == null ? Container() : Center(child: Image.file(_image),)),
    );
  }
}

Widget condition({bool condtion, Widget isTrue, Widget isFalse}) {
  return condtion ? isTrue : isFalse;
}
