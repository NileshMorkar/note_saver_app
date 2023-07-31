import 'package:flutter/material.dart';
import 'package:note_saver/Colors/colors.dart';
import 'package:note_saver/Widgets/myText.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool value1 = true;
  bool value2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  myText("Sync",textSize:18),
                  const Spacer(),
                  Transform.scale(
                    scale: 1.1,
                    child: Switch.adaptive(value: value1, onChanged: (value){
                      setState(() {
                        value1 = value;
                      });
                    },),
                  ),
                ],
              ),
              Row(
                children: [
                  myText("Dark Mode",textSize:18),
                  const Spacer(),
                  Transform.scale(
                    scale: 1.1,
                    child: Switch.adaptive(
                      value: value2, onChanged: (switchValue){
                      setState(() {
                        // bgColor = Colors.white;
                        value2 = switchValue;
                      });
                    },),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
