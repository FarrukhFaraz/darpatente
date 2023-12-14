import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/QuestionModel.dart';
import '../../../Models/topic_model.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/Network/check_connectivity.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/messages.dart';
import '../../../Utils/url.dart';
import '../../../widgets/app_bar_icon.dart';
import '../../../widgets/app_bar_vocabulary_widget.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/topic_quiz_widget.dart';
import '../QuestionPaper/no_question_paper.dart';
import '../QuestionPaper/yes_question_paper.dart';

class TopicQuizScreen extends StatefulWidget {
  const TopicQuizScreen({
    super.key,
    required this.chapterId,
    required this.topicList,
    required this.activeIndex,
  });

  final String chapterId;
  final List<TopicsModel> topicList;
  final int activeIndex;

  @override
  State<TopicQuizScreen> createState() => _TopicQuizScreenState();
}

class _TopicQuizScreenState extends State<TopicQuizScreen> {
  bool a = false;
  bool b = false;

  bool showVocabulary = false;

  int activeIndex = 0;

  bool backwardArrow = true;
  bool forwardArrow = true;

  bool checkConnection = false;
  bool loader = false;
  bool dialogLoader = false;

  var bookId;
  int time = 0;

  List<QuestionModel> questionList = <QuestionModel>[];

  var radius = 20.0;

  checkConnectivity(String id) async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      getQuestionList(id);
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  getQuestionList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('id');
    setState(() {
      loader = true;
      questionList.clear();
    });

    var bookId = prefs.getString('MainCategoryId');
    Map body = {
      'cat_id': id.toString(),
      'user_id': user_id.toString(),
      'book_id': bookId.toString(),
      'chapter_id': widget.chapterId.toString(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(questionByTopicURL), body: body);

      Map jsonData = jsonDecode(response.body);
      print('jsondata::::::::$jsonData');

      if (jsonData['status'] == 200) {
        setState(() {
          var t = jsonData['Books']['time'];
          bookId = jsonData['Books']['id'].toString();
          if (t != null || t.toString().isNotEmpty) {
            time = int.parse(t.toString());
          } else {
            time = 30;
          }
        });

        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          QuestionModel pos = QuestionModel();
          pos = QuestionModel.fromJson(obj);
          questionList.add(pos);
        }
      } else {}
    } catch (e) {
      print(e);
      showSnackMessage(
          context, 'Qualcosa è andato storto! \nRiprova più tardi');
    }
    setState(() {
      loader = false;
    });
  }

  getNextTopic() {
    if (activeIndex < widget.topicList.length - 1) {
      setState(() {
        activeIndex++;
        checkConnectivity(widget.topicList[activeIndex].id.toString());
        forwardArrow = true;
        backwardArrow = true;
        if (activeIndex == (widget.topicList.length - 1)) {
          forwardArrow = false;
        }
      });
    }
  }

  getPreviousTopic() {
    if (activeIndex > 0) {
      setState(() {
        activeIndex--;

        forwardArrow = true;
        backwardArrow = true;
        checkConnectivity(widget.topicList[activeIndex].id.toString());

        if (activeIndex == 0) {
          backwardArrow = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    activeIndex = widget.activeIndex;
    if (activeIndex == 0) {
      backwardArrow = true;
    } else if (activeIndex == widget.topicList.length - 1) {
      forwardArrow = true;
    }

    checkConnectivity(widget.topicList[widget.activeIndex].id.toString());
  }

  Future<void> showMessageDialogBox(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                decoration: BoxDecoration(
                  color: kLightBlue,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    dialogLoader
                        ? Icon(
                            Icons.close,
                            color: klightblue,
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close)),
                  ],
                ),
              ),
              actions: [
                dialogLoader
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                image: const AssetImage(
                                    'assets/images/warning.png')),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Risultato immediato',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 33, left: 30),
                                child: InkWell(
                                  onTap: () {
                                    Random random = Random();
                                    List<QuestionModel> randomList =
                                        <QuestionModel>[];
                                    List<QuestionModel> list =
                                        <QuestionModel>[];

                                    list.addAll(questionList);
                                    while (list.isNotEmpty) {
                                      int randomIndex =
                                          random.nextInt(list.length);

                                      setState(() {
                                        list[randomIndex].backGroundColor =
                                            kWhite;
                                        list[randomIndex].questionAttempted =
                                            false;
                                        list[randomIndex].status = 0;
                                        list[randomIndex].op_vera = false;
                                        list[randomIndex].op_falsa = false;
                                      });

                                      randomList.add(list[randomIndex]);
                                      list.removeAt(randomIndex);
                                    }
                                    print(randomList.length);
                                    if (randomList.isNotEmpty) {
                                      Navigator.pop(context);
                                      navPush(
                                          context,
                                          NoQuestionPaperScreen(
                                            time: time,
                                            questionList: randomList,
                                            type: '2',
                                            catId: widget
                                                .topicList[activeIndex].id
                                                .toString(),
                                          ));
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.160,
                                    height: MediaQuery.of(context).size.height *
                                        0.051,
                                    // margin: const EdgeInsets.only(left: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: kpink,
                                    ),
                                    child: const Center(child: Text('NO')),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 33, left: 30),
                                child: InkWell(
                                  onTap: () {
                                    Random random = Random();
                                    List<QuestionModel> randomList =
                                        <QuestionModel>[];
                                    List<QuestionModel> list =
                                        <QuestionModel>[];
                                    list.addAll(questionList);
                                    while (list.isNotEmpty) {
                                      int randomIndex =
                                          random.nextInt(list.length);

                                      setState(() {
                                        list[randomIndex].backGroundColor =
                                            kWhite;
                                        list[randomIndex].questionAttempted =
                                            false;
                                        list[randomIndex].status = 0;
                                        list[randomIndex].op_vera = false;
                                        list[randomIndex].op_falsa = false;
                                      });

                                      randomList.add(list[randomIndex]);
                                      list.removeAt(randomIndex);
                                    }

                                    Navigator.pop(context);
                                    navPush(
                                        context,
                                        YesQuestionPaperScreen(
                                          time: time,
                                          questionList: randomList,
                                          type: '2',
                                          catId: widget
                                              .topicList[activeIndex].id
                                              .toString(),
                                        ));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.160,
                                    height: MediaQuery.of(context).size.height *
                                        0.051,
                                    // margin: const EdgeInsets.only(left: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: lightgreys,
                                    ),
                                    child: const Center(child: Text('SI')),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                )
              ],
            );
          });
        });
  }

  onChange(val) {
    setState(() {
      showVocabulary = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBarIcon(context),
                appBarVocabularyWidget(
                    context, 'paid', showVocabulary, onChange),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: kblues,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.066,
                    width: MediaQuery.of(context).size.width,
                    color: kblues,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (!loader) {
                                    if (backwardArrow) {
                                      getPreviousTopic();
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ((backwardArrow && activeIndex != 0))
                                      ? !loader
                                          ? kWhite
                                          : kGrey
                                      : kGrey,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Center(
                                  child: Text(
                                widget.topicList[activeIndex].topicNo
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: kWhite),
                              )),
                              const SizedBox(
                                width: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  if (!loader) {
                                    if (forwardArrow) {
                                      getNextTopic();
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: (forwardArrow &&
                                          activeIndex !=
                                              widget.topicList.length - 1)
                                      ? !loader
                                          ? kWhite
                                          : kGrey
                                      : kGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!loader) {
                              if (questionList.isNotEmpty) {
                                showMessageDialogBox(context);
                              }
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.14,
                              margin: const EdgeInsets.only(right: 20),
                              height:
                                  MediaQuery.of(context).size.height * 0.044,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: kWhite,
                                  border: Border.all(
                                    width: 1,
                                    color: appbarcolor,
                                  )),
                              child: Center(
                                  child: Text(
                                'Quiz',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: questionList.isNotEmpty
                                        ? kBlack
                                        : kGrey),
                              ))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1), color: kWhite),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: (widget.topicList[activeIndex]
                                            .topicPicture ==
                                        null ||
                                    widget.topicList[activeIndex]
                                            .topicPicture ==
                                        'null')
                                ? const SizedBox()
                                : Container(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                    child: cacheImage(context,
                                        '${imageBaseURL}topics/${widget.topicList[activeIndex].topicPicture}'))),
                        const SizedBox(height: 10),
                        Text(
                          widget.topicList[activeIndex].question.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: kblues,
                      child: loader
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: questionList.length,
                              itemBuilder: (context, index) {
                                return topicQuizWidget(context, showVocabulary,
                                    index, questionList);
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
