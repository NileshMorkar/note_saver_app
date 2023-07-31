import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:note_saver/Services/db.dart';
import 'package:note_saver/Widgets/loading_view.dart';
import 'package:note_saver/Widgets/myText.dart';
import 'package:note_saver/Colors/colors.dart';

import '../Models/MyNoteModel.dart';
import 'note_view_page.dart';

class ArchivePage extends StatefulWidget {
  ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<Note> archiveNotesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllArchiveNotes();
  }

  Future<void> getAllArchiveNotes() async {
    List<Note> allNotes = await NotesDatabase.instance.readAllNotes();
    archiveNotesList.clear();

    allNotes.forEach((element) {
      if (element.archive == true) {
        setState(() {
          archiveNotesList.add(element);
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Text("Archive Notes"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {});
            },
          );
        },
        child: isLoading
            ? SizedBox(
                height: 500,
                child: Center(
                  child: loadingView(),
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: archiveNotesList.isEmpty?SizedBox(
                    height: 200,
                    child: Center(
                      child: myText("No Results Found!"),
                    ),
                  ):Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        myText("All",
                            textSize: 20, textFontWeight: FontWeight.bold),
                        const SizedBox(height: 20),
                        Container(
                          child: MasonryGridView.count(
                            itemCount: archiveNotesList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteViewPage(
                                            note: archiveNotesList[index]),
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.blue.shade300
                                        : Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      myText(archiveNotesList[index].title,
                                          textFontWeight: FontWeight.bold,
                                          textSize: 18),
                                      myText(
                                          DateFormat('dd-MMMM-yyyy')
                                              .format(archiveNotesList[index].createdTime),
                                          textSize: 14),
                                      const SizedBox(height: 10),
                                      myText(archiveNotesList[index]
                                                  .content
                                                  .length <
                                              250
                                          ? archiveNotesList[index].content
                                          : "${archiveNotesList[index].content.substring(0, 240)}..."),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
