// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:ground_z/book_page.dart';
import 'package:ground_z/constants.dart';
import 'package:ground_z/widgets.dart';

var pageList;
var title;

class VisualizePage extends StatefulWidget {
  const VisualizePage({Key? key, required this.pageList, required this.title})
      : super(key: key);
  final String title;
  final Map<String, BookPage> pageList;

  @override
  State<VisualizePage> createState() => _VisualizePageState();
}

class _VisualizePageState extends State<VisualizePage> {
  bool buttonsVisible = false;
  var scrollController = ScrollController();

  @override
  void initState() {
    pageList = widget.pageList;
    title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    BookPage currentPage = pageList[title]!;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (scrollController.position.maxScrollExtent == 0.0) {
        Future.delayed(const Duration(seconds: 8), () {
          setState(() {
            buttonsVisible = true;
          });
        });
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            buttonsVisible = true;
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              );
            });
          });
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Transform.scale(
          scaleX: 1.15,
          child: const Text(
            'GROUND_ZERO',
          ),
        )),
        backgroundColor: brownOxide,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: dimension.width * 0.04,
                        vertical: dimension.height * 0.015),
                    child: Text(
                      currentPage.text,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Visibility(
              visible: buttonsVisible,
              child: Column(
                children: [
                  customButton(
                      text: currentPage.btn1Text,
                      width: dimension.width * 0.96,
                      onPressed: () => fixMysteriousLength(
                          currentPage.btn1Text, currentPage)),
                  SizedBox(height: dimension.height * 0.018),
                  currentPage.btn2Text == ''
                      ? const SizedBox()
                      : customButton(
                          text: currentPage.btn2Text,
                          width: dimension.width * 0.96,
                          onPressed: () {
                            fixMysteriousLength(
                                currentPage.btn2Text, currentPage);
                          }),
                  SizedBox(height: dimension.height * 0.018)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void fixMysteriousLength(String btnTxt, BookPage currentPage) {
    setState(() {
      if (pageList[btnTxt] == null) {
        title = btnTxt.substring(0, btnTxt.length - 3);
      } else {
        title = btnTxt;
      }
    });
  }
}
