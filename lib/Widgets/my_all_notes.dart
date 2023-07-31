import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_saver/Services/db.dart';
import 'package:note_saver/Widgets/loading_view.dart';
import 'package:note_saver/Screens/note_view_page.dart';
import '../Models/MyNoteModel.dart';
import 'myText.dart';
import 'package:intl/intl.dart';
import 'package:note_saver/my_imp_class.dart';

class MyAllNotes extends StatefulWidget {
  const MyAllNotes({super.key});

  @override
  State<MyAllNotes> createState() => _MyAllNotesState();
}

class _MyAllNotesState extends State<MyAllNotes> {
  late List<Note> notesList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  Future<void> getAllNotes() async {
    notesList = await NotesDatabase.instance.readAllNotes();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            height: 500,
            child: Center(
              child: loadingView(),
            ),
          )
        : Column(
            children: [
              MyImpClass.isGrid
                  ? MasonryGridView.count(
                      itemCount: notesList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemBuilder: (context, index) {
                        return notesList[index].archive
                            ? Container(height: 0)
                            : InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteViewPage(
                                            note: notesList[index]),
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.blue.shade500
                                        : Colors.red.shade500,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      myText(notesList[index].title,
                                          textFontWeight: FontWeight.bold,
                                          textSize: 18),
                                      myText(
                                          DateFormat('dd-MMMM-yyyy').format(
                                              notesList[index].createdTime),
                                          textSize: 14),
                                      const SizedBox(height: 10),
                                      myText(notesList[index].content.length <
                                              250
                                          ? notesList[index].content
                                          : "${notesList[index].content.substring(0, 240)}..."),
                                    ],
                                  ),
                                ),
                              );
                      },
                    )
                  : ListView.builder(
                      itemCount: notesList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return notesList[index].archive
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteViewPage(
                                          note: notesList[index],
                                        ),
                                      ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.blue.shade300
                                        : Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      myText(notesList[index].title,
                                          textFontWeight: FontWeight.bold,
                                          textSize: 18),
                                      myText(
                                          DateFormat('dd-MMMM-yyyy').format(
                                              notesList[index].createdTime),
                                          textSize: 14),
                                      const SizedBox(height: 7),
                                      const SizedBox(height: 6),
                                      myText(notesList[index].content.length <
                                              250
                                          ? notesList[index].content
                                          : "${notesList[index].content.substring(0, 240)}..."),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
            ],
          );
  }
}
