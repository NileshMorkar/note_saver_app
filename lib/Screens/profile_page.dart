import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Services/db.dart';
import 'package:note_saver/Widgets/myText.dart';
import 'package:note_saver/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/MyNoteModel.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String selectedImagePath = "";

  // Function to save a string value
  void saveStringPreference(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

// Function to retrieve a string value
  Future<String?> getStringPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

// Function to delete a preference
  void deletePreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  var archiveNotesCount = 0;
  var allNotesCount = 0;

  @override
  void initState() {
    super.initState();
    getPath();
  }

  void getPath() async {
    List<Note> allNotes = await NotesDatabase.instance.readAllNotes();
    selectedImagePath = (await getStringPreference("path"))!;

    allNotes.forEach((element) {
      if (element.archive == true) {
        archiveNotesCount++;
      }
    });
    setState(() {
      allNotesCount = allNotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 14),
                Stack(
                  children: [
                    selectedImagePath.isNotEmpty
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: FileImage(File(selectedImagePath)),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person),
                          ),
                    Positioned(
                        right: 0,
                        bottom: 0,

                        child: InkWell(
                          onTap: () {
                            setState(() async {
                              await selectImage();
                            });
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.green.shade600,
                            child: const Icon(Icons.camera_alt),
                          ),
                        ))
                  ],
                ),
                const SizedBox(height: 40),
                Row(children: [
                  myText("Name", textSize: 20),
                  const Spacer(),
                  myText("Nilesh Morkar"),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  myText("Total Notes", textSize: 20),
                  const Spacer(),
                  myText("${allNotesCount - archiveNotesCount}"),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  myText("Total Archive Notes", textSize: 20),
                  const Spacer(),
                  myText("${archiveNotesCount}"),
                ]),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                    },
                    child: myText("Save")),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Image Picker Card
  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      'Select Image From !',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromGallery();

                            if (selectedImagePath != '') {
                              saveStringPreference("path", selectedImagePath);
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
                                  "No Image Selected !",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/gallery.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Text('Gallery'),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromCamera();

                            if (selectedImagePath != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              saveStringPreference(
                                  "path", selectedImagePath as String);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("No Image Captured !"),
                              ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/camera.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Text('Camera'),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

//
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }
}
