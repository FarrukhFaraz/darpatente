import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/QuestionModel.dart';
import '../../../Provider/timer_provider.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/messages.dart';
import '../../../Utils/url.dart';
import '../../../widgets/bottom_nav.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/paper_headers.dart';
import '../../../widgets/paper_scroll_list.dart';
import '../../../widgets/question.dart';
import '../../../widgets/vocabulary_clickable_text.dart';
import 'quiz_progress_page.dart';

class YesQuestionPaperScreen extends StatefulWidget {
  const YesQuestionPaperScreen({
    super.key,
    required this.questionList,
    required this.type,
    required this.catId,
    required this.time,
  });

  final int time;
  final String type;
  final String catId;
  final List<QuestionModel> questionList;

  @override
  State<YesQuestionPaperScreen> createState() => _YesQuestionPaperScreenState();
}

class _YesQuestionPaperScreenState extends State<YesQuestionPaperScreen> {
  List<QuestionModel> questionList = [];
  Map body = {};

  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);

  FlutterTts flutterTts = FlutterTts();

  bool ttsLoader = false;
  bool ttsPlayer = false;
  bool ttsPlaying = false;

  bool showVocabulary = false;

  bool loader = false;
  bool saveQuestionLoader = false;

  bool quizComplete = false;

  int selectedIndex = 0;

  List<Question>? _questions;

  int count = 0;


  String? userType;

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    userType = prefs.getString('userType');
    userType ??= '';
    var data = {
      'user_id': id.toString(),
    };
    setState(() {
      body.addAll(data);
    });
  }

  loadQuestionNumber(int number) {
    _questions = List.generate(
      number,
      (i) => Question("Question ${i + 1}"),
    );
  }

  Future<void> initializeTts() async {
    await flutterTts.setLanguage('it-IT');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts
        .setVoice({'name': 'it-it-x-kda#male_3-local', 'locale': 'it-IT'});
  }

  @override
  void initState() {
    super.initState();
    getUserStatus();

    questionList.clear();
    questionList.addAll(widget.questionList);

    loadQuestionNumber(widget.questionList.length);

    initializeTts();

    context.read<TimerProvider>().setInitialTimerInMinute(widget.time);
    context.read<TimerProvider>().startTimerDown();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> playSound() async {
    String text = "${questionList[selectedIndex].name}";
    await flutterTts.speak(text);
  }

  saveAnswer(bool? checkAnswer, String op) async {
    setState(() {
      if (checkAnswer!) {
        questionList[selectedIndex].backGroundColor = kGreen;
      } else {
        questionList[selectedIndex].backGroundColor = kRed;
      }

      questionList[selectedIndex].questionAttempted = true;
      count++;
      print(count);
      questionList[selectedIndex].status = 1;

      Map data = {
        'ques_id[$selectedIndex]': questionList[selectedIndex].id.toString(),
        'name[$selectedIndex]': questionList[selectedIndex].name.toString(),
        'question_no[$selectedIndex]':
            questionList[selectedIndex].questionNo.toString(),
        'extra_picture[$selectedIndex]':
            questionList[selectedIndex].questionPicture.toString(),
        'question_picture[$selectedIndex]':
            questionList[selectedIndex].topic!.topicPicture.toString(),
        'voice[$selectedIndex]': questionList[selectedIndex].voice.toString(),
        'answer[$selectedIndex]': questionList[selectedIndex].answer.toString(),
        'attempted[$selectedIndex]': op.toString(),
        'status[$selectedIndex]': questionList[selectedIndex].status.toString(),
        'cat_id[$selectedIndex]': widget.type == '1'
            ? widget.catId == '-1'
                ? questionList[selectedIndex].chapterId.toString()
                : widget.catId.toString()
            : widget.catId.toString(),
        'type[$selectedIndex]': widget.type.toString(),
        'total_question[$selectedIndex]': questionList.length.toString(),
      };

      body.addAll(data);
    });

    Timer(const Duration(milliseconds: 300), () {
      changeListIndex();
    });
  }

  Future<void> showDialogBox(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(26))),
              actions: [
                saveQuestionLoader
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
                          // Padding(
                          //  padding: const EdgeInsets.only(left: 16, right: 14),
                          // child:
                          const Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              'SEI SICURO DI VOLER CHIUDERE',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          //  ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 33, left: 30),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.160,
                                    height: MediaQuery.of(context).size.height *
                                        0.051,
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
                                  onTap: () async {
                                    if (questionList.length == count) {
                                      setState(() {
                                        saveQuestionLoader = true;
                                      });
                                      context.read<TimerProvider>().stopTimer();
                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(
                                                    saveQuestionResultURL),
                                                body: body);

                                        Map jsonData =
                                            jsonDecode(response.body);
                                        if (kDebugMode) {
                                          print(jsonData);
                                        }
                                        if (jsonData['status'] == 200) {
                                          Navigator.pop(context);
                                          var quizId = jsonData['quiz_id'];
                                          setState(() {
                                            saveQuestionLoader = false;
                                          });
                                          showSnackMessage(context,
                                              jsonData['message'].toString());

                                          navReplace(
                                              context,
                                              CurrentQuizProgressPage(
                                                quizId: quizId.toString(),
                                                length: questionList.length,
                                                catId: widget.catId,
                                                type: widget.type,
                                              ));
                                        }
                                      } catch (e) {
                                        setState(() {
                                          saveQuestionLoader = false;
                                        });
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      showSnackErrorMessage(context,
                                          'First attempt all Questions', 5);
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

  changeListIndex() {
    if (selectedIndex < _questions!.length - 1) {
      selectedIndex++;
      _scrollToIndex();
    } else {
      setState(() {
        quizComplete = false;
      });
    }
  }

  _scrollToIndex() {
    flutterTts.stop();
    _scrollController.animateToItem(
      _scrollController.selectedItem + 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceInOut,
    );
    setState(() {
      selectedIndex = _scrollController.selectedItem;
    });
  }

  void onChange(val) {
    setState(() {
      showVocabulary = val;
    });
  }

  void onSelectedItemChanged(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('${questionList[selectedIndex].name}');
    return WillPopScope(
      onWillPop: () async {
        context.read<TimerProvider>().stopTimer();
        Timer(const Duration(milliseconds: 100), () {
          Navigator.pop(context);
        });

        return false;
      },
      child: SafeArea(
          child: Scaffold(
        bottomNavigationBar: loader
            ? const SizedBox()
            : showYesBottomNav(
                context,
                questionList[selectedIndex].answer.toString(),
                questionList[selectedIndex].questionAttempted,
                quizComplete,
                playSound,
                saveAnswer,
              ),
        body: loader
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  showPaperHeaders(context, showVocabulary, userType.toString(),
                      showDialogBox, onChange),
                  showPaperScrollList(
                      context,
                      selectedIndex,
                      kBlack,
                      questionList,
                      _scrollController,
                      _questions,
                      onSelectedItemChanged),
                  Expanded(
                    child: GestureDetector(
                      onHorizontalDragUpdate: (detail) {
                        if (detail.delta.dx < -0.3) {
                          ////// it will increase index
                          changeListIndex();
                        } else if (detail.delta.dx > 0.3) {
                          ///////// it will decrease index

                          if (selectedIndex > 0) {
                            flutterTts.stop();
                            setState(() {
                              selectedIndex--;

                              _scrollController.animateToItem(
                                _scrollController.selectedItem - 1,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceInOut,
                              );
                              selectedIndex = _scrollController.selectedItem;
                            });
                          }
                        }
                      },
                      child: Column(
                        children: [
                          questionList[selectedIndex].topic!.topicPicture ==
                                  null
                              ? const SizedBox()
                              : const SizedBox(height: 40),
                          questionList[selectedIndex].topic!.topicPicture ==
                                  null
                              ? const SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: cacheImage(context,
                                      "${imageBaseURL}topics/${questionList[selectedIndex].topic!.topicPicture}"),
                                ),
                          Expanded(
                            child: Container(
                              alignment: questionList[selectedIndex]
                                          .topic!
                                          .topicPicture ==
                                      null
                                  ? Alignment.center
                                  : Alignment.topLeft,
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 10,
                                top: questionList[selectedIndex]
                                            .topic!
                                            .topicPicture ==
                                        null
                                    ? 0
                                    : 40,
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: showVocabulary
                                  ? VocabularyClickableText(
                                      text:
                                          "${questionList[selectedIndex].name}",
                                    )
                                  : Text(
                                      "${questionList[selectedIndex].name}",
                                      // textAlign: TextAlign.center,
                                      maxLines: 50,
                                      // widget.questionList[selectedIndex].name.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: kBlack,
                                          height: 1.4),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      )),
    );
  }
}
