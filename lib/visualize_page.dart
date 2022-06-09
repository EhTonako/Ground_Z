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
import 'package:shared_preferences/shared_preferences.dart';

var pageList;
var title;
bool whiteBackground = false;

class VisualizePage extends StatefulWidget {
  const VisualizePage({Key? key, required this.pageList, required this.title}) : super(key: key);
  final String title;
  final Map<String, BookPage> pageList;

  @override
  State<VisualizePage> createState() => _VisualizePageState();
}

class _VisualizePageState extends State<VisualizePage> with TickerProviderStateMixin {
  double _value = prefs!.getDouble('fontSizeFactor') ?? 2;
  var scrollController = ScrollController();
  var illustration;
  bool buttonsVisible = false;
  var fontColor = const Color(0xffF7F4EC);
  var backgroundColor = Colors.black;
  bool settingsInvisible = true;
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    pageList = widget.pageList;
    title = widget.title;
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController!, curve: Curves.easeIn);
    animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    var currentPage;

    if (pageList[title] == null && title.length > 3) {
      title = title.substring(0, title.length - 3);
    }
    if (pageList[title] == null) {
      currentPage = BookPage(
        text: 'Hmm... Parece que esta página está por implementar, será mejor salir de aquí.',
        title: 'Null',
        btn1Text: 'Volver a empezar',
        btn2Text: '',
        illustration: SvgPicture.asset(
          'assets/caution.svg',
          height: dimension.height * 0.64,
        ),
      );
    } else {
      currentPage = pageList[title]!;
    }
    bool whiteBackground = prefs!.getBool('whiteBackground') ?? false;
    if (whiteBackground) {
      backgroundColor = const Color(0xffF7F4EC);
      fontColor = Colors.black;
    } else {
      backgroundColor = Colors.black;
      fontColor = const Color(0xffF7F4EC);
    }

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
                                  fontFamily: 'Cuomotype-Regular',
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28)),
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
                        onChangeEnd: (value) {
                          prefs!.setDouble('fontSizeFactor', value);
                        },
                        thumbColor: darkGrey,
                        activeColor: const Color(0xffF7F4EC),
                        min: 1.8,
                        max: 3,
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
                            whiteBackground = !whiteBackground;
                            SharedPreferences.getInstance()
                                .then((value) => value.setBool('whiteBackground', whiteBackground));
                            backgroundColor = backgroundColor == Colors.black
                                ? const Color(0xffF7F4EC)
                                : Colors.black;
                            fontColor = backgroundColor == Colors.black
                                ? const Color(0xffF7F4EC)
                                : Colors.black;
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
        body: FadeTransition(
          opacity: animation!,
          child: Container(
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      setState(() {
                        settingsInvisible = true;
                      });
                      return true;
                    },
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
                                    height: 0.6,
                                    letterSpacing: -1,
                                    wordSpacing: -5,
                                    color: fontColor,
                                    fontWeight: backgroundColor == Colors.black
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: dimension.width * 0.04),
                            child: currentPage.illustration,
                          ),
                          Column(
                            children: [
                              SizedBox(height: dimension.height * 0.03),
                              customButton(
                                  text: currentPage.btn1Text,
                                  width: dimension.width * 0.92,
                                  height: currentPage.btn2Text.isEmpty ? 1 : 0.6,
                                  changeColor: backgroundColor == const Color(0xffF7F4EC)
                                      ? Colors.black
                                      : darkGrey,
                                  onPressed: () => onChangePage(currentPage.btn1Text, currentPage)),
                              SizedBox(height: dimension.height * 0.018),
                              currentPage.btn2Text == ''
                                  ? const SizedBox()
                                  : customButton(
                                      text: currentPage.btn2Text,
                                      width: dimension.width * 0.92,
                                      height: 1,
                                      changeColor: backgroundColor == const Color(0xffF7F4EC)
                                          ? Colors.black
                                          : darkGrey,
                                      onPressed: () {
                                        onChangePage(currentPage.btn2Text, currentPage);
                                      }),
                              SizedBox(height: dimension.height * 0.018)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onChangePage(String btnTxt, BookPage currentPage) {
    if (btnTxt.contains('Volver a empezar')) {
      if (prefs!.getBool('skipIntroduction') == null) {
        prefs!.setBool('skipIntroduction', true);
        btnTxt = 'Continuar....';
      } else {
        btnTxt = 'Continuar....';
      }
    }
    SharedPreferences.getInstance().then((value) => value.setString('currentPage', btnTxt));
    setState(() {
      title = btnTxt;
    });
    scrollController.jumpTo(0);
    animationController!.reset();
    animationController!.forward();
  }
}
