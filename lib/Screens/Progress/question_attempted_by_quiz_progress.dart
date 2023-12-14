import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Utils/colors.dart';
import '../../../Utils/url.dart';
import '../../Models/Progress/question_by_quiz_attempted.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/parogress_page_widget.dart';

class QuestionAttemptedByQuizProgressScreen extends StatefulWidget {
  const QuestionAttemptedByQuizProgressScreen({
    super.key,
    required this.quizId,
    required this.type,
  });

  final String quizId;
  final String type;

  @override
  State<QuestionAttemptedByQuizProgressScreen> createState() =>
      _QuestionAttemptedByQuizProgressScreenState();
}

class _QuestionAttemptedByQuizProgressScreenState
    extends State<QuestionAttemptedByQuizProgressScreen> {
  var radius = 20.0;

  List<QuestionByQuizAttemptedModel> list = <QuestionByQuizAttemptedModel>[];
  List<QuestionByQuizAttemptedModel> truList = <QuestionByQuizAttemptedModel>[];
  List<QuestionByQuizAttemptedModel> falseList =
      <QuestionByQuizAttemptedModel>[];

  int notAttempted = 0;
  bool loader = true;

  bool pass = false;

  var userType;

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
  }

  checkResult(int length) {
    if (truList.length >= (length * 90 / 100)) {
      setState(() {
        pass = true;
      });
    } else {
      setState(() {
        pass = false;
      });
    }
  }

  getList() async {
    print('getting list');
    Map body = {
      'quize_id': widget.quizId.toString(),
      'type': widget.type.toString(),
    };

    try {
      http.Response response = await http
          .post(Uri.parse(questionByQuizAttemptedURL.toString()), body: body);
      print(response.body);

      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          QuestionByQuizAttemptedModel pos = QuestionByQuizAttemptedModel();
          pos = QuestionByQuizAttemptedModel.fromJson(obj);
          if (pos.answer.toString() == pos.attempted.toString()) {
            truList.add(pos);
          } else {
            falseList.add(pos);
          }
          list.add(pos);
        }
        int len = int.parse(list[0].totalQuestion.toString());
        notAttempted = len - list.length;
        checkResult(len);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserStatus();
    getList();
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
              children: [
                const SizedBox(
                  width: 10,
                ),
                appBarIcon(context),
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
                    padding: const EdgeInsets.symmetric(vertical: 2),
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
                        Text('${truList.length}',
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
                        Text('${falseList.length}',
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
                        Text('$notAttempted',
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
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        bool val;
                        if (list[index].questionPicture == null ||
                            list[index].questionPicture.toString() == "null" ||
                            list[index].questionPicture.toString() == "") {
                          val = true;
                        } else {
                          val = false;
                        }

                        bool ans;
                        if (list[index].answer.toString() ==
                            list[index].attempted.toString()) {
                          ans = true;
                        } else {
                          ans = false;
                        }

                        return progressPageWidget(context, index, val, ans,
                            radius, userType.toString(), list);
                      },
                    ),
            ),
          ),
        ],
      ),
    ));
  }
}
