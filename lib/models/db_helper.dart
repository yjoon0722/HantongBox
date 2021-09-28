import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hantong_cal/models/password_status.dart';

final String TableName = 'PasswordStatus';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    if(!kIsWeb && !Platform.isMacOS){
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'MyPasswordStatusDB.db');

      return await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
          CREATE TABLE $TableName(
            lastTime TEXT PRIMARY KEY,
            isOpenSalesStatus INTEGER
          )
        ''');
          },
          onUpgrade: (db, oldVersion, newVersion){}
      );
    }
  }

  // Create
  createData() async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $TableName(lastTime,isOpenSalesStatus) VALUES(?,?)', [_dateFormat(DateTime.now()),0]);
    return res;
  }

  // ReadLastTime
  getLastTime() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    print(res);
    return res.isNotEmpty ? PasswordStatus(lastTime: res.first['lastTime']) : null;
  }

  // ReadIsOpenSalesStatus
  getIsOpenSalesStatus() async {
    final db = await database;
    var isOpenSalesStatus = await db.rawQuery('SELECT * FROM $TableName');
    print(isOpenSalesStatus);
    var res = isOpenSalesStatus.isNotEmpty ? PasswordStatus(isOpenSalesStatus: isOpenSalesStatus.first['isOpenSalesStatus']) : null;
    return res.isOpenSalesStatus;
  }

  // CompareLastTime
  compareTime() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    // 잠금시간 160시간
    if(int.tryParse(_dateFormat(DateTime.now())) - int.tryParse('${res.first['lastTime']}') >= 9600) {
      return false;
    }else {
      return true;
    }
  }

  // UpdateLastTime
  updateLastTime() async {
    final db = await database;
    var lastTime = await db.rawQuery('SELECT * FROM $TableName');
    var res = await db.rawUpdate('UPDATE $TableName SET lastTime = ? WHERE lastTime = ?', [_dateFormat(DateTime.now()),lastTime.first['lastTime']]);
    return res;
  }

  // UpdateIsOpenSalesStatus
  updateIsOpenSalesStatus0() async {
    final db = await database;
    var isOpenSalesStatus = await db.rawQuery('SELECT * FROM $TableName');
    var res = await db.rawUpdate('UPDATE $TableName SET isOpenSalesStatus = ? WHERE isOpenSalesStatus = ?', [0,isOpenSalesStatus.first['isOpenSalesStatus']]);
    return res;
  }

  // UpdateIsOpenSalesStatus
  updateIsOpenSalesStatus1() async {
    final db = await database;
    var isOpenSalesStatus = await db.rawQuery('SELECT * FROM $TableName');
    var res = await db.rawUpdate('UPDATE $TableName SET isOpenSalesStatus = ? WHERE isOpenSalesStatus = ?', [1,isOpenSalesStatus.first['isOpenSalesStatus']]);
    print('update done');
    return res;
  }

}

// yyyyMMddHHmm DateFormat
String _dateFormat(DateTime dateTime) {
  return DateFormat('yyyyMMddHHmm').format(dateTime);
}