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
        fixedSize: Size(width, 55)),
    onPressed: onPressed,
    child: Text(text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
  );
}
