import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

class BookPage {
  final String text;
  final String title;
  final String btn1Text;
  final String btn2Text;
  late AnimationController animController;
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
    rootBundle.load('assets/drawings/$title.png').then((value) {
      illustration = Image(image: AssetImage('assets/drawings/$title.png'));
    }).catchError((error) {});
  }

  Future<int> tryPlayingMusic(AudioPlayer audioPlayer) async {
    int duration = 0;
    await audioPlayer.setAsset('assets/music/$title.mp4').then((value) {
      duration = value!.inSeconds;
      audioPlayer.play();
    }).catchError((error) {});
    return duration;
  }
}
