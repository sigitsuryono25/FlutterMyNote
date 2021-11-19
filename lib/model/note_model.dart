import 'package:floor/floor.dart';

@Entity(tableName: "tb_note")
class NoteModel {

  //it will be the primary key with Auto Increment
  //the name field is id
  @PrimaryKey(autoGenerate: true)
  int? id;

  //it will be field with name judul
  @ColumnInfo(name: "judul")
  String? judul;

  //this will be field with name isis
  @ColumnInfo(name: "isi")
  String? isi;

  //primary constructor must contain all of variable
  //use '{}' if the parameter is not required
  NoteModel({this.id, this.judul, this.isi});

  //secondary constructor
  NoteModel.withoutId(this.judul, this.isi);
}
