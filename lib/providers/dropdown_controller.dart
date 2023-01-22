import 'package:flutter/material.dart';

class DropdownController with ChangeNotifier {
  bool _expanded = false;

  bool get expanded => _expanded;

  void setExpanded() {
    if (_expanded) {
      _expanded = false;
    } else {
      _expanded = true;
    }
    notifyListeners();
  }
}
