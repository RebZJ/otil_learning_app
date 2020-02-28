import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class OptionsModel extends Model {
  OptionsModel() {
    _init();
  }
//init
  _init() {
    if (_firstRun == true) {
      _firstRun = false;
      save();
    } else {
      load();
    }
  }

  //decalre variables and defaults
   bool _firstRun = true;
  List<String> _localListCat = List();
  List<File> _localListImages = List();
  bool _isSwitched = false;
  bool _darkMode = false;
  int _maxCategories = 3;

  //getters and setters
  get firstRun => _firstRun;
  get maxCategories => _maxCategories;
  get localListCat => _localListCat;
  get localListImages => _localListImages;

  set localListImages(value) {
    _localListImages = value;
    notifyListeners();
  }

  set localListCat(value) {
    _localListCat = value;
    notifyListeners();
  }

  get isSwitched {
    notifyListeners();
    return _isSwitched;
  }

  void isitSwitched(bool value) {
    _isSwitched = value;
    save();
    notifyListeners();
  }

  get darkMode {
    notifyListeners();
    return _darkMode;
  }

  void isDarkMode(bool value) {
    _darkMode = value;
    save();
    notifyListeners();
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isSwitched_save', _isSwitched);

    prefs.setBool('darkMode_save', _darkMode);

    prefs.setBool('firstRun_save', _firstRun);
  }

  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSwitched = prefs.getBool('isSwitched_save');

    _darkMode = prefs.getBool('darkMode_save');

    _firstRun = prefs.getBool('firstRun_save');
  }
}
