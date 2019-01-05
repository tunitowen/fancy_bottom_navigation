import 'package:flutter/material.dart';

class TabData {
  TabData({@required this.iconData, @required this.title});

  IconData iconData;
  String title;
  final UniqueKey key = UniqueKey();
}