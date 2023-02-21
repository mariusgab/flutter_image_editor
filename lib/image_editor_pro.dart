import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_pro/modules/sliders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/bottombar_container.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import 'dart:math' as math;

import 'modules/color_filter_generator.dart';
import 'modules/colors_picker.dart'; // import this

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;
List<Map> widgetJson = [];
//List fontsize = [];
//List<Color> colorList = [];
var howmuchwidgetis = 0;
//List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Color? appBarColor;
  final Color? bottomBarColor;
  final Directory? pathSave;
  final File defaultImage;
  final double? pixelRatio;

  ImageEditorPro({
    this.appBarColor,
    this.bottomBarColor,
    this.pathSave,
    required this.defaultImage,
    this.pixelRatio,
  });

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller = SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset?> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File? _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer? timeprediction;

  void timers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.defaultImage.existsSync()) {
        loadImage(widget.defaultImage);
      }
    });
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction?.cancel();
    _controller.clear();
    widgetJson.clear();
    heightcontroler.clear();
    widthcontroler.clear();
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    //  fontsize.clear();
    offsets.clear();
    //  multiwidget.clear();
    howmuchwidgetis = 0;

    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        key: scaf,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Height Width'),
                      actions: <Widget>[
                        TextButton(onPressed: () {
                          setState(() {
                            height = int.parse(heightcontroler.text);
                            width = int.parse(widthcontroler.text);
                          });
                          heightcontroler.clear();
                          widthcontroler.clear();
                          Navigator.pop(context);
                        }, child: Text("Done"))
                      ],
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Define Height'),
                            SizedBox(height: 10,),
                            TextField(
                                controller: heightcontroler,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: 'Height',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder())),
                            SizedBox(height: 10,),
                            Text('Define Width'),
                            SizedBox(height: 10,),
                            TextField(
                                controller: widthcontroler,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: 'Width',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder())),
                          ],
                        ),
                      ),
                    );
                  });
            }, icon: Icon(FontAwesomeIcons.boxes)),

            IconButton(onPressed: () {
              _controller.points.clear();
              setState(() {});
            }, icon: Icon(Icons.clear)),

            IconButton(onPressed: () {
              bottomsheets();
            }, icon: Icon(Icons.camera_alt)),

            TextButton(onPressed: () {
              screenshotController.capture(pixelRatio: widget.pixelRatio ?? 1.5).then((binaryIntList) async {
                //print("Capture Done");

                final paths = widget.pathSave ?? await getTemporaryDirectory();

                final file = await File('${paths.path}/' + DateTime.now().toString() + '.jpg').create();
                file.writeAsBytesSync(binaryIntList ?? []);
                Navigator.pop(context, file);
              }).catchError((onError) {
                print(onError);
                });
              },
              child: Text("Save"),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
              ))
        ],
        brightness: Brightness.dark,
          // backgroundColor: Colors.red,
          backgroundColor: widget.appBarColor ?? Colors.black87,
        ),
        bottomNavigationBar: openbottomsheet
            ? Container()
            : Container(
          padding: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 10.9,
                color: widget.bottomBarColor ?? Colors.black,
              )
            ],
          ),
          height: 70,
              child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: FontAwesomeIcons.brush,
                ontap: () {
                  // raise the [showDialog] widget
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                        ),
                        actions: <Widget>[
                          TextButton(onPressed: () {
                            setState(() => currentColor = pickerColor);
                            Navigator.pop(context);
                          }, child: Text("Got it"))
                        ],
                      );
                    },
                  );
                },
                title: 'Brush',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: Icons.text_fields,
                ontap: () async {
                  var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => TextEditorImage()));
                  if (value['name'] == null) {
                    print('true');
                  } else {
                    type.add(2);
                    widgetJson.add(value);
                    // fontsize.add(20);
                    offsets.add(Offset.zero);
                    //  colorList.add(value['color']);
                    //    multiwidget.add(value['name']);
                    howmuchwidgetis++;
                  }
                },
                title: 'Text',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: Icons.flip,
                ontap: () {
                  setState(() {
                    flipValue = flipValue == 0 ? math.pi : 0;
                  });
                },
                title: 'Flip',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: Icons.rotate_left,
                ontap: () {
                  setState(() {
                    rotateValue--;
                  });
                },
                title: 'Rotate left',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: Icons.rotate_right,
                ontap: () {
                  setState(() {
                    rotateValue++;
                  });
                },
                title: 'Rotate right',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: Icons.blur_on,
                ontap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setS) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(20),
                            height: 400,
                            child: Column(
                              children: [
                                Center(
                                  child: Text('Slider Filter Color'.toUpperCase(),style: TextStyle(color: Colors.white),),
                                ),
                                Divider(),
                                SizedBox(height: 20,),
                                Text('Slider Color'.toUpperCase(),style: TextStyle(color: Colors.white),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: BarColorPicker(
                                        width: 300,
                                        thumbColor: Colors.white,
                                        cornerRadius: 10,
                                        pickMode: PickMode.Color,
                                        colorListener: (int value) {
                                          setS(() {
                                            setState(() {
                                              colorValue = Color(value);
                                            });
                                          });
                                        })),
                                    TextButton(onPressed: (){
                                      setState(() {
                                        setS(() {
                                          colorValue = Colors.transparent;
                                        });
                                      });
                                    }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text("Slider Blur",style: TextStyle(color: Colors.white),),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Expanded(child: Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: blurValue,
                                        min: 0.0,
                                        max: 10.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              blurValue = v;
                                            });
                                          });

                                        })),

                                    TextButton(onPressed: () {
                                      setState(() {
                                        blurValue = 0.0;
                                      });
                                    }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Slider Opacity",style: TextStyle(color: Colors.white),),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: opacityValue,
                                        min: 0.00,
                                        max: 1.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              opacityValue = v;
                                            });
                                          });
                                        })),
                                    TextButton(onPressed: () {
                                      setS(() {
                                        setState(() {
                                          opacityValue = 0.0;
                                        });
                                      });

                                    }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                title: 'Blur',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: FontAwesomeIcons.eraser,
                ontap: () {
                  _controller.clear();
                  //  type.clear();
                  // // fontsize.clear();
                  //  offsets.clear();
                  // // multiwidget.clear();
                  howmuchwidgetis = 0;
                },
                title: 'Eraser',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: Icons.photo,
                ontap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setS) {
                            return Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5,),
                                  Text("Slider Hue",style: TextStyle(color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: hueValue,
                                          min: -10.0,
                                          max: 10.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                hueValue = v;
                                              });
                                            });
                                          })),
                                      TextButton(onPressed: () {
                                        setS(() {
                                          setState(() {
                                            blurValue = 0.0;
                                          });
                                        });
                                      }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Slider Saturation",style: TextStyle(color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: saturationValue,
                                          min: -10.0,
                                          max: 10.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                saturationValue = v;
                                              });
                                            });
                                          })),
                                      TextButton(onPressed: () {
                                        setS(() {
                                          setState(() {
                                            saturationValue = 0.0;
                                          });
                                        });
                                      }, child: Text("Reset",style: TextStyle(color: Colors.white),))

                                    ],
                                  ),

                                  SizedBox(height: 5,),
                                  Text("Slider Brightness",style: TextStyle(color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: brightnessValue,
                                          min: 0.0,
                                          max: 1.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                brightnessValue = v;
                                              });
                                            });
                                          })),
                                      TextButton(onPressed: () {
                                        setS(() {
                                          setState(() {
                                            brightnessValue = 0.0;
                                          });
                                        });
                                      }, child: Text("Reset",style: TextStyle(color: Colors.white),))
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                title: 'Filter',
              ),
              BottomBarContainer(
                colors: widget.bottomBarColor ?? Colors.blue,
                icons: FontAwesomeIcons.smile,
                ontap: () {
                  var getemojis = showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Emojies();
                      });
                  getemojis.then((value) {
                    if (value['name'] != null) {
                      type.add(1);
                      widgetJson.add(value);
                      //    fontsize.add(20);
                      offsets.add(Offset.zero);
                      //  multiwidget.add(value);
                      howmuchwidgetis++;
                    }
                  });
                },
                title: 'Emoji',
              ),
          ],
        ),),
      body: Center(
          child: Screenshot(
            controller: screenshotController,
            child: RotatedBox(
              quarterTurns: rotateValue,
              child: imageFilterLatest(
                hue: hueValue,
                brightness: brightnessValue,
                saturation: saturationValue,
                child: RepaintBoundary(
                    key: globalKey,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      color: Colors.white,
                      width: width.toDouble(),
                      height: height.toDouble(),
                      child: Stack(
                        children: [
                          _image != null
                              ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(flipValue),
                            child: ClipRect(
                              // <-- clips to the 200x200 [Container] below

                              child: Container(
                                padding: EdgeInsets.zero,
                                // alignment: Alignment.center,
                                width: width.toDouble(),
                                height: height.toDouble(),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(_image?.path ?? ""))
                                  ),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: blurValue,
                                    sigmaY: blurValue,
                                  ),
                                  child: Container(
                                    color: colorValue.withOpacity(opacityValue),
                                  ),
                                ),
                              ),
                            ),
                          )

                          //  BackdropFilter(
                          //     filter: ImageFilter.blur(
                          //         sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.clamp),
                          //     child: Image.file(
                          //       _image,
                          //       height: height.toDouble(),
                          //       width: width.toDouble(),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   )
                              : Container(),
                          GestureDetector(
                            onPanUpdate: (DragUpdateDetails details) {
                              setState(() {
                                var object = context.findRenderObject() as RenderBox?;
                                var _localPosition = object?.globalToLocal(details.globalPosition);
                                _points = List.from(_points)..add(_localPosition);
                              });
                            },
                            onPanEnd: (DragEndDetails details) {
                              _points.add(null);
                            },
                            child: Signat(),
                          ),

                          Stack(
                            children: [
                              ...widgetJson.asMap().entries.map((f) {
                                return type[f.key] == 1
                                    ? EmojiView(
                                  left: offsets[f.key].dx,
                                  top: offsets[f.key].dy,
                                  ontap: () {
                                    scaf.currentState?.showBottomSheet((context) {
                                      return Sliders(
                                        index: f.key,
                                        mapValue: f.value,
                                      );
                                    });
                                  },
                                  onpanupdate: (details) {
                                    setState(() {
                                      offsets[f.key] =
                                          Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                    });
                                  },
                                  mapJson: f.value,
                                )
                                    : type[f.key] == 2
                                    ? TextView(
                                  left: offsets[f.key].dx,
                                  top: offsets[f.key].dy,
                                  ontap: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),),
                                        context: context,
                                        builder: (context) {
                                          return Sliders(
                                            index: f.key,
                                            mapValue: f.value,
                                          );
                                        });
                                  },
                                  onpanupdate: (details) {
                                    setState(() {
                                      offsets[f.key] =
                                          Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                    });
                                  },
                                  mapJson: f.value,
                                )
                                    : Container();
                              }).toList()
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          )
      ),
    );
  }

  final picker = ImagePicker();

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    var future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(0.0),
          color: Colors.white,
          //   blurRadius: 10.9,
          //shadowColor: Colors.grey[400],
          height: 170,
          child: Column(
            children: [
              Center(
                child: Text('Select Image Options'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var image = await picker.getImage(source: ImageSource.gallery);
                        await loadImage(File(image?.path ?? ''));
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(onPressed: () async {
                              var image = await picker.getImage(source: ImageSource.gallery);
                              await loadImage(File(image?.path ?? ''));
                              Navigator.pop(context);
                            }, icon: Icon(Icons.photo_library)),
                            SizedBox(width: 10,),
                            Text('Open Gallery')
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 24,),

                    GestureDetector(
                      onTap: () async {
                        var image = await picker.getImage(source: ImageSource.camera);
                        var decodedImage = await decodeImageFromList(File(image?.path ?? "").readAsBytesSync());

                        setState(() {
                          height = decodedImage.height;
                          width = decodedImage.width;
                          _image = File(image?.path ?? "");
                        });
                        setState(() => _controller.clear());
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
                            SizedBox(width: 10,),
                            Text('Open Camera')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  Future<void> loadImage(File imageFile) async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    setState(() {
      height = decodedImage.height;
      width = decodedImage.width;
      _image = imageFile;
      _controller.clear();
    });
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

Widget imageFilterLatest({brightness, saturation, hue, child}) {
  return ColorFiltered(
      colorFilter: ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
            value: saturation,
          )),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
              value: hue,
            )),
            child: child,
          )));
}
