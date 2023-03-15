import 'package:flutter/material.dart';

class MyPath extends StatelessWidget {
  final innerColor;
  final outerColor;

  MyPath({this.innerColor, this.outerColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(15),
            color: outerColor,
            child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  color: innerColor,
                )
            ),
          ),
        ));
  }
}