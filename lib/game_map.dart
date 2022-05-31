// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:ground_z/constants.dart';

var pageList;
var title;

class GameMap extends StatefulWidget {
  const GameMap({Key? key}) : super(key: key);

  @override
  State<GameMap> createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: dimension.width * 0.1,
            ),
            Transform.scale(
              scaleX: 1.15,
              child: const Text(
                'GROUND_ZERO',
              ),
            ),
            const Spacer(),
          ],
        ),
        backgroundColor: brownOxide,
      ),
      body: Container(color: Colors.white, height: double.infinity, width: double.infinity),
    );
  }
}
