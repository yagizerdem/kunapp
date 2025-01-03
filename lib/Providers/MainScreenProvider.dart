import 'package:app/pages/HomePage.dart';
import 'package:app/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class MainScreenProvider with ChangeNotifier {
  Widget _mainScreen = HomePage();

  Widget get mainScreen => _mainScreen;

  void setMainScreen(Widget widget) {
    _mainScreen = widget;
    notifyListeners(); // Notify widgets listening to this state
  }
}
