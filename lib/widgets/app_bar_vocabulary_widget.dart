import 'package:flutter/material.dart';

import '../Utils/colors.dart';

Widget appBarVocabularyWidget(BuildContext context , String userType , bool showVocabulary , var onChanged){
  return Visibility(
    visible: userType == 'paid' ? true : false,
    maintainSize: true,
    maintainState: true,
    maintainAnimation: true,
    child: Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 30,
            child: Switch(
              value: showVocabulary,
              onChanged: onChanged,
              activeColor: kLightBlue,
            ),
          ),
          const SizedBox(height: 1),
          const Text(
            'vocabolario',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 2),
        ],
      ),
    ),
  );
}