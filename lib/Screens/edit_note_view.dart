import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Screens/note_view_page.dart';
import 'package:note_saver/Services/db.dart';
import 'package:note_saver/home_page.dart';

import '../Models/MyNoteModel.dart';

class EditNoteView extends StatefulWidget {
  final Note note;
  const EditNoteView({required this.note, super.key});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late String newTitle;
  late String newDescription;

  @override
  void initState() {
    super.initState();
    newTitle = widget.note.title;
    newDescription = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cardColor,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteViewPage(note:  widget.note),
                ));
          },
          child: const Icon(Icons.arrow_back_sharp),
        ),
        actions: [
          IconButton(
              splashRadius: 25,
              onPressed: () async {
                Note newNote = Note(
                    id: widget.note.id,
                    pin: widget.note.pin,
                    archive: false,
                    title: newTitle,
                    content: newDescription,
                    createdTime: DateTime.now());
                await NotesDatabase.instance.updateNote(newNote);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              icon: Icon(Icons.save_as)),
          SizedBox(width: 25),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                child: Form(
                  child: TextFormField(
                    initialValue: newTitle,
                    cursorWidth: 3,
                    onChanged: (value) {
                      newTitle = value;
                    },
                    style: TextStyle(color: Colors.white, fontSize: 22),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60),
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.blue),
              Container(
                height: 500,
                child: Form(
                  child: TextFormField(
                    initialValue: newDescription,
                    keyboardType: TextInputType.multiline,
                    minLines: 30,
                    maxLines: 50,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    cursorWidth: 3,
                    onChanged: (value) {
                      newDescription = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Note",
                      hintStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
