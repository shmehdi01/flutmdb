import 'package:flutter/material.dart';

class AppNavigator {
  static push(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
