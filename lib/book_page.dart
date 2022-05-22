import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BookPage {
  final String text;
  final String title;
  final String btn1Text;
  final String btn2Text;
  Widget illustration;

  BookPage({
    required this.text,
    required this.title,
    required this.btn1Text,
    required this.btn2Text,
    this.illustration = const SizedBox(),
  });

  BookPage.oneButton({
    required this.text,
    required this.title,
    required this.btn1Text,
    this.illustration = const SizedBox(),
    this.btn2Text = '',
  }) {
    rootBundle.load('assets/$title.png').then((value) {
      illustration = Image(image: AssetImage('assets/$title.png'));
    }).catchError((error) {});
  }
}
