import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:excel_to_anything/exceltoanything.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Text("PRESS TO UPLOAD EXCEL AND CONVERT TO JSON"),
                  onPressed: () {
                    Excelifiers().excelToJson().then((onValue) {
                      print(onValue);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  child: Text(
                      "PRESS TO UPLOAD EXCEL AND UPLOAD TO YOUR SQLITE DATABASE"),
                  onPressed: () async {
                    Excelifiers().excelToSql(
                        db: db,
                        tableName: "sss",
                        dbExist: true,
                        tableExist: false);
                  },
                ),
              ),
              ElevatedButton(
                child: Text("GET ALL VALUES"),
                onPressed: () async {
                  var res = await db.rawQuery("SELECT * FROM sss");
                  print(res.toString());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    createDB();
    super.initState();
  }

  void createDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + 'my_db.db';
    db = await openDatabase(path);
  }
}
