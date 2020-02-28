import 'package:otil/model.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OptionsModel>(
      builder: (BuildContext context, child, model) => Container(
        child: Scaffold(

          appBar: AppBar(
            title: Text("Options"),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10))),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Dark Mode', style: TextStyle(fontSize: 18)),
                      Switch(
                        value: model.darkMode,
                        onChanged: (value) {
                          model.isDarkMode(value);

                          return model.darkMode;
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
