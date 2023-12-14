import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/QuestionModel.dart';
import '../../Models/start_quiz_model.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/app_bar_title.dart';
import '../../widgets/start_quiz_widget.dart';
import 'QuestionPaper/no_question_paper.dart';
import 'QuestionPaper/yes_question_paper.dart';
import 'Quiz_by_Chapter/chapter_list.dart';
import 'Topic/chapter_topic_screen.dart';

class StartQuizScreen extends StatefulWidget {
  const StartQuizScreen({super.key});

  @override
  State<StartQuizScreen> createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {
  List<StartQuizClass> list = <StartQuizClass>[];

  bool dialogLoader = false;
  List<QuestionModel> questionList = <QuestionModel>[];
  bool checkConnection = false;

  Future<void> showEmail(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
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
              titlePadding: const EdgeInsets.all(0),
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
                                  onTap: () async {
                                    if (await connection()) {
                                      setState(() {
                                        dialogLoader = true;
                                        questionList.clear();
                                      });

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var userId = prefs.getString('id');
                                      var catId =
                                          prefs.getString('MainCategoryId');
                                      var questionType =
                                          prefs.getInt('question_type');
                                      if (questionType == null) {
                                        prefs.setInt('question_type', 1);
                                        questionType = 1;
                                      }

                                      Map body = {
                                        'cat_id': catId.toString(),
                                        'user_id': userId.toString(),
                                        'question_type':
                                            questionType.toString(),
                                      };

                                      print(body);

                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(questionByBookURL
                                                    .toString()),
                                                body: body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        print(jsonData);

                                        if (jsonData['status'] == 200) {
                                          var t = jsonData['Books']['time'];
                                          int time = 0;
                                          if (t.toString().isNotEmpty ||
                                              t != null) {
                                            time = int.parse(t.toString());
                                          } else {
                                            time = 30;
                                          }
                                          for (int i = 0;
                                              i < jsonData['data'].length;
                                              i++) {
                                            Map<String, dynamic> obj =
                                                jsonData['data'][i];
                                            QuestionModel pos = QuestionModel();
                                            pos = QuestionModel.fromJson(obj);
                                            questionList.add(pos);
                                          }
                                          questionType++;
                                          if (questionType > 4) {
                                            questionType = 1;
                                          }
                                          prefs.setInt('question_type', questionType);
                                          if (questionList.isNotEmpty) {
                                            setState(() {
                                              dialogLoader = false;
                                            });
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                NoQuestionPaperScreen(
                                                  time: time,
                                                  questionList: questionList,
                                                  type: '0',
                                                  catId: catId.toString(),
                                                ));
                                          }else{
                                            setState(() {
                                              dialogLoader = false;
                                            });
                                            showSnackMessage(context, 'No Question found');
                                            Navigator.pop(context);
                                          }
                                        } else {}
                                      } catch (e) {
                                        print(e);
                                        setState(() {
                                          checkConnection = true;
                                        });
                                        showSnackMessage(context,
                                            'Qualcosa è andato storto!');
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      setState(() {
                                        checkConnection = true;
                                      });
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
                                  onTap: () async {
                                    if (await connection()) {
                                      setState(() {
                                        dialogLoader = true;
                                        questionList.clear();
                                      });
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      var userId = prefs.getString('id');
                                      var catId =
                                      prefs.getString('MainCategoryId');
                                      var questionType =
                                      prefs.getInt('question_type');
                                      if (questionType == null) {
                                        prefs.setInt('question_type', 1);
                                        questionType = 1;
                                      }

                                      Map body = {
                                        'cat_id': catId.toString(),
                                        'user_id': userId.toString(),
                                        'question_type':
                                        questionType.toString(),
                                      };

                                      print(body);


                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(questionByBookURL
                                                    .toString()),
                                                body: body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        print(jsonData);

                                        if (jsonData['status'] == 200) {
                                          var t = jsonData['Books']['time'];
                                          int time = 0;
                                          if (t != null ||
                                              t.toString().isNotEmpty) {
                                            time = int.parse(t.toString());
                                          } else {
                                            time = 30;
                                          }
                                          for (int i = 0;
                                              i < jsonData['data'].length;
                                              i++) {
                                            Map<String, dynamic> obj =
                                                jsonData['data'][i];
                                            QuestionModel pos = QuestionModel();
                                            pos = QuestionModel.fromJson(obj);
                                            questionList.add(pos);
                                          }
                                          questionType++;
                                          if (questionType > 4) {
                                            questionType = 1;
                                          }
                                          prefs.setInt('question_type', questionType);
                                          if (questionList.isNotEmpty) {
                                            setState(() {
                                              dialogLoader = false;
                                            });
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                YesQuestionPaperScreen(
                                                  questionList: questionList,
                                                  time: time,
                                                  type: '0',
                                                  catId: catId.toString(),
                                                ));
                                          }else{
                                            setState(() {
                                              dialogLoader = false;
                                            });
                                            showSnackMessage(context, 'No Question found');
                                            Navigator.pop(context);
                                          }
                                        } else {}
                                      } catch (e) {
                                        print(e);
                                        setState(() {
                                          checkConnection = true;
                                        });
                                        showSnackMessage(context,
                                            'Qualcosa è andato storto!');
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      setState(() {
                                        checkConnection = true;
                                      });
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

  @override
  void initState() {
    super.initState();
    list = getsList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.058,
                child: Row(
                  children: [
                    appBarIcon(context),
                    appBarTitle('Dar Patente'),
                    appBarImage(context),
                  ],
                ),
              ),
              Container(
                color: kblues,
                height: MediaQuery.of(context).size.height * 0.880,
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            // navPush(context, const TotalBooksScreen());
                            showEmail(context);
                          } else if (index == 1) {
                            navPush(context, const ChapterListScreen());
                          } else if (index == 2) {
                            navPush(context, const ChapterForTopicScreen());
                          }
                        },
                        child: startQuizWidget(context, list[index]),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
