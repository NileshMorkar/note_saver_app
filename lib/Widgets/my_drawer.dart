import 'package:flutter/material.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Screens/archive_page.dart';
import 'package:note_saver/Screens/profile_page.dart';

import '../Screens/settings_page.dart';
import 'myText.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 35),
              child: myText("NoteSaver",
                  textFontWeight: FontWeight.bold, textSize: 22),
            ),
            Divider(color: Colors.white54),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Icon(Icons.note_add),
                  SizedBox(width: 30),
                  myText("Notes", textSize: 18),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArchivePage(),
                    ));
              },
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Icon(Icons.archive),
                  SizedBox(width: 30),
                  myText("Archive", textSize: 18),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfilePage(),
                    ));
              },
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Icon(Icons.person),
                  SizedBox(width: 30),
                  myText("Profile", textSize: 18),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ));
              },
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Icon(Icons.settings),
                  SizedBox(width: 30),
                  myText("Settings", textSize: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
