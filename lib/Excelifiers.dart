import 'dart:io';

import 'package:excel/excel.dart';
import 'package:exceltoanything/globals.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Excelifiers {
  Future<String> excelToJson() async {
    var file = await FilePicker.getFilePath(
        type: FileType.custom, allowedExtensions: ['xlsx', 'csv', 'xls']);
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes, update: true);
    int i = 0;
    List<dynamic> keys = new List<dynamic>();
    List<Map<String, dynamic>> json = new List<Map<String, dynamic>>();
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        if (i == 0) {
          keys = row;
          i++;
        } else {
          Map<String, dynamic> temp = Map<String, dynamic>();
          int j = 0;
          String tk = '';
          for (var key in keys) {
            tk = "\u201C" + key + "\u201D";
            temp[tk] = (row[j].runtimeType == String)
                ? "\u201C" + row[j].toString() + "\u201D"
                : row[j];
            j++;
          }
          json.add(temp);
        }
      }
    }
    print(json.length);
    String fullJson = json.toString().substring(1, json.toString().length - 1);
    return fullJson;
  }

  void excelToSql(
      {@required tableName,
      Database db,
      dbExist = true,
      tableExist = false,
      dbName}) async {
    if (dbExist == false) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = documentsDirectory.path + dbName + ".db";
      await openDatabase(path, version: 1, onOpen: (db) {
        print("DB CREATED");
      });
    }

    var file = await FilePicker.getFilePath(
        type: FileType.custom, allowedExtensions: ['xlsx', 'csv', 'xls']);
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes, update: true);
    int i = 0;
    List<dynamic> keys = new List<dynamic>();
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        //collecting excel headers
        if (i == 0) {
          keys = row;
          i = 1;
          print(keys.toString());
        }
        //collecting row data
        else {
          int j = 0;
          String newInsert =
              "INSERT INTO $tableName (${keys.toString().substring(1, keys.toString().length - 1)}) VALUES (";
          String createQuery = "CREATE TABLE $tableName (";
          for (var key in keys) {
            newInsert += (row[j].runtimeType == String)
                ? "\u0022" + row[j].toString() + "\u0022,"
                : "" + row[j].toString() + ",";

            //creating table based on data from row1
            if (i == 1) {
              if (j == 0) {
                if (row[j].runtimeType == String) {
                  createQuery += "$key TEXT PRIMARY KEY,";
                } else if (row[j].runtimeType == int) {
                  createQuery += "$key INTEGER NOT NULL,";
                } else if (row[j].runtimeType == double) {
                  createQuery += "$key REAL NOT NULL,";
                } else if (row[j].runtimeType == null) {
                  createQuery += "$key TEXT,";
                } else {
                  createQuery += "$key TEXT,";
                }
              } else {
                if (row[j].runtimeType == String) {
                  createQuery += "$key TEXT NOT NULL,";
                } else if (row[j].runtimeType == int) {
                  createQuery += "$key INTEGER NOT NULL,";
                } else if (row[j].runtimeType == double) {
                  createQuery += "$key REAL NOT NULL,";
                } else if (row[j].runtimeType == null) {
                  createQuery += "$key TEXT,";
                } else {
                  createQuery += "$key TEXT,";
                }
              }
            }

            if (j == keys.length - 1) {
              if (i == 1) {
                createQuery =
                    createQuery.substring(0, createQuery.length - 1) + ")";
                print(createQuery);
                await db.rawQuery(createQuery);
                print("TABLE CREATED");
                tableAlreadyCreated = true;
                newInsert = newInsert.substring(0, newInsert.length - 1) + ")";
                await db.rawQuery(newInsert);
                print("ROW INSERTED");
                i = 2;
              } else {
                newInsert = newInsert.substring(0, newInsert.length - 1) + ")";
                await db.rawQuery(newInsert);
                print("ROW INSERTED");
              }
            }
            j++;
            //print(j);
          }
          i++;
        }
      }
    }
    prevPath = file;
  }
}
