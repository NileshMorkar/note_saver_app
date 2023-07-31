import 'package:flutter/material.dart';
import 'package:note_saver/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteSaver",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        fontFamily: "poppins",
      ),
      home: const HomePage(),
    );
  }
}
