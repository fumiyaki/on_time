import 'package:flutter/material.dart';

class TimeStore with ChangeNotifier {
  DateTime _date = DateTime.now();
  get date => _date;
  bool _isShowTimePicker = false;
  bool get isShowTimePicker => _isShowTimePicker;
  bool _isIconLoading = false;
  bool get isIconLoading => _isIconLoading;

  setDate(time) {
    _date = time;

    print(date);
    notifyListeners();
  }

  showTimePicker() {
    print("tapped");
    _isShowTimePicker = !_isShowTimePicker;
    notifyListeners();
  }
}

