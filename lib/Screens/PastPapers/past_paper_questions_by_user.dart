import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/past_questions_by_user_model.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_vocabulary_widget.dart';
import '../../widgets/past_paper_questions_widget.dart';
import 'PastPaperScreen/past_no_question_paper.dart';
import 'PastPaperScreen/past_yes_question_paper.dart';

class QuizByUsersScreen extends StatefulWidget {
  const QuizByUsersScreen({
    super.key,
    required this.time,
    required this.userId,
  });

  final String userId;
  final int time;

  @override
  State<QuizByUsersScreen> createState() => _QuizByUsersScreenState();
}

class _QuizByUsersScreenState extends State<QuizByUsersScreen> {
  bool checkConnection = false;

  List<PastPaperByQuestionModel> list = <PastPaperByQuestionModel>[];
  List<PastPaperByQuestionModel> trueList = <PastPaperByQuestionModel>[];
  List<PastPaperByQuestionModel> falseList = <PastPaperByQuestionModel>[];

  bool pass = false;
  var radius = 20.0;
  bool loader = false;

  bool showVocabulary = false;

  String userType = '';

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType')!;
    setState(() {});
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      getList();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  getList() async {
    setState(() {
      loader = true;
    });

    Map body = {
      'user_id': widget.userId.toString(),
    };

    try {
      http.Response response = await http
          .post(Uri.parse(getPastPaperQuestionsByUserURL), body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          PastPaperByQuestionModel pos = PastPaperByQuestionModel();
          pos = PastPaperByQuestionModel.fromJson(obj);
          if (pos.attempted == pos.answer) {
            trueList.add(pos);
          } else {
            falseList.add(pos);
          }
          list.add(pos);
        }
        checkResult(list.length);
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

  checkResult(int length) {
    print('total question :$length}');

    if (trueList.length >= (length * 90 / 100)) {
      print('pass');
      setState(() {
        pass = true;
      });
    } else {
      print('false');
      setState(() {
        pass = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserStatus();
    checkConnectivity();
  }

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
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                        )),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.all(0),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image(
                          height: MediaQuery.of(context).size.height * 0.07,
                          image: const AssetImage('assets/images/warning.png')),
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
                          padding: const EdgeInsets.only(top: 33, left: 30),
                          child: InkWell(
                            onTap: () {
                              print("list length${list.length}");
                              Navigator.pop(context);
                              navReplace(
                                  context,
                                  PastPaperNoQuestionPaperScreen(
                                    list: list,
                                    time: widget.time,
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.160,
                              height:
                                  MediaQuery.of(context).size.height * 0.051,
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
                          padding: const EdgeInsets.only(top: 33, left: 30),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navReplace(
                                  context,
                                  PastPaperYesQuestionPaperScreen(
                                    list: list,
                                    time: widget.time,
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.160,
                              height:
                                  MediaQuery.of(context).size.height * 0.051,
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

  onChanged(val) {
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
          Container(
            padding: const EdgeInsets.only(right: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10),
                appBarIcon(context),
                const Expanded(child: Text('')),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.044,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: kLightBlue,
                        border: Border.all(width: 1, color: appbarcolor)),
                    // margin: EdgeInsets.only(left: 130),
                    child: InkWell(
                      onTap: () {
                        showEmail(context);
                      },
                      child: Center(
                          child: Text(
                        'Prova',
                        style: TextStyle(fontSize: 20, color: kWhite),
                      )),
                    )),
                const Expanded(child: Text('')),
                appBarVocabularyWidget(
                    context, userType, showVocabulary, onChanged),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Container(
            color: kblues,
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    margin: const EdgeInsets.only(top: 26),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: pass ? kgreen : kRed),
                    padding: const EdgeInsets.symmetric(vertical: 1),
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
                          'Domanda totale',
                          style: TextStyle(
                              color: appbarcolor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(loader ? '' : '${list.length}',
                            style: TextStyle(
                                color: kBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 20))
                      ],
                    ),
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
                          'Erreta',
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
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: kpink,
              child: loader
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 8),
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        bool ans;
                        if (list[index].answer.toString() ==
                            list[index].attempted.toString()) {
                          ans = true;
                        } else {
                          ans = false;
                        }

                        return pastPaperQuestionWidget(context, index, ans,
                            radius, showVocabulary, list[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    ));
  }
}
