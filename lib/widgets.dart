import 'package:flutter/material.dart';
import 'package:ground_z/constants.dart';

TextButton customButton(
    {required String text, required double width, required double height, Function()? onPressed}) {
  return TextButton(
    style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: darkGrey,
        fixedSize: Size(width, 55)),
    onPressed: onPressed,
    child: Text(text,
        style: TextStyle(
          height: text.length > 28 ? height * 1.2 : height,
          fontSize: text.length > 28 ? 14 : 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
  );
}

//Para desarrollar animaciones más tarde

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(2, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(size: 150.0),
      ),
    );
  }
}
