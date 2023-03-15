import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinkGhost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset('lib/images/ghost_pink.png'),
    );
  }
}