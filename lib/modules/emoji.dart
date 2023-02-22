import 'package:flutter/material.dart';

class EmojiView extends StatefulWidget {
  final double left;
  final double top;
  final Function ontap;
  final Map mapJson;
  final Function(DragUpdateDetails) onpanupdate;

  const EmojiView({
    Key? key,
    required this.left,
    required this.top,
    required this.ontap,
    required this.onpanupdate,
    required this.mapJson,
  }) : super(key: key);
  @override
  _EmojiViewState createState() => _EmojiViewState();
}

class _EmojiViewState extends State<EmojiView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
        onTap: () {
          widget.ontap();
        },
        onPanUpdate: widget.onpanupdate,
        child: Text(widget.mapJson['name'].toString(),
            textAlign: widget.mapJson['align'],
            style: TextStyle(
              color: widget.mapJson['color'],
              fontSize: widget.mapJson['size'],
            )),
      ),
    );
  }
}
