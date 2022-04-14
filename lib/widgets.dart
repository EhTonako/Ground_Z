import 'package:flutter/material.dart';
import 'package:ground_z/constants.dart';

TextButton customButton(
    {required String text, required double width, Function()? onPressed}) {
  return TextButton(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: darkGrey,
      elevation: 1.0,
      minimumSize: Size(width, 40),
    ),
    onPressed: onPressed,
    child: Text(text,
        style: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
  );
}
