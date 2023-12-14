
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/colors.dart';

Widget pastPaperUserWidget(int index , dynamic model){
  return Container(
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.symmetric(
        vertical: 6),
    // height: MediaQuery.of(context).size.height * 0.12,
    decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(1),
        color: appbarcolor),
    child: Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10, top: 7),
          child: Text(
            '${index + 1}-',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: kWhite),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
                top: 12),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceEvenly,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${model.user!.name}',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                      FontWeight.w500,
                      color: kWhite),
                ),
                const SizedBox(height: 6),
                Text(
                  // "${list[index].questions!.examDate}",
                  DateFormat('dd-MMM-yyyy')
                      .format(DateTime.parse(
                      "${model.user!.examDate}"))
                      .toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w400,
                      color: kWhite),
                ),
                const SizedBox(
                  height: 6,
                )
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin:
          const EdgeInsets.only(top: 8),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text:
                    '${model.wrong}',
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold)),
                TextSpan(
                    text: '  Errori',
                    style: TextStyle(
                        fontSize: 20,
                        color: kWhite)),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        )
      ],
    ),
  );
}