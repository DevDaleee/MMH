import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late String _nick;
  late String _email;
  late int _points;

//getters:
  String get getNick => _nick;
  String get getEmail => _email;
  int get getPoints => _points;

//Setters:

  void changeNickName(String val) {
    _nick = val;
    notifyListeners();
  }

  void updatingPoints(String val) {
    _points = int.parse(val);
    notifyListeners();
  }
}
