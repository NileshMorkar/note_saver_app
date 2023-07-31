import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_saver/Services/db.dart';
import 'package:note_saver/Widgets/myText.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Screens/edit_note_view.dart';
import 'package:note_saver/home_page.dart';
import '../Models/MyNoteModel.dart';

class NoteViewPage extends StatelessWidget {
  Note note;

  NoteViewPage({required this.note,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: InkWell(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
            },
            child: const Icon(Icons.arrow_back_sharp)),
        actions: [
          IconButton(
            splashRadius: 24,
            onPressed: () async{
              await NotesDatabase.instance.updatePin(note);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
            },
            icon: Icon(note.pin?CupertinoIcons.pin_fill:CupertinoIcons.pin_slash),
          ),
          IconButton(
            splashRadius: 24,
            onPressed: ()async {
              await NotesDatabase.instance.updateArchive(note);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
            },
            icon: Icon(note.pin?CupertinoIcons.archivebox_fill:CupertinoIcons.archivebox),
          ),
          IconButton(
            splashRadius: 24,
            onPressed: ()async {
              await NotesDatabase.instance.deleteNote(note);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
            },
            icon: Icon(CupertinoIcons.delete,color: Colors.red.shade600),
          ),
          IconButton(
            splashRadius: 24,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditNoteView(note: note,),));
            },
            icon: const Icon(Icons.edit,color: Colors.green,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myText(note.title,textFontWeight: FontWeight.bold,textSize: 20),
              myText(
                  DateFormat('dd-MMMM-yyyy')
                      .format(note.createdTime),
                  textSize: 14),
              const SizedBox(height: 16),
              myText(note.content),
            ],
          ),
        ),
      ),
    );
  }
}
