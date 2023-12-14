import 'package:flutter/material.dart';

import '../Models/past_questions_by_user_model.dart';
import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget pastPaperProgressWidget(
  BuildContext context,
  int index,
  bool ans,
  double radius,
  bool val,
    List<PastPaperByQuestionModel> list,
) {
  PastPaperByQuestionModel model = list[index];
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    margin: const EdgeInsets.only(
      top: 5,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: kWhite,
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex:
          (model.image == null ||
                  model.image.toString().isEmpty ||
                  model.image == 'null')
              ? 8
              : 15,
          child: Container(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.all(1),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(color: kBlack, fontSize: 16),
                    )),
                val
                    ? const SizedBox()
                    : cacheImage(context,
                        '${imageBaseURL}tests/${model.image.toString()}'),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          flex: (model.image == null || model.image.toString().isEmpty  ||
              model.image == 'null')
              ? 87
              : 80,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.symmetric(
                  horizontal:
                  (model.image == null || model.image.toString().isEmpty  ||
                      model.image == 'null')
                          ? 10
                          : 10,
                  vertical: 12),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              decoration:  BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: appbarcolor.withOpacity(0.4), width: 1.2),
                          right: BorderSide(
                              color: appbarcolor.withOpacity(0.4),
                              width: 1.2))),
              child: Text(
                '${model.question}',
                maxLines: 50,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              )),
        ),
        Expanded(
          flex: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('V'),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: model.myAttempted == 'vera'
                              ? ans
                                  ? kLightGreen
                                  : kLightRed.withOpacity(0.7)
                              : kWhite),
                      width: radius / 2,
                      height: radius / 2,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('F'),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: model.myAttempted == 'falsa'
                              ? ans
                                  ? kLightGreen
                                  : kLightRed.withOpacity(0.7)
                              : kWhite),
                      width: radius / 2,
                      height: radius / 2,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
