import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:otil/model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: AnimatedContainer(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _isTapped == false ? Colors.white : Colors.green[200]),
                duration: Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(cateList[widget.index]),
                      ),
                      _isTapped == false
                          ? Icon(Icons.radio_button_unchecked)
                          : Icon(Icons.radio_button_checked),
                    ],
                  ),
                )),
          ),
        );
      }),
    );
  }
}

class Expan extends StatefulWidget {
  final index;
  final mode;
  Expan({this.index = 100000000, this.mode});
  @override
  _ExpanState createState() => _ExpanState();
}

class _ExpanState extends State<Expan> {
  //image
  File _image;

  Future getImage(localImageList, context, source) async {
    OptionsModel model = ScopedModel.of(context);
    var maxPhotos = 3;
    if (localImageList.length < maxPhotos) {
      File image = await ImagePicker.pickImage(source: source);

      _image = image;

      if (image != null) {
        localImageList.add(image);
        model.entryPagePanelController.open();
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: <Widget>[
                  Center(
                    child: FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Row(
                          children: <Widget>[
                            Text("Close"),
                            Icon(Icons.close),
                          ],
                        )),
                  )
                ],
                title: Center(child: Text("Couldn't select image")),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).primaryColor,
              );
            });
      }
    } else {
      emptyAlert(context, "Max " + maxPhotos.toString() + " photos");
    }
  }

  _addCates(context) {
    OptionsModel model = ScopedModel.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Add or remove categories for this entry",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Tap on the categories to select or deselect",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                height: 150.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Scrollbar(
                  child: ListView.builder(
                      itemCount: cateList.length,
                      itemBuilder: (context, indexCat) {
                        return EachTile(
                          entryIndex: widget.index,
                          index: indexCat,
                        );
                      }),
                ),
              ),
              AnimatedOpacity(
                opacity:
                    model.maxCategories == model.localListCat.length ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  "Max categories reached (" +
                      model.maxCategories.toString() +
                      ")",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            FlatButton(
              child: Text("Add More Categories"),
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
    return ScopedModelDescendant<OptionsModel>(
      builder: (context, child, model) => Container(
          child: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        visible: (widget.mode == 'view' ? false : true),
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
          SpeedDialChild(
            labelBackgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add_a_photo),
            backgroundColor: Colors.blue,
            label: 'Take a photo',
            labelStyle: TextStyle(fontSize: 12.0, color: Colors.white),
            onTap: () =>
                getImage(model.localListImages, context, ImageSource.camera),
          ),
          SpeedDialChild(
            labelBackgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.photo),
            backgroundColor: Colors.green,
            label: 'Add a photo',
            labelStyle: TextStyle(fontSize: 12.0, color: Colors.white),
            onTap: () =>
                getImage(model.localListImages, context, ImageSource.gallery),
          ),
          SpeedDialChild(
              labelBackgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.category),
              backgroundColor: Colors.red,
              label: 'Categories (Add at least one)',
              labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
              onTap: () => _addCates(context)),
        ],
      )),
    );
  }
}

// user defined function
void emptyAlert(context, message) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
          title: Text(
            message,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                child: Text("Close"),
                onPressed: () => Navigator.of(context).pop()),
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
    // readEntries();
    intialiseContent();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  intialiseContent() {
    OptionsModel model = ScopedModel.of(context);
    model.localListCat.clear();
    model.localListImages.clear();
    if ((widget.mode == 'edit') || (widget.mode == 'view')) {
      titleController.text = entryList[widget.index].title;
      bodyController.text = entryList[widget.index].body;

      var blep = entryList[widget.index].categoriesList;
      model.localListCat = blep;
      List<String> l1 = [];
      if (entryList[widget.index].categoriesList.isNotEmpty == true) {
        for (String i in entryList[widget.index].categoriesList) {
          l1.add(i);
        }
      }
      model.localListCat = l1;
      List<File> l2 = [];
      if (entryList[widget.index].imagesPathList.isNotEmpty == true) {
        for (String i in entryList[widget.index].imagesPathList) {
          l2.add(File(i));
        }

        model.localListImages = l2;
        setState(() {});
      } else {
        model.localListImages.clear();
      }
    } else if (widget.mode == 'save') {
      // print(widget.index);
      // print(widget.mode);

      model.localListCat.clear();
      model.localListImages.clear();
    }
  }

  //all that is responsible for adding images in as a list
  // Future<List<String>> fileToPatha(
  //     List<File> imagesList, DateTime timestampNow) async {
  //   String locPath = await localPath;
  //   String _timestamp;

  //   if (widget.mode == 'save') {
  //     _timestamp = timestampNow.toIso8601String();
  //     await Directory('$locPath/$_timestamp').create();
  //   } else if (widget.mode == 'edit' || widget.mode == 'view') {
  //     _timestamp = entryList[widget.index].timestamp.toIso8601String();
  //   }

  //   List<String> lista = [];
  //   for (var i = 0; i < imagesList.length; i++) {
  //     // lista.add(imagesList[i].path);
  //     String basename = p.basename(imagesList[i].path);

  //     await imagesList[i].copy('$locPath/$_timestamp/$basename');
  //     lista.add('$locPath/$_timestamp/$basename');
  //   }

  //   return lista;
  // }

  Future<List<String>> fileToPath(
      List<File> imagesList, DateTime timestampNow) async {
    String locPath = await localPath;
    String _timestamp;
    List<String> lista = [];

    if (widget.mode == 'save') {
      _timestamp = timestampNow.toIso8601String();
    } else if (widget.mode == 'edit' || widget.mode == 'view') {
      _timestamp = entryList[widget.index].timestamp.toIso8601String();
    }

    //images list is of model.imagelist
    for (File i in imagesList) {
      String basename = p.basename(i.path);
      if (basename.contains('$_timestamp')) {
        lista.add(i.path);
        print(i.path);
      } else {
        var imagefile = i.copySync('$locPath/$_timestamp' + '$basename');
        print(imagefile.path);
        lista.add(imagefile.path);
      }
    }

    return lista;
  }

  //function to save everything
  saveEntry(context, catList, List imagesList) async {
    DateTime timestampNow = DateTime.now(); //time now
    List<String> imgListString = await fileToPath(imagesList, timestampNow);
    if (titleController.text == "") {
      emptyAlert(context, "I think you forgot a title");
    } else if (bodyController.text == "") {
      emptyAlert(context, "I think you forgot to add what you learnt");
    } else if (catList.length == 0) {
      emptyAlert(context, "Add a category please (click + sign)");
    } else {
      if (widget.mode == 'save') {
        entryList.add(new Entry(
            title: titleController.text,
            body: bodyController.text,
            categoriesList: catList,
            timestamp: timestampNow,
            imagesPathList: imgListString));

        writeEntries();
        readEntries();
        print(imgListString);

        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/entrylist');
      } else if (widget.mode == 'edit') {
        entryList[widget.index].title = titleController.text;
        entryList[widget.index].body = bodyController.text;
        entryList[widget.index].categoriesList = catList;
        entryList[widget.index].imagesPathList = imgListString;
        writeEntries().then((value) =>
            readEntries().then((value) => Navigator.of(context).pop()));

        // print(imgListString);

      }
    }
  }

  _removeAndExit(context, fileOfImage) {
    Navigator.of(context).pop();
    OptionsModel model = ScopedModel.of(context);
    model.localListImages.remove(fileOfImage);
  }

  enlargeImage(context, fileOfImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(actions: <Widget>[
          FlatButton(
              child: Text("Remove"),
              onPressed: () => _removeAndExit(context, fileOfImage)),
          FlatButton(
              onPressed: Navigator.of(context).pop, child: Icon(Icons.close)),
        ], content: Container(child: Image.file(fileOfImage)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OptionsModel>(
        builder: (context, child, model) {
      return Container(
        child: Scaffold(
          backgroundColor: Colors.blue[50],
          floatingActionButton: Expan(index: widget.index, mode: widget.mode),
          appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10))),
            title: Text(widget.title),
            actions: <Widget>[
              FlatButton(
                child: widget.mode == 'view'
                    ? null
                    : Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () => saveEntry(
                    context, model.localListCat, model.localListImages),
              )
            ],
          ),
          body: SlidingUpPanel(
            backdropOpacity: 0.5,
            backdropColor: Colors.black,
            backdropEnabled: true,
            controller: model.entryPagePanelController,
            minHeight: 65,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            panel: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Icon(Icons.drag_handle),
                ),
                Wrap(direction: Axis.horizontal, children: childrenCate(model)),
                Wrap(
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: childrenImages(model, context),
                )
              ],
            )),
            body: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 160),
              child: AnimatedPadding(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: model.darkMode == false
                          ? Colors.white
                          : Colors.blueGrey[900],
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(2, 2))
                      ],
                      border: Border.all(
                          width: 3, color: Colors.grey[300].withOpacity(0)),
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          maxLength: 150,
                          enabled: (widget.mode == 'view' ? false : true),
                          maxLengthEnforced: true,
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
                          enabled: (widget.mode == 'view' ? false : true),
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
            ),
          ),
        ),
      );
    });
  }

  List<Widget> childrenCate(OptionsModel model) {
    List<Widget> listToReturn = [];

    if (model.localListImages.isEmpty == false) {
      listToReturn.add(Padding(
        padding: EdgeInsets.only(right: 6, top: 5, left: 10),
        child: GestureDetector(
          onTap: () => model.entryPagePanelController.open(),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(model.localListImages.length.toString() + " "),
                  Icon(
                    Icons.image,
                    size: 20,
                  )
                ],
              )),
        ),
      ));
    }
    for (var item in model.localListCat) {
      listToReturn.add(Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, offset: Offset(1, 1), blurRadius: 2)
              ],
              color: Colors.blue[100],
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          child: Text(
            "  " + item + "  ",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ));
    }
    return listToReturn;
  }

  List<Widget> childrenImages(OptionsModel model, BuildContext context) {
    List<Widget> listToReturn = [];
    Widget _loadImage(item) {
      bool exists = item.existsSync();
      //   print(item.toString() + '||||');
      if (exists == true) {
        return Image.file(item);
      } else {
        return Text(
          "couldn't load images :(",
          style: TextStyle(color: Colors.black),
        );
      }
    }

    Widget currentWidget;
    if (model.localListImages.isEmpty == false) {
      for (var item in model.localListImages) {
        currentWidget = GestureDetector(
            onTap: () =>
                item.existsSync() == true ? enlargeImage(context, item) : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                padding: EdgeInsets.all(5),
                constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(child: _loadImage(item)),
                ),
              ),
            ));
        listToReturn.add(currentWidget);
      }
    }
    return listToReturn;
  }
}
