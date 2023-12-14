import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Utils/colors.dart';
import '../../../Models/repaso_errori_question_model.dart';
import '../../../widgets/app_bar_icon.dart';
import '../../../widgets/app_bar_image.dart';
import '../../../widgets/errori_repaso_progress_widget.dart';

class RepasoErroriProgressPage extends StatefulWidget {
  const RepasoErroriProgressPage({
    super.key,
    required this.list,
  });

  final List<RepasoErroriQuestionModel> list;

  @override
  State<RepasoErroriProgressPage> createState() =>
      _RepasoErroriProgressPageState();
}

class _RepasoErroriProgressPageState extends State<RepasoErroriProgressPage> {
  var radius = 20.0;
  List<RepasoErroriQuestionModel> truList = <RepasoErroriQuestionModel>[];
  List<RepasoErroriQuestionModel> falseList = <RepasoErroriQuestionModel>[];

  int notAttempted = 0;

  var userType;

  bool pass = false;

  checkResult() {
    if (truList.length >= (widget.list.length * 90 / 100)) {
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
        if (widget.list[i].answer.toString() ==
            widget.list[i].myAttempted.toString()) {
          truList.add(widget.list[i]);
        } else {
          falseList.add(widget.list[i]);
        }
      } else {
        notAttempted++;
      }
    }
    checkResult();
  }

  getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    setState(() {});
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
                      color: (widget.list.isNotEmpty)
                          ? pass
                              ? kgreen
                              : kRed
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 2),
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
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                shrinkWrap: true,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  bool val;
                  if (widget.list[index].questionPicture == null ||
                      widget.list[index].questionPicture.toString() == "null" ||
                      widget.list[index].questionPicture.toString() == "") {
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

                  return erroriRepasoProgressWidget(
                      context, index,userType.toString(), ans, val, radius, widget.list[index]);
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
