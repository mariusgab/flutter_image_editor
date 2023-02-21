

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../image_editor_pro.dart';
import 'colors_picker.dart';

class Sliders extends StatefulWidget {
  final int index;
  final Map mapValue;

  const Sliders({Key? key, required this.mapValue,required this.index}) : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    //  slider = widget.sizevalue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text('Size Adjust'.toUpperCase(),style: TextStyle(color: Colors.white),),
          ),
          Divider(),
          Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              value: widgetJson[widget.index]['size'],
              min: 0.0,
              max: 100.0,
              onChangeEnd: (v) {
                setState(() {
                  widgetJson[widget.index]['size'] = v.toDouble();
                });
              },
              onChanged: (v) {
                setState(() {
                  slider = v;
                  // print(v.toDouble());
                  widgetJson[widget.index]['size'] = v.toDouble();
                });
              }),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),

            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('Slider Color'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: BarColorPicker(
                        width: 300,
                        thumbColor: Colors.white,
                        cornerRadius: 10,
                        pickMode: PickMode.Color,
                        colorListener: (int value) {
                          setState(() {
                            widgetJson[widget.index]['color'] = Color(value);
                          });
                        })),
                    TextButton(onPressed: () {}, child: Text("Reset"))
                  ],
                ),
                Text('Slider White Black Color'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: BarColorPicker(
                        width: 300,
                        thumbColor: Colors.white,
                        cornerRadius: 10,
                        pickMode: PickMode.Grey,
                        colorListener: (int value) {
                          setState(() {
                            widgetJson[widget.index]['color'] = Color(value);
                          });
                        })),
                    TextButton(onPressed: () {}, child: Text("Reset"))
                  ],
                )
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Expanded(child: TextButton(style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),onPressed: () {
                widgetJson.removeAt(widget.index);
                Navigator.pop(context);
                // setState(() {});
              }, child: Text("Remove")))
            ],
          )
        ],
      ),
    );
  }
}
