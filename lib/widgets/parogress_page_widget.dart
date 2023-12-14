import 'package:flutter/material.dart';

import '../Models/QuestionModel.dart';
import '../Screens/Quiz/help_screen.dart';
import '../Utils/Navigator.dart';
import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget progressPageWidget(
  BuildContext context,
  int index,
  bool val,
  bool ans,
  double radius,
  String userType,
  var list,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
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
          flex: (list[index].questionPicture == null ||
                  list[index].questionPicture.toString().isEmpty ||
                  list[index].questionPicture == 'null')
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
                        '${imageBaseURL}topics/${list[index].questionPicture.toString()}'),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          flex: (list[index].questionPicture == null ||
                  list[index].questionPicture.toString().isEmpty ||
                  list[index].questionPicture == 'null')
              ? 87
              : 80,
          child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: appbarcolor.withOpacity(0.4), width: 1.2),
                  right: BorderSide(
                      color: appbarcolor.withOpacity(0.4), width: 1.2),
                ),
              ),
              child: Text(
                '${list[index].name}',
                maxLines: 50,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, height: 1.3),
              )),
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
                              color: list[index].attempted == 'vera'
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
                              color: list[index].attempted == 'falsa'
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
                                  questionNo: list[index].questionNo.toString(),
                                  topicImage:
                                  list[index].questionPicture.toString(),
                                  question: list[index].name.toString(),
                                  questionImage:
                                  list[index].extraPicture ?? 'null',
                                  voice: list[index].voice ?? 'null',
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


Widget progressErroriPageWidget(
    BuildContext context,
    int index,
    bool val,
    bool ans,
    double radius,
    String userType,
    List<QuestionModel> list,
    ){
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
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
          flex: (list[index].topic!.topicPicture == null ||
              list[index].topic!.topicPicture.toString().isEmpty ||
              list[index].topic!.topicPicture == 'null')
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
                    '${imageBaseURL}topics/${list[index].topic!.topicPicture}'),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          flex: (list[index].topic!.topicPicture == null ||
              list[index].topic!.topicPicture.toString().isEmpty ||
              list[index].topic!.topicPicture == 'null')
              ? 87
              : 80,
          child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: appbarcolor.withOpacity(0.4), width: 1.2),
                  right: BorderSide(
                      color: appbarcolor.withOpacity(0.4), width: 1.2),
                ),
              ),
              child: Text(
                '${list[index].name}',
                maxLines: 50,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, height: 1.3),
              )),
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
                              color: list[index].myAttempted == 'vera'
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
                              color: list[index].myAttempted == 'falsa'
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
                                  questionNo: list[index].questionNo.toString(),
                                  topicImage:
                                  list[index].topic!.topicPicture.toString(),
                                  question: list[index].name.toString(),
                                  questionImage:
                                  list[index].questionPicture ?? 'null',
                                  voice: list[index].voice ?? 'null',
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