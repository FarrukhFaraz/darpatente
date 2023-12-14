import 'package:flutter/material.dart';

import '../Utils/colors.dart';

Widget appBarTitle(String txt) {
  return Expanded(
    child: Center(
      child: Text(
        txt,
        style: TextStyle(
          color: appbarcolor,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


Widget appBarTitleButton(BuildContext context){
  return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: appbarcolor,
          border: Border.all(
            width: 1,
            color: appbarcolor,
          )),
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 4),
      child: Center(
          child: Text(
            'CHIUDI ESAME',
            style: TextStyle(fontSize: 15, color: kWhite),
          )));
}