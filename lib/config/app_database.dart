import 'package:floor/floor.dart';
import 'package:my_note/dao/note_dao.dart';
import 'package:my_note/model/note_model.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [NoteModel])
abstract class AppDatabase extends FloorDatabase {
  NoteDao get noteDao;
}
