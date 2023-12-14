import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/QuestionModel.dart';
import '../../../Models/getUserCurrentQuiz.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/Network/check_connectivity.dart';
import '../../../Utils/Network/offline_checker.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/messages.dart';
import '../../../Utils/url.dart';
import '../../../widgets/app_bar_image.dart';
import '../../../widgets/parogress_page_widget.dart';
import 'no_question_paper.dart';
import 'yes_question_paper.dart';

class CurrentQuizProgressPage extends StatefulWidget {
  const CurrentQuizProgressPage({
    super.key,
    required this.quizId,
    required this.length,
    required this.type,
    required this.catId,
  });

  final String quizId;
  final int length;
  final String type;
  final String catId;

  @override
  State<CurrentQuizProgressPage> createState() =>
      _CurrentQuizProgressPageState();
}

class _CurrentQuizProgressPageState extends State<CurrentQuizProgressPage> {
  bool loader = false;
  bool startQuizLoader = false;

  List<UserCurrentQuiz> list = [];
  List<UserCurrentQuiz> trueList = [];
  List<UserCurrentQuiz> falseList = [];

  List<QuestionModel> questionList = <QuestionModel>[];

  var radius = 20.0;
  bool checkConnection = false;
  bool pass = false;

  String? userType;

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    setState(() {});
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      apiCallFunction();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  apiCallFunction() async {
    setState(() {
      loader = true;
      trueList.clear();
      falseList.clear();
      list.clear();
    });

    Map body = {
      'quiz_id': widget.quizId.toString(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(userCurrentQuizURL), body: body);
      if (kDebugMode) {
        print(response.body);
      }

      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        if (kDebugMode) {
          print('status == 200');
        }
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> pos = jsonData['data'][i];
          UserCurrentQuiz model = UserCurrentQuiz.fromJson(pos);
          if (model.attempted.toString() == model.answer.toString()) {
            trueList.add(model);
          } else {
            falseList.add(model);
          }
          list.add(model);
        }
        if (kDebugMode) {
          print('True list length: ${trueList.length}');
        }
        if (kDebugMode) {
          print('False list length: ${falseList.length}');
        }
        if (kDebugMode) {
          print('total list length: ${list.length}');
        }

        checkResult();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong!')));
    }
    setState(() {
      loader = false;
    });
  }

  checkResult() {
    if (kDebugMode) {
      print('total question :${widget.length}');
    }

    if (trueList.length >= (widget.length * 90 / 100)) {
      if (kDebugMode) {
        print('pass');
      }
      setState(() {
        pass = true;
      });
    } else {
      if (kDebugMode) {
        print('false');
      }
      setState(() {
        pass = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    getUserStatus();
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
              actions: [
                startQuizLoader
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close)),
                          ),
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
                                        startQuizLoader = true;
                                        questionList.clear();
                                      });

                                      String url = '';
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var userId = prefs.getString('id');
                                      var bookId =
                                          prefs.getString('MainCategoryId');

                                      Map body = {
                                        'user_id': userId.toString()
                                      };

                                      if (widget.type == '0') {
                                        if (kDebugMode) {
                                          print(' quiz by book');
                                        }
                                        url = questionByBookURL;
                                        var questionType =
                                            prefs.getInt('question_type');
                                        if (questionType == null) {
                                          prefs.setInt('question_type', 1);
                                          questionType = 1;
                                        }
                                        body.addAll({
                                          'cat_id': widget.catId.toString(),
                                          'question_type':
                                              questionType.toString(),
                                        });
                                        questionType++;
                                        if (questionType > 4) {
                                          questionType = 1;
                                        }
                                        prefs.setInt(
                                            'question_type', questionType);
                                      } else if (widget.type == '1') {
                                        if (kDebugMode) {
                                          print('quiz by chapter');
                                        }
                                        url = questionByChapterURL;
                                        body.addAll({
                                          'book_id': bookId.toString(),
                                          'chapter_id[]':
                                              widget.catId.toString(),
                                        });
                                      } else if (widget.type == '2') {
                                        if (kDebugMode) {
                                          print('quiz by topic');
                                        }
                                        url = questionByTopicURL;
                                        body.addAll({
                                          'cat_id': widget.catId.toString(),
                                        });
                                      }

                                      if (kDebugMode) {
                                        print(body);
                                        print(url);
                                      }


                                      try {
                                        http.Response response = await http
                                            .post(Uri.parse(url.toString()),
                                                body: body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        if (kDebugMode) {
                                          print(jsonData);
                                        }

                                        if (jsonData['status'] == 200) {
                                          var t = jsonData['Books']['time'];
                                          int time = 0;
                                          if (t != null ||
                                              t.toString().isNotEmpty) {
                                            time = int.parse(t.toString());
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
                                          if (questionList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navReplace(
                                                context,
                                                NoQuestionPaperScreen(
                                                  questionList: questionList,
                                                  time: time,
                                                  type: widget.type,
                                                  catId:
                                                      widget.catId.toString(),
                                                ));
                                          }
                                        } else {}
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                        showSnackMessage(context,
                                            'Qualcosa è andato storto!');
                                      }
                                      setState(() {
                                        startQuizLoader = false;
                                      });
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
                                        startQuizLoader = true;
                                        questionList.clear();
                                      });

                                      String url = '';
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var userId = prefs.getString('id');
                                      var bookId =
                                          prefs.getString('MainCategoryId');

                                      Map body = {
                                        'user_id': userId.toString()
                                      };

                                      if (widget.type == '0') {
                                        if (kDebugMode) {
                                          print(' quiz by book');
                                        }
                                        url = questionByBookURL;
                                        var questionType =
                                            prefs.getInt('question_type');
                                        if (questionType == null) {
                                          prefs.setInt('question_type', 1);
                                          questionType = 1;
                                        }
                                        body.addAll({
                                          'cat_id': widget.catId.toString(),
                                          'question_type':
                                              questionType.toString(),
                                        });
                                        questionType++;
                                        if (questionType > 4) {
                                          questionType = 1;
                                        }
                                        prefs.setInt(
                                            'question_type', questionType);
                                      } else if (widget.type == '1') {
                                        if (kDebugMode) {
                                          print('quiz by chapter');
                                        }
                                        url = questionByChapterURL;
                                        body.addAll({
                                          'book_id': bookId.toString(),
                                          'chapter_id[]':
                                              widget.catId.toString(),
                                        });
                                      } else if (widget.type == '2') {
                                        if (kDebugMode) {
                                          print('quiz by topic');
                                        }
                                        url = questionByTopicURL;
                                        body.addAll({
                                          'cat_id': widget.catId.toString(),
                                        });
                                      }

                                      try {
                                        http.Response response = await http
                                            .post(Uri.parse(url), body: body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        if (kDebugMode) {
                                          print(jsonData);
                                        }

                                        if (jsonData['status'] == 200) {
                                          var t = jsonData['Books']['time'];
                                          int time = 0;
                                          if (t != null ||
                                              t.toString().isNotEmpty) {
                                            time = int.parse(t.toString());
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
                                          if (questionList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navReplace(
                                                context,
                                                YesQuestionPaperScreen(
                                                  questionList: questionList,
                                                  time: time,
                                                  type: widget.type.toString(),
                                                  catId:
                                                      widget.catId.toString(),
                                                ));
                                          }
                                        } else {}
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                        showSnackMessage(context,
                                            'Qualcosa è andato storto!');
                                      }
                                      setState(() {
                                        startQuizLoader = false;
                                      });
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
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.058,
                  child: Row(
                    children: [
                      userType == 'paid'
                          ? (widget.type == '1' && widget.catId == '-1')
                              ? const SizedBox()
                              : widget.type == '2'
                                  ? const SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        if (widget.type == '1') {
                                          showMessageDialogBox(context);
                                        } else {
                                          showMessageDialogBox(context);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Image(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.046,
                                            image: const AssetImage(
                                                'assets/images/load.png')),
                                      ),
                                    )
                          : const SizedBox(),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(child: Text('')),
                      appBarImage(context),
                    ],
                  ),
                ),
                Container(
                  color: kblues,
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.026,
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: const EdgeInsets.only(top: 26),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: (list.isNotEmpty)
                                ? pass
                                    ? kgreen
                                    : kRed
                                : null,
                          ),
                          child: Center(
                              child: Text(
                            (list.isNotEmpty)
                                ? pass
                                    ? 'IDONEO'
                                    : 'Non IDONEO'
                                : '',
                            style: TextStyle(color: kWhite, fontSize: 16),
                          ))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Corrette',
                                style: TextStyle(
                                    color: appbarcolor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(loader ? '' : '${trueList.length}',
                                  style: TextStyle(
                                      color: appbarcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Erreto',
                                style: TextStyle(
                                    color: appbarcolor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(loader ? '' : '${falseList.length}',
                                  style: TextStyle(
                                      color: appbarcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Non risposte',
                                style: TextStyle(
                                    color: appbarcolor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  loader
                                      ? ''
                                      : '${(widget.length) - (falseList.length + trueList.length)}',
                                  style: TextStyle(
                                      color: appbarcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: loader
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          color: kpink,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 10),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              bool val;
                              if (list[index].questionPicture == null ||
                                  list[index].questionPicture.toString() ==
                                      "null" ||
                                  list[index].questionPicture.toString() ==
                                      "") {
                                val = true;
                              } else {
                                val = false;
                              }
                              // print(val);

                              bool ans;
                              if (list[index].answer.toString() ==
                                  list[index].attempted.toString()) {
                                ans = true;
                              } else {
                                ans = false;
                              }

                              // print('ans::::$ans');

                              return progressPageWidget(context, index, val,
                                  ans, radius, userType!, list);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ));
  }
}
