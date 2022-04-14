import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ground_z/constants.dart';
import 'package:ground_z/widgets.dart';

void main() async {
  runApp(const MyApp());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontFamily: 'aldrich', fontSizeFactor: 1.2),
      ),
      debugShowCheckedModeBanner: false,
      home: const BookPage(title: 'G R O U N D_ZERO'),
    );
  }
}

class BookPage extends StatefulWidget {
  const BookPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool buttonsVisible = false;
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
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
          child: Text(
            widget.title,
          ),
        ),
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
                    child: const Text(
                      test,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Visibility(
              visible: buttonsVisible,
              child: Column(
                children: [
                  customButton(text: 'Opción 1', width: dimension.width * 0.96),
                  customButton(text: 'Opción 2', width: dimension.width * 0.96),
                  SizedBox(height: dimension.height * 0.018)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
