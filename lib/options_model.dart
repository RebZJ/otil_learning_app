import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionsModel extends Model {
  OptionsModel() {
    load();
  }
  List<String> _localListCat = List();
  List<String> _localListImages = List();
  bool _isSwitched = false;
  bool _darkMode = false;
  int _maxCategories = 3;
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
  }

  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSwitched = prefs.getBool('isSwitched_save');

    _darkMode = prefs.getBool('darkMode_save');
  }
}
