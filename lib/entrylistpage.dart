import 'package:flutter/material.dart';
import 'package:otil/model.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:otil/entrypage.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'package:flutter_gradients/flutter_gradients.dart';

class EntryList extends StatefulWidget {
  EntryList({Key key}) : super(key: key);

  @override
  _EntryListState createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  final Shader linearGradient1 = FlutterGradient.landingAircraft().createShader(
      Rect.fromCenter(center: Offset(0, 0), width: 100, height: 10));

  _removeEntry(context, index) async {
    //delete the folder

    String locPath = await localPath;
    String _timestamp = entryList[index].timestamp.toIso8601String();
    final dir = Directory('$locPath/$_timestamp');
    bool exists = await dir.exists();

    if (exists == true) {
      dir.deleteSync(recursive: true);
    }

    entryList.removeAt(index);
    writeEntries();
    Navigator.of(context).pop();
    setState(() {});
  }

  _editEntry(context, index) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EntryPage(
                  index: index,
                  mode: 'edit',
                )));
    setState(() {});
  }

  _viewEntry(context, index) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EntryPage(
                  index: index,
                  mode: 'view',
                )));
    setState(() {});
  }

// user defined function
  void _removeDialog(context, index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "What would you like to do?",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              onPressed: () => _viewEntry(context, index),
              child: Text("View"),
            ),
            FlatButton(
              child: Text("Remove"),
              onPressed: () => _removeEntry(context, index),
            ),
            FlatButton(
              child: Text("Edit"),
              onPressed: () => _editEntry(context, index),
            ),

            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    readEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Entries"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      ),
      body: ScopedModelDescendant<OptionsModel>(
        // rebuildOnChange: true,
        builder: (BuildContext context, Widget child, OptionsModel model) =>
            ListView.builder(
          itemCount: entryList.length,
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (context, position) {
            return elementOfEntry(context, position, model);
          },
        ),
      ),
    ));
  }

  Widget elementOfEntry(
      BuildContext context, int position, OptionsModel model) {
    return GestureDetector(
      onTap: () => _removeDialog(context, position),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 2, offset: Offset(2, 2))
              ],
              border:
                  Border.all(width: 3, color: Colors.grey[300].withOpacity(0)),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: model.isSwitched == false
                          ? Colors.blueAccent
                          : Colors.blue[900],
                      shape: BoxShape.circle,
                    ),
                    // padding: EdgeInsets.all(3),
                    // color: Colors.cyan,
                    width: 60,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.5),
                      child: Column(
                        children: <Widget>[
                          Text(
                            DateFormat('dd')
                                .format(entryList[position].timestamp),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            DateFormat('MMM')
                                .format(entryList[position].timestamp),
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          Text(
                            DateFormat('yyyy')
                                .format(entryList[position].timestamp),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: entryList[position].title.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: entryList[position].body.toString(),
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                          ),
                        ),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        children: _cateList(position),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _cateList(index) {
    List<Widget> listToReturn = [];
    for (var i in entryList[index].categoriesList) {
      listToReturn.add(Padding(
        padding: EdgeInsets.only(right: 6, top: 5),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            padding: EdgeInsets.all(5),
            child: Text(" " + i + " ")),
      ));
    }
    if (entryList[index].imagesPathList.isEmpty == false) {
      listToReturn.add(Padding(
        padding: EdgeInsets.only(right: 6, top: 5),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(entryList[index].imagesPathList.length.toString() + " "),
                Icon(
                  Icons.image,
                  size: 15,
                )
              ],
            )),
      ));
    }
    return listToReturn;
  }
}

//String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(timestamp);

//style: TextStyle(fontSize: 22.0),
