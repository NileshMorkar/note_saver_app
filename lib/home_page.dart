import 'package:flutter/material.dart';
import 'package:note_saver/Widgets/myText.dart';
import 'package:note_saver/Widgets/my_drawer.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Screens/create_new_note.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/search_page.dart';
import 'Widgets/my_all_notes.dart';
import 'my_imp_class.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  String selectedImagePath = "";

  @override
  void initState() {
    super.initState();
    getPath();
  }

  void getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedImagePath = prefs.getString("path") == null ? "" : prefs.getString("path")! ;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewNote(),
              ));
        },
        backgroundColor: cardColor,
        child: const Icon(Icons.add, size: 30),
      ),
      endDrawerEnableOpenDragGesture: true,
      key: drawerKey,
      drawer: const MyDrawer(),
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {});
            },
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myAppBar(),
                  const SizedBox(height: 10),
                  myText("All", textSize: 20, textFontWeight: FontWeight.bold),
                  const SizedBox(height: 20),
                  const MyAllNotes(),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget myAppBar(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              TextButton(
                onPressed: () {
                  drawerKey.currentState!.openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ));
                },
                child: myText("Search Your Notes"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    MyImpClass.isGrid = !MyImpClass.isGrid;
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                },
                child: MyImpClass.isGrid
                    ? const Icon(
                  Icons.list_rounded,
                  color: Colors.lightBlue,
                )
                    : const Icon(
                  Icons.grid_view_rounded,
                  color: Colors.lightBlue,
                ),
              ),
              const SizedBox(width: 5),
              selectedImagePath.isNotEmpty
                  ? CircleAvatar(
                backgroundColor: Colors.white70,
                backgroundImage: FileImage(File(selectedImagePath)),
              )
                  : const CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }
}
