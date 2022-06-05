// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ground_z/app_builder.dart';
import 'package:ground_z/book_page.dart';
import 'package:ground_z/constants.dart';
import 'package:ground_z/game_map.dart';
import 'package:ground_z/main.dart';
import 'package:ground_z/navigation.dart';
import 'package:ground_z/widgets.dart';

var pageList;
var title;

class VisualizePage extends StatefulWidget {
  const VisualizePage({Key? key, required this.pageList, required this.title}) : super(key: key);
  final String title;
  final Map<String, BookPage> pageList;

  @override
  State<VisualizePage> createState() => _VisualizePageState();
}

class _VisualizePageState extends State<VisualizePage> {
  double _value = 1.5;
  var scrollController = ScrollController();
  var illustration;
  bool buttonsVisible = false;
  var fontColor = Colors.white;
  var backgroundColor = Colors.black;
  bool settingsInvisible = true;

  @override
  void initState() {
    pageList = widget.pageList;
    title = widget.title;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 7), () {
        scrollController.addListener(() {
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
              buttonsVisible != true) {
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                buttonsVisible = true;
              });
              Future.delayed(const Duration(milliseconds: 100), () {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              });
            });
          }
        });
        setState(() {
          if (scrollController.position.maxScrollExtent == 0.0) {
            buttonsVisible = true;
          }
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    BookPage currentPage = pageList[title]!;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Visibility(
                  visible: settingsInvisible,
                  child: Row(
                    children: [
                      SizedBox(width: dimension.width * 0.02),
                      Transform.scale(
                        scaleX: 1.15,
                        child: Text('GROUND_ZERO',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: backgroundColor, fontWeight: FontWeight.bold, fontSize: 28)),
                      ),
                      SizedBox(width: dimension.width * 0.09),
                      InkWell(
                        child: backgroundColor == Colors.black
                            ? SvgPicture.asset('assets/map_white.svg',
                                height: 5 * (dimension.height * 0.01))
                            : SvgPicture.asset('assets/map.svg',
                                height: 5 * (dimension.height * 0.01)),
                        onTap: () {
                          AppNavigator.to(
                              context: context,
                              widget: const GameMap(),
                              type: NavigationType.push,
                              transition: NavigationTransition.slide);
                        },
                      ),
                      SizedBox(width: dimension.width * 0.02),
                    ],
                  )),
              Visibility(
                visible: !settingsInvisible,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Slider(
                      thumbColor: darkGrey,
                      activeColor: Colors.white,
                      min: 1.2,
                      max: 1.6,
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          fontSizeFactor = value;
                          AppBuilder.of(context).rebuild();
                        });
                      },
                    ),
                    InkWell(
                      child: backgroundColor == Colors.black
                          ? SvgPicture.asset('assets/light_on.svg',
                              height: 4.5 * (dimension.height * 0.01))
                          : SvgPicture.asset('assets/light_off.svg',
                              height: 4.5 * (dimension.height * 0.01)),
                      onTap: () {
                        setState(() {
                          backgroundColor =
                              backgroundColor == Colors.black ? Colors.white : Colors.black;
                          fontColor = backgroundColor == Colors.black ? Colors.white : Colors.black;
                        });
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                child: backgroundColor == Colors.black
                    ? SvgPicture.asset('assets/settings_white.svg',
                        height: 5 * (dimension.height * 0.01))
                    : SvgPicture.asset('assets/settings.svg',
                        height: 5 * (dimension.height * 0.01)),
                onTap: () {
                  setState(() {
                    settingsInvisible = !settingsInvisible;
                  });
                },
              ),
            ],
          ),
        ),
        backgroundColor: brownOxide,
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              right: dimension.width * 0.04,
                              left: dimension.width * 0.04,
                              top: dimension.height * 0.015),
                          child: Text(
                            currentPage.text,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: fontColor,
                                fontWeight: backgroundColor == Colors.black
                                    ? FontWeight.normal
                                    : FontWeight.bold),
                          )),
                      currentPage.illustration
                    ],
                  )),
            ),
            Visibility(
              visible: buttonsVisible,
              child: Column(
                children: [
                  SizedBox(height: dimension.height * 0.018),
                  customButton(
                      text: currentPage.btn1Text,
                      width: dimension.width * 0.96,
                      height: currentPage.btn2Text.isEmpty ? 1.75 : 1,
                      changeColor: backgroundColor == Colors.white ? Colors.black : darkGrey,
                      onPressed: () => fixMysteriousLength(currentPage.btn1Text, currentPage)),
                  SizedBox(height: dimension.height * 0.018),
                  currentPage.btn2Text == ''
                      ? const SizedBox()
                      : customButton(
                          text: currentPage.btn2Text,
                          width: dimension.width * 0.96,
                          height: 1.75,
                          changeColor: backgroundColor == Colors.white ? Colors.black : darkGrey,
                          onPressed: () {
                            fixMysteriousLength(currentPage.btn2Text, currentPage);
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
    scrollController.jumpTo(0);
    setState(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            if (scrollController.position.maxScrollExtent == 0.0) {
              buttonsVisible = true;
            }
          });
        });
      });
      buttonsVisible = false;
      if (pageList[btnTxt] == null) {
        title = btnTxt.substring(0, btnTxt.length - 3);
        return;
      }
      title = btnTxt;
    });
  }
}
