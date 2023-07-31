import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Services/db.dart';

import '../Models/MyNoteModel.dart';
import '../Widgets/myText.dart';
import 'note_view_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Note>results = [];
  bool isLoading = false;

  Future<void>getResults(String query)async{
    results.clear();

    setState(() {
      isLoading =true;
    });

    results = await NotesDatabase.instance.getAllSearchNotes(query.toLowerCase());

    setState(() {
      isLoading =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:cardColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                            if(value.trim().isNotEmpty) {
                              getResults(value);
                            }
                        },
                        cursorWidth: 4,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration:const InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintText: "Search Your Notes",
                          hintStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if(isLoading == false && results.isEmpty )
                  SizedBox( height :200,child: Center(child: myText("No Results Found!",textSize: 17),))
                else if(isLoading == false)
                  searchView(results),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Widget searchView(List<Note>notesList){
  return MasonryGridView.count(
    itemCount: notesList.length,
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NoteViewPage(note: notesList[index]),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: index.isEven
                ? Colors.blue.shade300
                : Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myText(notesList[index].title,
                  textFontWeight: FontWeight.bold, textSize: 18),
              myText(
                  DateFormat('dd-MMMM-yyyy')
                      .format(notesList[index].createdTime),
                  textSize: 14),
              const SizedBox(height: 10),

              myText(notesList[index].content.length < 250
                  ? notesList[index].content
                  : "${notesList[index].content.substring(0, 240)}..."),
            ],
          ),
        ),
      );
    },
  );
}