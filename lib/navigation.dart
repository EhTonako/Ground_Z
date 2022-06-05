import 'package:flutter/material.dart';

enum NavigationType { push, pushReplacement }
enum NavigationTransition { material, fade, slide }

class AppNavigator {
  static Future<bool> onWillPop() async {
    lastRoute = "";
    return true;
  }

  static String lastRoute = "";

  static to(
      {required BuildContext context,
      required Widget widget,
      required NavigationType type,
      required NavigationTransition transition,
      double slideOffSet = 1.0}) {
    late Route route;
    if (lastRoute == widget.toString()) {
      type = NavigationType.pushReplacement;
    } else {
      lastRoute = widget.toString();
    }

    switch (transition) {
      case NavigationTransition.material:
        route = MaterialPageRoute(
          builder: (context) => WillPopScope(onWillPop: onWillPop, child: widget),
        );
        break;

      // FADE
      case NavigationTransition.fade:
        route = PageRouteBuilder(
          pageBuilder: (c, a1, a2) => WillPopScope(onWillPop: onWillPop, child: widget),
          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 200),
        );
        break;

      case NavigationTransition.slide:
        route = PageRouteBuilder(
            pageBuilder: (c, a1, a2) => WillPopScope(onWillPop: onWillPop, child: widget),
            transitionsBuilder: (c, anim, a2, child) => SlideTransition(
                  child: child,
                  position:
                      Tween<Offset>(begin: Offset(slideOffSet, 0), end: Offset.zero).animate(anim),
                ),
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200));

        break;
    }

    if (type == NavigationType.push) {
      Navigator.push(context, route);
    } else if (type == NavigationType.pushReplacement) {
      Navigator.pushReplacement(context, route);
    }
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
    lastRoute = '';
  }
}
