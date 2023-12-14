import 'package:flutter/material.dart';

import 'colors.dart';


showSnackMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg , textAlign: TextAlign.center,style: const TextStyle(fontSize: 16),),
      backgroundColor: kLightBlue,
      elevation: 4,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      dismissDirection: DismissDirection.endToStart,
    ),
  );
}


showSnackErrorMessage(BuildContext context, String msg , int sec) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg , textAlign: TextAlign.center,style: const TextStyle(fontSize: 16),),
      backgroundColor: kLightBlue,
      elevation: 4,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      duration:  Duration(seconds: sec),
      margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      dismissDirection: DismissDirection.endToStart,
    ),
  );
}

