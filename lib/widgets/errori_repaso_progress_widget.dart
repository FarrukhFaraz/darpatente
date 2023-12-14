import 'package:flutter/material.dart';

import '../Models/repaso_errori_question_model.dart';
import '../Screens/Quiz/help_screen.dart';
import '../Utils/Navigator.dart';
import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget erroriRepasoProgressWidget(
  BuildContext context,
  int index,
  String userType,
  bool ans,
  bool val,
  double radius,
  RepasoErroriQuestionModel model,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    margin: const EdgeInsets.only(
      top: 5,
    ),
    // height: MediaQuery.of(context).size.height * 0.086,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: kWhite,
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: (model.questionPicture == null || model.questionPicture.toString().isEmpty || model.questionPicture == 'null') ? 8 : 15,
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
                        '${imageBaseURL}topics/${model.questionPicture.toString()}'),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          flex: (model.questionPicture == null || model.questionPicture == 'null') ? 87 : 80,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.symmetric(
                  horizontal:
                      (model.questionPicture == null || model.questionPicture == 'null') ? 10 : 10,
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
                '${model.name}',
                maxLines: 50,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              )),
        ),
        const SizedBox(
          width: 3,
        ),
        Expanded(
          flex: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
              const SizedBox(height: 4),
              Center(
                child: Visibility(
                  visible: userType == 'paid' ? true : false,
                  maintainAnimation: true,
                  maintainInteractivity: true,
                  maintainSemantics: true,
                  maintainSize: true,
                  maintainState: true,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.122,
                      margin: const EdgeInsets.only(
                        left: 2,
                      ),
                      height: MediaQuery.of(context).size.height * 0.036,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: kblues,
                      ),
                      child: InkWell(
                        onTap: () {
                          if(userType == 'paid'){
                            navPush(
                                context,
                                HelpScreen(
                                  questionNo: model.questionNo.toString(),
                                  topicImage:
                                  model.questionPicture.toString(),
                                  question: model.name.toString(),
                                  questionImage:
                                  model.extraPicture ?? 'null',
                                  voice: model.voice ?? 'null',
                                ));
                          }
                        },
                        child: Center(
                            child: Text(
                              'Help',
                              style: TextStyle(fontSize: 12, color: appbarcolor),
                            )),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
