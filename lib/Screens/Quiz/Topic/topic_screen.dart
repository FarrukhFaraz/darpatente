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
import '../../../widgets/app_bar_image.dart';
import '../../../widgets/topic_screen_widget.dart';
import '../QuestionPaper/no_question_paper.dart';
import '../QuestionPaper/yes_question_paper.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key, required this.id, required this.name});

  final String id;
  final String name;

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<TopicsModel> topicList = <TopicsModel>[];
  List<QuestionModel> questionList = <QuestionModel>[];

  bool checkConnection = false;
  bool dialogLoader = false;
  bool loader = false;
  var userType;

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      getTopicList();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  getTopicList() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainCatId = prefs.getString('MainCategoryId');

    Map body = {'id': widget.id.toString(), 'cat_id': mainCatId.toString()};

    try {
      http.Response response =
          await http.post(Uri.parse(getTopicsURL), body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          TopicsModel pos = TopicsModel();
          pos = TopicsModel.fromJson(obj);
          topicList.add(pos);
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

  @override
  void initState() {
    super.initState();
    getUserStatus();
    checkConnectivity();
  }

  Future<void> showMessageDialogBox(BuildContext context, String id) async {
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
                                  onTap: () async {
                                    if (await connection()) {
                                      setState(() {
                                        dialogLoader = true;
                                        questionList.clear();
                                      });
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var user_id = prefs.getString('id');
                                      var bookId = prefs.getString('MainCategoryId');

                                      Map body = {
                                        'cat_id': id.toString(),
                                        'user_id': user_id.toString(),
                                        'chapter_id':widget.id.toString(),
                                        'book_id':bookId.toString()
                                      };

                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(questionByTopicURL
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
                                          Random random = Random();
                                          List<QuestionModel> randomList =
                                              <QuestionModel>[];

                                          while (questionList.isNotEmpty) {
                                            int randomIndex = random
                                                .nextInt(questionList.length);

                                            setState(() {
                                              questionList[randomIndex]
                                                  .backGroundColor = kWhite;
                                              questionList[randomIndex]
                                                  .questionAttempted = false;
                                              questionList[randomIndex].status =
                                                  0;
                                              questionList[randomIndex]
                                                  .op_vera = false;
                                              questionList[randomIndex]
                                                  .op_falsa = false;
                                            });

                                            randomList
                                                .add(questionList[randomIndex]);
                                            questionList.removeAt(randomIndex);
                                          }

                                          if (randomList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                NoQuestionPaperScreen(
                                                  time: time,
                                                  questionList: randomList,
                                                  type: '2',
                                                  catId: id.toString(),
                                                ));
                                          }
                                        } else {}
                                      } catch (e) {
                                        print(e);
                                        showSnackMessage(context,
                                            'Qualcosa è andato storto!');
                                      }
                                      setState(() {
                                        dialogLoader = false;
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
                                        dialogLoader = true;
                                        questionList.clear();
                                      });
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var user_id = prefs.getString('id');
                                      var bookId = prefs.getString('MainCategoryId');

                                      Map body = {
                                        'cat_id': id.toString(),
                                        'user_id': user_id.toString(),
                                        'chapter_id':widget.id.toString(),
                                        'book_id':bookId.toString()
                                      };

                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(questionByTopicURL
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

                                          Random random = Random();
                                          List<QuestionModel> randomList =
                                              <QuestionModel>[];

                                          while (questionList.isNotEmpty) {
                                            int randomIndex = random
                                                .nextInt(questionList.length);

                                            setState(() {
                                              questionList[randomIndex]
                                                  .backGroundColor = kWhite;
                                              questionList[randomIndex]
                                                  .questionAttempted = false;
                                              questionList[randomIndex].status =
                                                  0;
                                              questionList[randomIndex]
                                                  .op_vera = false;
                                              questionList[randomIndex]
                                                  .op_falsa = false;
                                            });

                                            randomList
                                                .add(questionList[randomIndex]);
                                            questionList.removeAt(randomIndex);
                                          }

                                          if (randomList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                YesQuestionPaperScreen(
                                                  time: time,
                                                  questionList: randomList,
                                                  type: '2',
                                                  catId: id.toString(),
                                                ));
                                          }
                                        } else {}
                                      } catch (e) {
                                        print(e);
                                        showSnackMessage(context,
                                            'Qualcosa è andato storto!');
                                      }
                                      setState(() {
                                        dialogLoader = false;
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.058,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appBarIcon(context),
                  const Expanded(child: Text('')),
                  appBarImage(context),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: kblues,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          widget.name.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: appbarcolor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: loader
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 6),
                              shrinkWrap: true,
                              itemCount: topicList.length,
                              itemBuilder: (context, index) {
                                return topicScreenWidget(
                                    context,
                                    widget.id.toString(),
                                    userType,
                                    index,
                                    topicList,
                                    showMessageDialogBox);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
