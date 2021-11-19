import 'package:flutter/material.dart';
import 'package:my_note/config/app_database.dart';
import 'package:my_note/constant.dart';
import 'package:my_note/model/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _judul = TextEditingController();
  final TextEditingController _isi = TextEditingController();

  //new instance of database. pakai future karena kita harus tunggu proses instance selesai.
  final Future<AppDatabase> _database =
      $FloorAppDatabase.databaseBuilder(Constant.DB_NAME).build();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: "Title",
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _isi,
              maxLines: 10, //biar ukuran textfieldnya jadi lebih tinggi
              decoration: const InputDecoration(
                labelText: "Content",
                isDense: true, //dense ini supaya tampilan textfieldnya lebih ramping (tingginya)
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              onPressed: () {
                populateData();
              },
              child: const Text("Save Note"),
            ),
          ],
        ),
      ),
    );
  }

  void populateData() {
    if (_judul.text.toString().isNotEmpty || _isi.text.toString().isNotEmpty) {
      //prepare model untuk insert data
      NoteModel model =
          NoteModel.withoutId(_judul.text.toString(), _isi.text.toString());

      // pakai then karena kita nunggu process insert selesai. karena insertToDatabase
      // itu future<int> maka pakai then untuk terima value nya.
      // setelah diterima valuenya, dicek lagi, apakah lebih dari 0 atau tidak.
      // kenapa 0? karena kembalian proses insert itu adalah row affected yakni
      // seberapa banyak baris yang berhasil diinsert. Kalo berhasil seharusnya
      // akan lebih dari 0 begitu juga sebaliknya.

      insertToDatabase(model).then((value) => {
            if (value > 0)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Success save note"),
                  ),
                )
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to save note"),
                  ),
                )
              },
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all column"),
        ),
      );
    }
  }

  Future<int> insertToDatabase(NoteModel model) {
    //kita bawa object _database dari yang sudah di instance diawal.
    //kita pakai then karena kita harus memastikan proses instance sudah berhasil
    //ketika sudah berhasil, barulah kita melakukan CRUD

    return _database.then((value) => value.noteDao.insertNote(model));
  }
}
