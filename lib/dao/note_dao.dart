import 'package:floor/floor.dart';
import 'package:my_note/model/note_model.dart';

@dao
abstract class NoteDao{

  @Query("SELECT * FROM tb_note")
  Future<List<NoteModel>> getAllNote();

  //onconflict strategy replace artinya jika ada data yang di
  //insert kan dengan primary key yang sama, maka akan mengganti yang
  //sudah ada sebelumnya.

  /*
   * see
   * OnConflictStrategy
   *
   * */
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertNote(NoteModel model);

  @delete
  Future<int> deleteNote(NoteModel model);

}