import 'package:flutter/material.dart';
import 'package:otil/model.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:otil/entrypage.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EntryList extends StatefulWidget {
  @override
  _EntryListState createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  _removeEntry(context, index) {
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

// user defined function
  void _removeDialog(context, index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).primaryColor,
          title: Text("What would you like to do?"),
          content: Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            FlatButton(
              child: Text("Remove"),
              onPressed: () => _removeEntry(context, index),
            ),
            FlatButton(
              child: Text("Edit"),
              onPressed: () => _editEntry(context, index),
            ),
            FlatButton(
              onPressed: null,
              child: Text("View"),
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
    //print(entryList[0].categoriesList);
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
        rebuildOnChange: true,
        builder: (BuildContext context, Widget child, Model model) =>
            ListView.builder(
          itemCount: entryList.length,
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (context, position) {
            return GestureDetector(
              onLongPress: () => _removeDialog(context, position),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: entryList[position].title.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(DateFormat('dd-MMM-yyy – kk:mm')
                            .format(entryList[position].timestamp)),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}

//String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(timestamp);

//style: TextStyle(fontSize: 22.0),
