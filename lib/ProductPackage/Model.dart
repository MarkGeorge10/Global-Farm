import 'package:flutter/cupertino.dart';

class Model with ChangeNotifier {
   int _localQuantity = 1;

  getQuantity() => _localQuantity;

  setQuantity(int counter) => _localQuantity = counter;

  void incrementCounter() {
    _localQuantity++;
    notifyListeners();
  }

   void decrementCounter() {
    _localQuantity--;

    if (_localQuantity < 1) {
      _localQuantity = 1;
    }
    notifyListeners();
  }
}