
import 'package:flutter/material.dart';

Widget myText(String str,{Color textColor = Colors.white,FontWeight textFontWeight = FontWeight.normal,double textSize = 16}){
  return Text(str,style: TextStyle(color: textColor,fontWeight: textFontWeight,fontSize: textSize),);
}