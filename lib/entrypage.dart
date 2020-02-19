import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:otil/model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//for each tile of categories
class EachTile extends StatefulWidget {
  final Widget child;
  final index;
  final entryIndex;
  EachTile({Key key, this.child, this.index, this.entryIndex});
  @override
  _EachTileState createState() => _EachTileState();
}

//var localListCat = List();

class _EachTileState extends State<EachTile> {
  void initState() {
    super.initState();
  }

  bool _isTapped = false;

  addCate(indexCat, localListCat) {
    localListCat.add(cateList[indexCat]);
    // print(localListCat);
    setState(() {});
  }

  removeCate(indexCat, localListCat) {
    localListCat.remove(cateList[indexCat]);
    //  print(localListCat);
    setState(() {});
  }

  changeCate(indexCat, localListCat, max) {
    if ((_isTapped == false) && (localListCat.length < max)) {
      _isTapped = true;
      addCate(indexCat, localListCat);
    } else if (_isTapped == true) {
      _isTapped = false;
      removeCate(indexCat, localListCat);
    }
  }

  initCate(indexCat, localListCat) {
    if (localListCat.contains(cateList[indexCat])) {
      _isTapped = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          ScopedModelDescendant<OptionsModel>(builder: (context, child, model) {
        initCate(widget.index, model.localListCat);

        return GestureDetector(
          onTap: () =>
              changeCate(widget.index, model.localListCat, model.maxCategories),
          child: Card(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                color: _isTapped == false ? Colors.white : Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(cateList[widget.index]),
                )),
          ),
        );
      }),
    );
  }
}

class Expan extends StatefulWidget {
  final index;
  Expan({this.index = 0});
  @override
  _ExpanState createState() => _ExpanState();
}

class _ExpanState extends State<Expan> {
  //image
  File _image;

  Future<File> getImage({ImageSource source = ImageSource.gallery}) async {
    File image = await ImagePicker.pickImage(source: source);

    _image = image;
  }

  _addCates(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Add a category for this entry"),
          content: Container(
            height: 150.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: ListView.builder(
                itemCount: cateList.length,
                itemBuilder: (context, indexCat) {
                  return EachTile(
                    entryIndex: widget.index,
                    index: indexCat,
                  );
                }),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            FlatButton(
              child: Text("Add"),
              onPressed: () {
                setState(() {});
                Navigator.pushNamed(context, '/categories');
              },
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
  Widget build(BuildContext context) {
    return Container(
        child: SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,

      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      child: Icon(Icons.add),
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Theme.of(context).primaryColor,
      overlayOpacity: 0.5,
      onOpen: () => print('OPEN DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        // SpeedDialChild(
        //   labelBackgroundColor: Theme.of(context).primaryColor,
        //   child: Icon(Icons.add_a_photo),
        //   backgroundColor: Colors.blue,
        //   label: 'Take a photo',
        //   labelStyle: TextStyle(fontSize: 12.0),
        //   onTap: () => print('SECOND CHILD'),
        // ),
        SpeedDialChild(
          labelBackgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.photo),
          backgroundColor: Colors.green,
          label: 'Add a photo',
          labelStyle: TextStyle(fontSize: 12.0),
          onTap: () => print('THIRD CHILD'),
        ),
        SpeedDialChild(
            labelBackgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.category),
            backgroundColor: Colors.red,
            label: 'Categories (Add at least one)',
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.blue),
            onTap: () => _addCates(context)),
      ],
    ));
  }
}

// user defined function
void emptyAlert(context, message) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(title: Text(message), actions: <Widget>[
        // usually buttons at the bottom of the dialog

        FlatButton(
            child: Text("Close"), onPressed: () => Navigator.of(context).pop()),
      ]);
    },
  );
}

class EntryPage extends StatefulWidget {
  final mode;
  final index; //this is the entrylist index
  final String title;
  final OptionsModel model;
  EntryPage({this.title = 'Entry', this.mode = 'save', this.index, this.model});
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  void initState() {
    super.initState();
    intialiseContent();
  }

  intialiseContent() {
    if (widget.mode == 'edit') {
      print(entryList[widget.index].categoriesList);
      titleController.text = entryList[widget.index].title;
      bodyController.text = entryList[widget.index].body;
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  saveEntry(context, catList) {
    if (titleController.text == "") {
      emptyAlert(context, "I think you forgot a title");
    } else if (bodyController.text == "") {
      emptyAlert(context, "I think you forgot to add what you learnt");
    } else if (catList.length == 0) {
      emptyAlert(context, "Add a category please (click + sign)");
    } else {
      DateTime timestampNow = DateTime.now(); //time now
      if (widget.mode == 'save') {
        entryList.add(new Entry(
          title: titleController.text,
          body: bodyController.text,
          categoriesList: catList,
          timestamp: timestampNow,
          /*categoriesList:  ['blep', 'glep'])*/
        ));
        writeEntries();
        readEntries();

        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/entrylist');
      } else if (widget.mode == 'edit') {
        entryList[widget.index].title = titleController.text;
        entryList[widget.index].body = bodyController.text;
        entryList[widget.index].categoriesList = catList;
        writeEntries();
        readEntries();
        Navigator.of(context).pop();
        setState(() {});
        // Navigator.pushNamed(context, '/entrylist');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OptionsModel>(
        builder: (context, child, model) {
      if (widget.index != null) {
        var l = entryList[widget.index].categoriesList..toList();
        model.localListCat = l;
      }
      return Container(
        child: Scaffold(
          floatingActionButton: Expan(index: widget.index),
          appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10))),
            title: Text(widget.title),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => saveEntry(context, model.localListCat),
              )
            ],
          ),
          body: SlidingUpPanel(
            borderRadius: BorderRadius.circular(20),
            panel: Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  for (var item in model.localListCat)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          item + " ",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    )
                ])),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  TextField(
                    controller: bodyController,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "What did you learn?",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
