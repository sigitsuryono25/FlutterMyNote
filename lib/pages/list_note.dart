import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:my_note/config/app_database.dart';
import 'package:my_note/constant.dart';
import 'package:my_note/model/note_model.dart';
import 'package:my_note/pages/edit_note.dart';
import 'package:need_resume/need_resume.dart';

class ListNote extends StatefulWidget {
  const ListNote({Key? key}) : super(key: key);

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends ResumableState<ListNote> {
  final Future<AppDatabase> _database =
      $FloorAppDatabase.databaseBuilder(Constant.DB_NAME).build();

  @override
  void onResume() {
    super.onResume();
    setState(() {
      getListNote();
    });
  }

  @override
  void onReady() {
    super.onReady();
    print("onready");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Note"),
      ),
      body: futureBuilder(),
    );
  }

  Widget futureBuilder() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<NoteModel>> data) {
        if (data.hasData) {
          return setToListViewBuilder(data);
        } else if (data.hasError) {
          return const Center(child: Text("Error occurred"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: getListNote(),
    );
  }

  Future<List<NoteModel>> getListNote() {
    return _database.then((value) => value.noteDao.getAllNote());
  }

  Widget setToListViewBuilder(AsyncSnapshot<List<NoteModel>> data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: [
            Expanded(
              child: Text(
                data.data![index].judul.toString(),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  color: Colors.greenAccent,
                  icon: const Icon(Icons.remove_red_eye_outlined),
                ),
                IconButton(
                  color: Colors.amber,
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         EditNote(model: data.data![index]),
                    //   ),
                    // );
                    push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditNote(model: data.data![index]),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  color: Colors.red,
                  onPressed: () {
                    showDialog(data.data![index]);
                  },
                  icon: const Icon(Icons.highlight_remove_outlined),
                )
              ],
            )
          ]),
        );
      },
      itemCount: data.data?.length,
    );
  }

  Future<int> deleteData(NoteModel noteModel) {
    return _database.then((value) => value.noteDao.deleteNote(noteModel));
  }

  //show alert dialog
  /* *
  * visit https://pub.dev/packages/flutter_dialogs
  * */
  void showDialog(NoteModel noteModel) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Delete this note?"),
        content: const Text("This action cannot be undone."),
        actions: [
          BasicDialogAction(
            title: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BasicDialogAction(
            title: const Text(
              "Yes, delete it!",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              //harus data, kalo berhasil update datanya pake set state
              deleteData(noteModel).then(
                (value) => {
                  if (value > 0)
                    {
                      setState(() {
                        getListNote();
                      })
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to delete note"),
                        ),
                      )
                    },
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }
}
