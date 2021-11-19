import 'package:flutter/material.dart';
import 'package:my_note/pages/add_note.dart';
import 'package:my_note/pages/list_note.dart';

void main() {
  runApp(
    MaterialApp(
      home: const MainMenu(),
      theme: ThemeData.dark(),
    ),
  );
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Menu"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddNote(),
                        ),
                      );
                    },
                    child: const Text("Add Note"),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListNote(),
                        ),
                      );
                    },
                    child: const Text("List of Note"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
