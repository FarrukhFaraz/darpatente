import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Utils/colors.dart';
import '../../../Models/repaso_errori_question_model.dart';
import '../../../Provider/timer_provider.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/url.dart';
import '../../../widgets/bottom_nav.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/paper_headers.dart';
import '../../../widgets/paper_scroll_list.dart';
import '../../../widgets/question.dart';
import '../../../widgets/vocabulary_clickable_text.dart';
import 'repaso_errori_progress_page.dart';

class RepasoErroriYesQuestionPaperScreen extends StatefulWidget {
  const RepasoErroriYesQuestionPaperScreen({
    super.key,
    required this.list,
  });

  final List<RepasoErroriQuestionModel> list;

  @override
  State<RepasoErroriYesQuestionPaperScreen> createState() =>
      _RepasoErroriYesQuestionPaperScreenState();
}

class _RepasoErroriYesQuestionPaperScreenState
    extends State<RepasoErroriYesQuestionPaperScreen> {
  var quizId;

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
    var t = context.read<TimerProvider>();
    t.setSecRemaining(1);
    t.startTimerUp();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getUserStatus();
    loadQuestionNumber(widget.list.length);

    initializeTts();
    setTimer();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  saveAnswer(bool? checkAnswer, String answer) async {
    setState(() {
      widget.list[selectedIndex].myAttempted = answer;
      widget.list[selectedIndex].questionAttempted = true;
      if (checkAnswer!) {
        widget.list[selectedIndex].backGroundColor = kGreen;
      } else {
        widget.list[selectedIndex].backGroundColor = kRed;
      }
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
    print(selectedIndex);
  }

  Future<void> playSound() async {
    String text = "${widget.list[selectedIndex].name}";
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
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
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
                                    setState(() {
                                      saveQuestionLoader = true;
                                    });
                                    context.read<TimerProvider>().stopTimer();
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      Navigator.pop(context);
                                      navReplace(
                                          context,
                                          RepasoErroriProgressPage(
                                            list: widget.list,
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

  onSelectedItemChanged(index) {
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
          print('ok');
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
                widget.list[selectedIndex].answer.toString(),
                widget.list[selectedIndex].questionAttempted,
                quizComplete,
                playSound,
                saveAnswer),
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
                      widget.list,
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
                          (widget.list[selectedIndex].questionPicture == null ||
                                  widget.list[selectedIndex].questionPicture
                                      .toString()
                                      .isEmpty ||
                                  widget.list[selectedIndex].questionPicture
                                          .toString() ==
                                      'null')
                              ? const SizedBox()
                              : const SizedBox(height: 40),
                          (widget.list[selectedIndex].questionPicture == null ||
                                  widget.list[selectedIndex].questionPicture
                                      .toString()
                                      .isEmpty ||
                                  widget.list[selectedIndex].questionPicture
                                          .toString() ==
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
                                      "${imageBaseURL}topics/${widget.list[selectedIndex].questionPicture}"),
                                ),
                          Expanded(
                            child: Container(
                              alignment: (widget.list[selectedIndex]
                                              .questionPicture ==
                                          null ||
                                      widget.list[selectedIndex].questionPicture
                                          .toString()
                                          .isEmpty ||
                                      widget.list[selectedIndex].questionPicture
                                              .toString() ==
                                          'null')
                                  ? Alignment.center
                                  : Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                  top: widget.list[selectedIndex]
                                              .questionPicture ==
                                          null
                                      ? 0
                                      : 40),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: showVocabulary
                                  ? VocabularyClickableText(
                                      text:
                                          "${widget.list[selectedIndex].name}",
                                    )
                                  : Text(
                                      "${widget.list[selectedIndex].name}",
                                      maxLines: 50,
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
                  )
                ],
              ),
      )),
    );
  }
}
