import 'package:flutter/material.dart';
import 'package:note_saver/Models/MyNoteModel.dart';
import 'package:note_saver/Services/db.dart';
import 'package:note_saver/Widgets/myText.dart';
import 'package:note_saver/home_page.dart';
import '../Colors/colors.dart';

class CreateNewNote extends StatefulWidget {
  CreateNewNote({super.key});

  @override
  State<CreateNewNote> createState() => _CreateNewNoteState();
}

class _CreateNewNoteState extends State<CreateNewNote> {
  TextEditingController newNoteController = TextEditingController();
  TextEditingController newTitleController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    newNoteController.dispose();
    newTitleController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title:
            myText("New Note", textFontWeight: FontWeight.bold, textSize: 18),
        // elevation: 0,
        backgroundColor: cardColor,
        actions: [
          IconButton(
              splashRadius: 25,
              onPressed: () async {
                Note note = Note(
                    pin: false,
                    archive: false,
                    title: newTitleController.text.toString(),
                    content: newNoteController.text.toString(),
                    createdTime: DateTime.now());
                 await NotesDatabase.instance.insertEntry(note);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
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
                child: TextField(
                  controller: newTitleController,
                  cursorWidth: 3,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60),
                  ),
                ),
              ),
              Divider(color: Colors.blue),
              Container(
                height: 500,
                child: TextField(
                  controller: newNoteController,
                  keyboardType: TextInputType.multiline,
                  minLines: 30,
                  maxLines: 50,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  cursorWidth: 3,
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
            ],
          ),
        ),
      ),
    );
  }
}
