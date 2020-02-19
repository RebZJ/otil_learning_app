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
  // List<String> imagesPathList = List();
  // // List<String> audioAudioList = List();
  List<String> categoriesList;

  Entry({this.title, this.timestamp, this.body, this.categoriesList});

  factory Entry.fromJson(Map<String, dynamic> json) {
    var data1 = json['categoriesList'];
    List<String> data;
    if (data1 != null) {
      data = List<String>.from(data1);
    }
    // print(json);
    return Entry(
        title: json['title'],
        body: json['body'],
        timestamp: DateTime.parse(json['timestamp']),
        categoriesList: data);
  }
  //    imagesPathList = jsonDecode(json['imagesPathList']).map((json) => Entry.fromJson(json)).toList(),

  //     timestamp = DateTime.parse(json['timestamp'])

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        //   'imagesPathList': imagesPathList,
        'categoriesList': categoriesList,
      };
}

List<String> cateList = [];

List<Entry> entryList = [];

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get localFileEntries async {
  final path = await localPath;
  return File('$path/entries.txt');
}

void writeEntries() async {
  final file = await localFileEntries;
  // Write the file.
  await file.writeAsString(jsonEncode(entryList));
}

void readEntries() async {
  final file = await localFileEntries;

  // Read the file.
  String contents = await file.readAsString();

  List data = await jsonDecode(contents);
  entryList = data.map((json) => Entry.fromJson(json)).toList();
}


Future<File> get localFileCate async {
  final path = await localPath;
  return File('$path/categories.txt');
}

void writeCate() async {
  final file = await localFileCate;
  // Write the file.
  await file.writeAsString(jsonEncode(cateList));
}

void readCate() async {

  final file = await localFileCate;

  // Read the file.
  String contents = await file.readAsString();

  List data = await jsonDecode(contents);
  cateList = List<String>.from(data);
}

