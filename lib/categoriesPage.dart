import 'package:flutter/material.dart';
import 'package:otil/model.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  void initState() {
    super.initState();
    readCate();
  }

  var _controllerCate = TextEditingController();

  _addCate(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Add a category?"),
          content: TextField(
            maxLength: 30,
            maxLengthEnforced: true,
            controller: _controllerCate,
            decoration: InputDecoration(
              hintText: "New category",
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            FlatButton(
              child: Text("Add"),
              onPressed: () {
                if (!cateList.contains(_controllerCate.text)) {
                  cateList.add(_controllerCate.text);
                  writeCate();
                  _controllerCate.clear();
                  setState(() {});
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Theme.of(context).primaryColor,
                            title: Text("This already exists!"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: Navigator.of(context).pop,
                                child: Text('Close'),
                              )
                            ],
                          ));
                }
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

  _editCate(index, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Remove the category: \n" + cateList[index] + " ?"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            FlatButton(
              child: Text("Remove"),
              onPressed: () {
                cateList.removeAt(index);
                writeCate();

                setState(() {});
                Navigator.of(context).pop();
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
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _addCate(context)),
      appBar: AppBar(
        title: Text("Categories"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      ),
      body: ListView.builder(
        itemCount: cateList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => _editCate(index, context),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cateList[index],
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ));
        },
      ),
    ));
  }
}
