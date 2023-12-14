
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/timer_provider.dart';


Widget appBarIcon(BuildContext context){
  return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(
          Icons.arrow_back_ios,
          size: 24,
        ),
      ));
}

Widget appBarIconQuestion(BuildContext context){
  return InkWell(
    onTap: () {
      context.read<TimerProvider>().stopTimer();
      Timer(const Duration(milliseconds: 100), () {
        Navigator.pop(context);
      });
    },
    child: const Icon(
      Icons.arrow_back_ios,
      size: 22,
    ),
  );
}