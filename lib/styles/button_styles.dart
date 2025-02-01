import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle get primaryButton {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}