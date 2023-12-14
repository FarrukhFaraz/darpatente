import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/QuestionModel.dart';
import '../../../Provider/timer_provider.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/url.dart';
import '../../../widgets/bottom_nav.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/paper_headers.dart';
import '../../../widgets/paper_scroll_list.dart';
import '../../../widgets/question.dart';
import '../../../widgets/vocabulary_clickable_text.dart';
import 'errori_frequenti_quiz_progress_page.dart';

class ErroriFrequentiNoQuestionPaperScreen extends StatefulWidget {
  const ErroriFrequentiNoQuestionPaperScreen({
    super.key,
    required this.questionList,
  });

  final List<QuestionModel> questionList;

  @override
  State<ErroriFrequentiNoQuestionPaperScreen> createState() =>
      _ErroriFrequentiNoQuestionPaperScreenState();
}

class _ErroriFrequentiNoQuestionPaperScreenState
    extends State<ErroriFrequentiNoQuestionPaperScreen> {
  List<QuestionModel> questionList = [];

  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);

  FlutterTts flutterTts = FlutterTts();

  bool loader = false;
  bool saveQuestionLoader = false;

  bool quizComplete = false;

  bool showVocabulary = false;

  int selectedIndex = 0;

  List<Question>? _questions;

  final itemHeight = 50.0;
  final itemCount = 100;
  final controller2 = ScrollController();
  int centerIndex = 0;

  var userType;

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    userType ??= '';
    setState(() {
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

  setTimer() {
    context.read<TimerProvider>().setSecRemaining(1);
    context.read<TimerProvider>().startTimerUp();
  }

  @override
  void initState() {
    super.initState();

    getUserStatus();

    questionList.clear();
    questionList.addAll(widget.questionList);

    loadQuestionNumber(widget.questionList.length);

    initializeTts();
    setTimer();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  saveAnswer(bool checkAnswer, String op) async {
    setState(() {
      questionList[selectedIndex].backGroundColor = klightblue.withOpacity(0.4);
      questionList[selectedIndex].questionAttempted = true;

      if (op == 'vera') {
        questionList[selectedIndex].op_vera = true;
        questionList[selectedIndex].op_falsa = false;
      } else if (op == 'falsa') {
        questionList[selectedIndex].op_vera = false;
        questionList[selectedIndex].op_falsa = true;
      }

      questionList[selectedIndex].status = 1;
      questionList[selectedIndex].myAttempted = op;
    });

    Timer(const Duration(milliseconds: 300), () {
      changeListIndex();
    });
  }

  changeListIndex() {
    if (selectedIndex < _questions!.length - 1) {
      selectedIndex++;
      _scrollToIndex();
    } else {}
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

  Future<void> playSound() async {
    String text = "${questionList[selectedIndex].name}";

    await flutterTts.speak(text);
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
                                    context.read<TimerProvider>().stopTimer();

                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      Navigator.pop(context);
                                      navReplace(
                                          context,
                                          ErroriFrequentiQuizProgressPage(
                                            list: questionList,
                                          ));
                                    });
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
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  showNoBottomNav(
                    context,
                    questionList[selectedIndex].answer.toString(),
                    questionList[selectedIndex].op_vera,
                    questionList[selectedIndex].op_falsa,
                    playSound,
                    saveAnswer,
                  ),
                  saveQuestionLoader
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration:
                              BoxDecoration(color: kWhite.withOpacity(0.8)),
                        )
                      : const SizedBox(),
                ],
              ),
        body: loader
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  showPaperHeaders(
                    context,
                    showVocabulary,
                    userType.toString(),
                    showDialogBox,
                    onChange,
                  ),
                  showPaperScrollList(
                    context,
                    selectedIndex,
                    kLightRed,
                    questionList,
                    _scrollController,
                    _questions,
                    onSelectedItemChanged,
                  ),
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
                          (questionList[selectedIndex].topic!.topicPicture ==
                                      null ||
                                  questionList[selectedIndex]
                                      .topic!
                                      .topicPicture
                                      .toString()
                                      .isEmpty ||
                                  questionList[selectedIndex]
                                          .topic!
                                          .topicPicture
                                          .toString()
                                          .toLowerCase() ==
                                      'null')
                              ? const SizedBox()
                              : const SizedBox(
                                  height: 40,
                                ),
                          (questionList[selectedIndex].topic!.topicPicture ==
                                      null ||
                                  questionList[selectedIndex]
                                      .topic!
                                      .topicPicture
                                      .toString()
                                      .isEmpty ||
                                  questionList[selectedIndex]
                                          .topic!
                                          .topicPicture
                                          .toString()
                                          .toLowerCase() ==
                                      'null')
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
                              alignment: (questionList[selectedIndex]
                                              .topic!
                                              .topicPicture ==
                                          null ||
                                      questionList[selectedIndex]
                                          .topic!
                                          .topicPicture
                                          .toString()
                                          .isEmpty ||
                                      questionList[selectedIndex]
                                              .topic!
                                              .topicPicture
                                              .toString()
                                              .toLowerCase() ==
                                          'null')
                                  ? Alignment.center
                                  : Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                  top: (questionList[selectedIndex]
                                                  .topic!
                                                  .topicPicture ==
                                              null ||
                                          questionList[selectedIndex]
                                              .topic!
                                              .topicPicture
                                              .toString()
                                              .isEmpty ||
                                          questionList[selectedIndex]
                                                  .topic!
                                                  .topicPicture
                                                  .toString()
                                                  .toLowerCase() ==
                                              'null')
                                      ? 0
                                      : 40),
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
