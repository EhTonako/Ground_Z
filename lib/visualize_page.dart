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
import 'package:just_audio/just_audio.dart';
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
  var scrollController = ScrollController();
  var illustration;
  var fontColor = const Color(0xffF7F4EC);
  var backgroundColor = Colors.black;
  var currentPage;
  var lastPage;
  var button1Scale = 1.0;
  var button2Scale = 1.0;
  var rollToBottom = false;

  AudioPlayer audioPlayer = AudioPlayer();
  bool playedOnce = false;
  double _value = prefs!.getDouble('fontSizeFactor') ?? 2;
  bool settingsInvisible = true;
  late AnimationController animButton1Controller;
  late AnimationController animButton2Controller;
  AnimationController? fadeController;
  AnimationController? musicProgressController;
  Animation<double>? animation;

  @override
  void initState() {
    pageList = widget.pageList;
    title = widget.title;
    initAnimations();
    controlPages(init: true);
    if (title == 'Volver a empezar' && !playedOnce) {
      playedOnce = true;
      currentPage.tryPlayingMusic(audioPlayer);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    bool whiteBackground = controlColor();
    button1Scale = 1 - animButton1Controller.value;
    button2Scale = 1 - animButton2Controller.value;

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
                            ? SvgPicture.asset('assets/icons/map_white.svg',
                                height: 5 * (dimension.height * 0.01))
                            : SvgPicture.asset('assets/icons/map.svg',
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
                          ? SvgPicture.asset('assets/icons/light_on.svg',
                              height: 4.5 * (dimension.height * 0.01))
                          : SvgPicture.asset('assets/icons/light_off.svg',
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
                    ? SvgPicture.asset('assets/icons/settings_white.svg',
                        height: 5 * (dimension.height * 0.01))
                    : SvgPicture.asset('assets/icons/settings.svg',
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
                  child: FadeTransition(
                    opacity: animation!,
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
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dimension.width * 0.04),
                          child: currentPage.illustration,
                        ),
                        musicProgressController == null
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: dimension.width * 0.04,
                                    right: dimension.width * 0.04,
                                    top: dimension.width * 0.06),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    minHeight: dimension.height * 0.03,
                                    backgroundColor: Colors.grey,
                                    valueColor: const AlwaysStoppedAnimation<Color>(brownOxide),
                                    value: musicProgressController!.value,
                                  ),
                                )),
                        Column(
                          children: [
                            SizedBox(height: dimension.height * 0.03),
                            Transform.scale(
                              scale: button1Scale,
                              child: customButton(
                                  text: currentPage.btn1Text,
                                  width: dimension.width * 0.92,
                                  height: currentPage.btn2Text.isEmpty ? 1 : 0.6,
                                  changeColor: backgroundColor == const Color(0xffF7F4EC)
                                      ? Colors.black
                                      : darkGrey,
                                  onPressed: () {
                                    onChangePage(currentPage.btn1Text, currentPage, dimension, 1);
                                  }),
                            ),
                            SizedBox(height: dimension.height * 0.018),
                            currentPage.btn2Text == ''
                                ? const SizedBox()
                                : Transform.scale(
                                    scale: button2Scale,
                                    child: customButton(
                                        text: currentPage.btn2Text,
                                        width: dimension.width * 0.92,
                                        height: 1,
                                        changeColor: backgroundColor == const Color(0xffF7F4EC)
                                            ? Colors.black
                                            : darkGrey,
                                        onPressed: () {
                                          onChangePage(
                                              currentPage.btn2Text, currentPage, dimension, 2);
                                        }),
                                  ),
                            SizedBox(height: dimension.height * 0.018)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool controlColor() {
    bool whiteBackground = prefs!.getBool('whiteBackground') ?? false;

    if (whiteBackground) {
      backgroundColor = const Color(0xffF7F4EC);
      fontColor = Colors.black;
    } else {
      backgroundColor = Colors.black;
      fontColor = const Color(0xffF7F4EC);
    }
    return whiteBackground;
  }

  void controlPages({bool init = false}) {
    if (title == 'Volver atrás') {
      title = prefs!.getString('lastPage');
    }

    if (pageList[title] == null && title.length > 3) {
      title = title.substring(0, title.length - 3);
    }
    if (pageList[title] == null) {
      if (!init) {
        prefs!.setString('lastPage', currentPage.title);
      }
      lastPage = currentPage;
      currentPage = BookPage(
          text: 'Hmm... Parece que esta página está por implementar, será mejor salir de aquí.',
          title: 'Null',
          btn1Text: 'Volver atrás',
          btn2Text: '',
          illustration: Transform.scale(
            scale: 0.8,
            child: SvgPicture.asset(
              'assets/icons/caution.svg',
              height: 500,
            ),
          ));
    } else {
      currentPage = pageList[title]!;
    }
  }

  void initAnimations() {
    fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animButton1Controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    animButton2Controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    animation = CurvedAnimation(parent: fadeController!, curve: Curves.easeIn);
    fadeController!.forward();

    scrollController.addListener(() async {
      if (!playedOnce &&
          pageList[title] != null &&
          scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        playedOnce = true;
        int duration = await pageList[title].tryPlayingMusic(audioPlayer);
        if (duration > 0) {
          musicProgressController = AnimationController(
            vsync: this,
            duration: Duration(seconds: duration - 6),
          )..addListener(() {
              setState(() {});
            });
          musicProgressController!.forward();
        }
      }
    });
  }

  void onChangePage(String btnTxt, BookPage currentPage, Size dimension, int button) {
    var buttonController = button == 1 ? animButton1Controller : animButton2Controller;
    buttonController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      buttonController.reverse();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      button1Scale = 1;
      button2Scale = 1;
      playedOnce = false;
      musicProgressController = null;
      if (btnTxt.contains('Volver a empezar')) {
        if (prefs!.getBool('skipIntroduction') == null) {
          prefs!.setBool('skipIntroduction', true);
        }
        btnTxt = 'Empezar   ';
      }
      SharedPreferences.getInstance().then((value) => value.setString('currentPage', btnTxt));
      setState(() {
        title = btnTxt;
      });
      controlPages();
      if (!title.contains('Continuar')) {
        audioPlayer.stop();
      }
      scrollController.jumpTo(0);
      buttonController.reset();
      fadeController!.reset();
      fadeController!.forward();
    });
  }
}
