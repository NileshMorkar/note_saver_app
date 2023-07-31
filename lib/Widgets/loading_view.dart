import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingView(){
  return SpinKitChasingDots(
    size: 60,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
}
