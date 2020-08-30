//import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//a model of the data class

class Entry {
  String title;
  String body;
  DateTime timestamp = DateTime.now(); //time now
  List imagesPathList = List();
  // // List<String> audioAudioList = List();
  List<String> categoriesList;

  Entry(
      {this.title,
      this.timestamp,
      this.body,
      this.categoriesList,
      this.imagesPathList});

  factory Entry.fromJson(Map<String, dynamic> json) {
    var data1 = json['categoriesList'];

    var data2 = json['imagesPathList'];
    List<String> dataImg;

    if (data2 != null) {
      dataImg = List<String>.from(data2);
    }

    List<String> dataCat;
    if (data1 != null) {
      dataCat = List<String>.from(data1);
    }
    // print(json);
    return Entry(
        title: json['title'],
        body: json['body'],
        timestamp: DateTime.parse(json['timestamp']),
        categoriesList: dataCat,
        imagesPathList: dataImg);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'imagesPathList': imagesPathList,
        'categoriesList': categoriesList,
      };
}
//data for categories list
List<String> cateList = [];
//data for entry
List<Entry> _entryList = [];

get entryList => _entryList;

set entryList(value){
  _entryList = value;
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get localFileEntries async {
  final path = await localPath;
  return File('$path/entries.txt');
}

Future<File> writeEntries() async {
  final file = await localFileEntries;
  // Write the file.
  return file.writeAsString(json.encode(entryList));
}

Future<List> readEntries() async {
  final file = await localFileEntries;

  // Read the file.
  String contents = await file.readAsString();

  List data = json.decode(contents);
  entryList = data.map((json) => Entry.fromJson(json)).toList();

  return entryList;
}

//Categories save file
Future<File> get localFileCate async {
  final path = await localPath;
  return File('$path/categories.txt');
}

Future<File> writeCate() async {
  final file = await localFileCate;
  // Write the file.
  return file.writeAsString(json.encode(cateList));
}

void readCate() async {
  final file = await localFileCate;
  bool exists = await file.exists();
  // Read the file.
  if (exists == true) {
    String contents = await file.readAsString();

    List data = json.decode(contents);
    cateList = List<String>.from(data);
  }
}
