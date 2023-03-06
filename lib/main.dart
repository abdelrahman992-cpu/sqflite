import 'dart:async';
import 'package:ass/sqlflite.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqlDb.db;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      title: 'Sqlflite',
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'InsertData  ',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  int response = await sqlDb.insertData(
                      "INSERT into 'notes' ('note') VALUES ('note one')");
                  print(response);
                },
              ),
            ),
            Center(
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'ReadData  ',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  List<Map> response =
                      await sqlDb.readData("SELECT * FROM notes");
                  print(response);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Note {
  int? id;
  String? note;

  Note();
  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
  }
  toJson() => {"note": note};
}
