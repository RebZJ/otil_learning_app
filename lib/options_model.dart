import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OptionsModel extends Model {
  OptionsModel() {
    _init();
  }
//init
  _init() {
    if (firstRun == true) {
      firstRun = false;
      _save();
    } else {
      _load();
    }
  }

  PanelController entryPagePanelController = new PanelController();
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

  set firstRun(value) {
    _firstRun = value;
    _save();
    notifyListeners();
  }

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
    _save();
    notifyListeners();
  }

  get darkMode {
    notifyListeners();
    return _darkMode;
  }

  void isDarkMode(bool value) {
    _darkMode = value;
    _save();
    notifyListeners();
  }

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isSwitched_save', _isSwitched);

    prefs.setBool('darkMode_save', _darkMode);

    prefs.setBool('firstRun_save', _firstRun);
  }

  _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSwitched = prefs.getBool('isSwitched_save');

    _darkMode = prefs.getBool('darkMode_save');

    _firstRun = prefs.getBool('firstRun_save');
  }
}
