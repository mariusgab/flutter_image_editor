
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.white;
  double slider = 15.0;
  TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          align == TextAlign.left
              ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Center(
                child: Icon(
                  FontAwesomeIcons.alignLeft,
                  size: 30,
                  color: Colors.white,
                ),
            ),
          )) : IconButton(onPressed: () {
            setState(() {
              align = TextAlign.left;
            });
          }, icon: Icon(FontAwesomeIcons.alignLeft)),

          align == TextAlign.center
              ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                color: Colors.white.withOpacity(0.1),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.alignCenter,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )) : IconButton(onPressed: () {
            setState(() {
              align = TextAlign.center;
            });
          }, icon: Icon(FontAwesomeIcons.alignCenter)),

          align == TextAlign.right
              ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                color: Colors.white.withOpacity(0.1),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.alignRight,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )): IconButton(onPressed: () {
            setState(() {
              align = TextAlign.right;
            });
          }, icon: Icon(FontAwesomeIcons.alignRight)),
        ],
      ),
      bottomNavigationBar: Container(
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            padding: MaterialStateProperty.all(EdgeInsets.all(15)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),onPressed: () {
            Navigator.pop(context, {
              'name': name.text,
              'color': currentColor,
              'size': slider.toDouble(),
              'align': align
            });
          }, child: Text("Add Text",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Insert Your Message',
                    hintStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 99999,
                  style: TextStyle(
                    color: currentColor,
                    fontSize: slider
                  ),
                  autofocus: true,
                ),
              ),
              Container(
                // color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Slider Color",style: TextStyle(color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: BarColorPicker(
                                width: 280,
                                thumbColor: Colors.white,
                                cornerRadius: 10,
                                pickMode: PickMode.Color,
                                colorListener: (int value) {
                                  setState(() {
                                    currentColor = Color(value);
                                  });
                                })),
                            TextButton(onPressed: () {
                              setState(() {
                                currentColor = Colors.white;
                              });
                            }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                          ],
                        ),
                      ),
                      Text("Slider White Black Color",style: TextStyle(color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: BarColorPicker(
                                width: 280,
                                thumbColor: Colors.white,
                                cornerRadius: 10,
                                pickMode: PickMode.Grey,
                                colorListener: (int value) {
                                  setState(() {
                                    currentColor = Color(value);
                                  });
                                })),
                            TextButton(onPressed: () {
                              setState(() {
                                currentColor = Colors.white;
                              });
                            }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                          ],
                        ),
                      ),

                      Container(
                        color: Colors.black,
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Center(
                              child: Text('Size Adjust'.toUpperCase(),style: TextStyle(color: Colors.white),),
                            ),
                            Slider(
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                                value: slider,
                                min: 0.0,
                                max: 100.0,
                                onChangeEnd: (v) {
                                  setState(() {
                                    slider = v;
                                  });
                                },
                                onChanged: (v) {
                                  setState(() {
                                    slider = v;
                                  });
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
