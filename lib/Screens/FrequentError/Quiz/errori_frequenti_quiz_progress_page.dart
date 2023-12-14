import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/QuestionModel.dart';
import '../../../Utils/colors.dart';
import '../../../widgets/app_bar_icon.dart';
import '../../../widgets/app_bar_image.dart';
import '../../../widgets/parogress_page_widget.dart';

class ErroriFrequentiQuizProgressPage extends StatefulWidget {
  const ErroriFrequentiQuizProgressPage({
    super.key,
    required this.list,
  });

  final List<QuestionModel> list;

  @override
  State<ErroriFrequentiQuizProgressPage> createState() =>
      _ErroriFrequentiQuizProgressPageState();
}

class _ErroriFrequentiQuizProgressPageState
    extends State<ErroriFrequentiQuizProgressPage> {
  bool loader = false;
  bool startQuizLoader = false;

  int trueQues = 0;
  int falseQues = 0;

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

  checkResult(int count) {
    if (count >= (widget.list.length * 90 / 100)) {
      setState(() {
        pass = true;
      });
    } else {
      setState(() {
        pass = false;
      });
    }
  }

  getList() {
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.list[i].questionAttempted) {
        if (widget.list[i].myAttempted == widget.list[i].answer) {
          trueQues++;
        } else {
          falseQues++;
        }
      }
    }
    checkResult(trueQues);
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
                    height: MediaQuery.of(context).size.height * 0.026,
                    width: MediaQuery.of(context).size.width * 0.3,
                    margin: const EdgeInsets.only(top: 26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (widget.list.isNotEmpty)
                          ? pass
                              ? kgreen
                              : kRed
                          : null,
                    ),
                    child: Center(
                        child: Text(
                      (widget.list.isNotEmpty)
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
                        Text(loader ? '' : '$trueQues',
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
                        Text(loader ? '' : '$falseQues',
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
                                : '${(widget.list.length) - (trueQues+falseQues)}',
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
                      padding: const EdgeInsets.only(bottom: 8),
                      shrinkWrap: true,
                      itemCount: widget.list.length,
                      itemBuilder: (context, index) {
                        bool val;
                        if (widget.list[index].topic!.topicPicture == null ||
                            widget.list[index].topic!.topicPicture.toString() ==
                                "null" ||
                            widget.list[index].topic!.topicPicture.toString() == "") {
                          val = true;
                        } else {
                          val = false;
                        }

                        bool ans;
                        if (widget.list[index].answer.toString() ==
                            widget.list[index].myAttempted.toString()) {
                          ans = true;
                        } else {
                          ans = false;
                        }

                        return progressErroriPageWidget(
                          context,
                          index,
                          val,
                          ans,
                          radius,
                          userType.toString(),
                          widget.list,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    ));
  }
}
