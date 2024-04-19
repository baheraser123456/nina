import 'package:flutter/material.dart';

class custbutton extends StatelessWidget {
  custbutton(
      {super.key, this.fun, this.hint, this.funs, this.color, this.x, this.y});
  void Function()? fun;
  void Function()? funs;
  double? x;
  double? y;
  Color? color;
  String? hint;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: fun,
        onDoubleTap: funs,
        child: Padding(
          padding: EdgeInsets.all(y ?? 25),
          child: Container(
            height: 50,
            width: x ?? 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color ?? Colors.blue,
            ),
            child: Center(
                child: Text(
              hint ?? '',
              style: const TextStyle(fontSize: 20),
            )),
          ),
        ));
  }
}
