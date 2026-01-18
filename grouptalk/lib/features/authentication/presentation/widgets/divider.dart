import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget divider() {
  return Row(
    children: [
      Expanded(child: Divider(color: Colors.white54)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('or', style: TextStyle(color: Colors.white)),
      ),
      Expanded(child: Divider(color: Colors.white54))
    ],
  );
}
