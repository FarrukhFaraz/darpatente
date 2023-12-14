import 'package:flutter/material.dart';

import '../Models/QuestionModel.dart';
import '../Screens/Quiz/help_screen.dart';
import '../Utils/Navigator.dart';
import '../Utils/colors.dart';
import 'vocabulary_clickable_text.dart';

Widget topicQuizWidget(BuildContext context, bool showVocabulary, int index,
    List<QuestionModel> questionLis) {

  QuestionModel model = questionLis[index];

  return Container(
    margin: const EdgeInsets.only(
      top: 5,
    ),
    constraints: const BoxConstraints(minHeight: 65),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(4), color: kWhite),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  model.answer.toString() == 'vera'
                      ? '${index + 1}V'
                      : '${index + 1}F',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w400),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            InkWell(
              onTap: () {
                navPush(
                    context,
                    HelpScreen(
                      questionNo: model.questionNo ?? '',
                      topicImage:
                      model.topic!.topicPicture.toString(),
                      question: model.name.toString(),
                      questionImage:
                      model.questionPicture ?? 'null',
                      voice: model.voice ?? 'null',
                    ));
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.104,
                  margin: const EdgeInsets.only(
                    left: 4,
                  ),
                  height: MediaQuery.of(context).size.height * 0.036,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kblues,
                  ),
                  child: Center(
                      child: Text(
                    'Help',
                    style: TextStyle(fontSize: 14, color: appbarcolor),
                  ))),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          width: 1, color: appbarcolor.withOpacity(0.7)))),
              child: Center(
                child: showVocabulary
                    ? VocabularyClickableText(
                        text: '${model.name}',
                      )
                    : Text(
                        "${model.name}",
                        maxLines: 50,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: kBlack,
                            height: 1.4),
                      ),
              )),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.06,
        ),
      ],
    ),
  );
}
