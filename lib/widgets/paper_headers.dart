import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/timer_provider.dart';
import '../Utils/colors.dart';
import 'app_bar_vocabulary_widget.dart';

Widget showPaperHeaders(BuildContext context, bool showVocabulary,
    String userType, var showDialogBox, var onChange) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.03,
    ),
    child: Row(
      children: [
        InkWell(
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
        ),
        const Expanded(flex: 5, child: Text('')),
        InkWell(
          onTap: () {
            showDialogBox(context);
          },
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: appbarcolor,
                  border: Border.all(
                    width: 1,
                    color: appbarcolor,
                  )),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Center(
                  child: Text(
                'CHIUDI ESAME',
                style: TextStyle(fontSize: 15, color: kWhite),
              ))),
        ),
        const Expanded(flex: 3, child: Text('')),
        appBarVocabularyWidget(context, userType, showVocabulary, onChange),
      ],
    ),
  );
}
