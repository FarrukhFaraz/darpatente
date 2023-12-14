import 'package:flutter/material.dart';

import '../Utils/colors.dart';

Widget startQuizWidget(BuildContext context, dynamic model) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.700,
    margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
    height: MediaQuery.of(context).size.height * 0.22,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(25), color: kWhite),
    child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Image.asset(
              model.img,
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width * 0.21,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.033,
            ),
            SizedBox(
              //height: MediaQuery.of(context).size.height,
              child: Text(
                model.date,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: appbarcolor),
              ),
            ),
          ],
        )),
  );
}
