class BookPage {
  final String text;
  final String title;
  final String btn1Text;
  final String btn2Text;
  //final bool finished;
  final bool twoButtons;

  BookPage(
      {required this.text,
      required this.title,
      required this.btn1Text,
      required this.btn2Text,
      required this.twoButtons
      //this.finished = false;
      });

  BookPage.oneButton({
    required this.text,
    required this.title,
    required this.btn1Text,
    required this.twoButtons,
    this.btn2Text = '',
    //this.finished = false;
  });
}
