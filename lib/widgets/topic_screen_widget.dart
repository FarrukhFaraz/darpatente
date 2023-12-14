import 'package:flutter/material.dart';

import '../Screens/Quiz/Topic/topic_quiz.dart';
import '../Screens/Quiz/Topic/topic_video.dart';
import '../Utils/Navigator.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget topicScreenWidget(
  BuildContext context,
  String chapterId,
  String userType,
  int index,
  dynamic topicList,
  var showMessageDialogBox,
) {
  return Container(
    constraints: const BoxConstraints(minHeight: 100.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: kWhite,
    ),
    margin: const EdgeInsets.only(top: 6),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (userType == 'free') {
                  showSnackMessage(context, 'only for paid user');
                } else if (userType == 'paid') {
                  navPush(
                      context,
                      TopicQuizScreen(
                        topicList: topicList,
                        chapterId: chapterId,
                        activeIndex: index,
                      ));
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.040,
                margin: const EdgeInsets.only(left: 14, top: 4),
                width: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 1, color: appbarcolor)),
                child: Center(child: Text('${topicList[index].topicNo}')),
              ),
            ),
            InkWell(
              onTap: () {
                showMessageDialogBox(context, topicList[index].id.toString());
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.14,
                  margin: const EdgeInsets.only(left: 170, top: 4),
                  height: MediaQuery.of(context).size.height * 0.040,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 1,
                        color: appbarcolor,
                      )),
                  child: const Center(child: Text('Quiz'))),
            ),
            userType == 'free'
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      if (topicList[index].topicVideo == null ||
                          topicList[index].topicVideo.toString().isEmpty ||
                          topicList[index].topicVideo.toString() == 'null') {
                        showSnackMessage(context, 'coming soon..');
                      } else {
                        navPush(
                            context,
                            TopicVideoScreen(
                              topicName: topicList[index].question.toString(),
                              video: topicList[index].topicVideo.toString(),
                            ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 6,
                        top: 4,
                        right: 20,
                      ),
                      child: Image(
                          height: MediaQuery.of(context).size.height * 0.044,
                          image: const AssetImage('assets/images/video.png')),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  '${topicList[index].question}',
                  style: const TextStyle(fontSize: 17, height: 1.3),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
                margin: const EdgeInsets.only(right: 6),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.3,
                  maxHeight: MediaQuery.of(context).size.height*0.12,

                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: (topicList[index].topicPicture == null ||
                        topicList[index].topicPicture == 'null')
                    ? const SizedBox()
                    : cacheImage(context,
                        '${imageBaseURL}topics/${topicList[index].topicPicture}'))
          ],
        ),
        const SizedBox(height: 2),
      ],
    ),
  );
}
