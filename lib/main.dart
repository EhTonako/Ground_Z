// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ground_z/book_page.dart';
import 'package:ground_z/visualize_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

var prefs;
Map<String, BookPage> pageList = {};

class GroundZ extends StatelessWidget {
  const GroundZ({Key? key}) : super(key: key);

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
      home: VisualizePage(
        //SharedPrefs
        title: 'Volver a empezar',
        pageList: pageList,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await readProcessBook();
  runApp(const GroundZ());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> readProcessBook() async {
  var text = await rootBundle.loadString('assets/Ground_Z.txt');
  var book = text.split('\n#');
  book = List<String>.generate(book.length, (i) => book[i].replaceAll('#', ''));
  int counter = 0;
  List<String> div = [];
  for (String string in book) {
    ++counter;
    if (counter % 2 != 0) {
      div = string.split("|");
    } else {
      String text = string;
      BookPage page;
      if (div.length > 2) {
        page = BookPage(
            title: div[0],
            text: text,
            btn1Text: div[1],
            btn2Text: div[2],
            twoButtons: true);
      } else {
        //Para probar errores al modificar el libro: print(div[0]);
        page = BookPage.oneButton(
            title: div[0], text: text, btn1Text: div[1], twoButtons: false);
      }
      pageList.putIfAbsent(div[0], () => page);
    }
  }
  if (prefs.getBool('second') != true) {}
}
