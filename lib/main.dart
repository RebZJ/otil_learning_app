import 'package:flutter/material.dart';
import 'package:otil/categoriesPage.dart';
import 'package:otil/homepage.dart';
import 'package:otil/entrypage.dart';
import 'package:otil/entrylistpage.dart';
import 'package:otil/model.dart';
import 'package:otil/optionsPage.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  _initFirst() async {
    var file = await localFileEntries;
    bool exists = await file.exists();
    if (exists == true) {
      readEntries();
      readCate();
    }
  }

  @override
  void initState() {
    super.initState();
    _initFirst();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OptionsModel>(
      model: OptionsModel(),
      child: ScopedModelDescendant<OptionsModel>(
        builder: (context, child, model) => MaterialApp(
          title: 'OTIL',
          theme: ThemeData(
            textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
            brightness:
                model.darkMode == false ? Brightness.light : Brightness.dark,
            primaryColor:
                model.darkMode == true ? Colors.indigo[800] : Colors.blue[800],
            fontFamily: 'Roboto',
          ),
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => Screen(),
            // Entry screen
            '/entrypage': (context) => EntryPage(),
            //list of entries
            '/entrylist': (context) => EntryList(),
            '/categories': (context) => CategoriesPage(),
            '/options': (context) => OptionsPage(),
          },
        ),
      ),
    );
  }
}
