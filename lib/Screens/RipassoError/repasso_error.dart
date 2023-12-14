import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/RepassoErrorModel.dart';
import '../../Models/repaso_errori_question_model.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/repaso_errori_widget.dart';
import 'Paper/repaso_errori_no_question_paper.dart';
import 'Paper/repaso_errori_yes_question_paper.dart';

class RepassoErrorScreen extends StatefulWidget {
  const RepassoErrorScreen({super.key});

  @override
  State<RepassoErrorScreen> createState() => _RepassoErrorScreenState();
}

class _RepassoErrorScreenState extends State<RepassoErrorScreen> {
  List<RepasoErroriQuestionModel> questionList = <RepasoErroriQuestionModel>[];
  List<RepassoErrorModel> list = <RepassoErrorModel>[];

  List<int> selectedChaptersId = [];

  bool loader = true;
  bool dialogLoader = false;
  bool checkConnection = false;

  getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var catId = prefs.getString('MainCategoryId');
    print('MainCategoryId::::$id');
    print('userId::::$catId');
    Map body = {
      'user_id': id.toString(),
      'book_id': catId.toString(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(errorRipassoURL), body: body);
      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          RepassoErrorModel pos = RepassoErrorModel();
          pos = RepassoErrorModel.fromJson(obj);
          if (pos.chapter != null) {
            list.add(pos);
          }
        }
      } else {}
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
    getList();
  }

  void allSelected() {
    setState(() {
      if (selectedChaptersId.length != list.length) {
        selectedChaptersId.clear();
        for (int i = 0; i < list.length; i++) {
          if (list[i].chapter != null) {
            selectedChaptersId.add(list[i].chapter!.id!);
          }
        }
      } else {
        selectedChaptersId.clear();
      }
    });
  }

  void selected(int id, String bookId) {
    print(id);
    setState(() {
      if (selectedChaptersId.contains(id)) {
        selectedChaptersId.remove(id);
      } else {
        selectedChaptersId.add(id);
      }
    });
  }

  Future<void> showEmail(BuildContext context) async {
    bool noQuestion = false;
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
                  color: klightblue,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              noQuestion
                                  ? 'No Question found'
                                  : 'Risultato immediato',
                              style: const TextStyle(fontSize: 20),
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
                                      Map body = {
                                        'user_id': userId.toString(),
                                      };
                                      for (int i = 0;
                                          i < selectedChaptersId.length;
                                          i++) {
                                        body.addAll({
                                          'chapter_id[$i]': '${selectedChaptersId[i]}',
                                        });
                                      }
                                      print(body);

                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(errorRepasoQuestionURL
                                                    .toString()),
                                                body: body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        print(jsonData);

                                        if (jsonData['status'] == 200) {
                                          for (int i = 0;
                                              i < jsonData['questions'].length;
                                              i++) {
                                            Map<String, dynamic> obj =
                                                jsonData['questions'][i];
                                            RepasoErroriQuestionModel pos =
                                                RepasoErroriQuestionModel();
                                            pos = RepasoErroriQuestionModel
                                                .fromJson(obj);
                                            questionList.add(pos);
                                          }
                                          if (questionList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                RepasoErroriNoQuestionPaperScreen(
                                                  list: questionList,
                                                ));
                                          } else {
                                            setState(() {
                                              noQuestion = true;
                                              dialogLoader = false;
                                            });
                                            showSnackMessage(context, 'No Question found');
                                            Navigator.pop(context);
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
                                      var userId = prefs.getString('id');
                                      Map body = {
                                        'user_id': userId.toString(),
                                      };
                                      for (int i = 0;
                                          i < selectedChaptersId.length;
                                          i++) {
                                        body.addAll({
                                          'chapter_id[$i]': '${selectedChaptersId[i]}',
                                        });
                                      }
                                      print(body);
                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(errorRepasoQuestionURL
                                                    .toString()),
                                                body: body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        print(jsonData);

                                        if (jsonData['status'] == 200) {
                                          for (int i = 0;
                                              i < jsonData['questions'].length;
                                              i++) {
                                            Map<String, dynamic> obj =
                                                jsonData['questions'][i];
                                            RepasoErroriQuestionModel pos =
                                                RepasoErroriQuestionModel();
                                            pos = RepasoErroriQuestionModel
                                                .fromJson(obj);
                                            questionList.add(pos);
                                          }
                                          if (questionList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                RepasoErroriYesQuestionPaperScreen(
                                                  list: questionList,
                                                ));
                                          } else {
                                            setState(() {
                                              noQuestion = true;
                                              dialogLoader = false;
                                            });
                                            showSnackMessage(context, 'No Question found');
                                            Navigator.pop(context);
                                          }
                                        } else {}
                                      } catch (e) {
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
        backgroundColor: kWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.058,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appBarIcon(context),
                  InkWell(
                    onTap: () {
                      if (selectedChaptersId.isNotEmpty) {
                        showEmail(context);
                      }
                    },
                    child: Text(
                      'Inizia',
                      style: TextStyle(
                        color: appbarcolor,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  appBarImage(context),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22)),
                      color: kblues),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Selezione tutto',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: appbarcolor),
                                ),
                              ),
                            ),
                            const Expanded(child: Text('')),
                            loader
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      allSelected();
                                    },
                                    child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            color: selectedChaptersId.length ==
                                                    list.length
                                                ? kWhite
                                                : appbarcolor,
                                            border: Border.all(
                                                color: kWhite, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          height: 20,
                                          width: 20,
                                        )),
                                  ),
                            const SizedBox(width: 10)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(22),
                                bottomRight: Radius.circular(22)),
                          ),
                          child: loader
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int trueQuestion = int.parse(
                                        list[index].trueQuestions.toString());
                                    int falseQuestion = int.parse(
                                        list[index].falseQuestions.toString());
                                    int totalQuestion = int.parse(
                                        list[index].totalQuestions.toString());
                                    int remainingQuestion = totalQuestion -
                                        (trueQuestion + falseQuestion);

                                    return list[index].chapter != null
                                        ? repasoErroriWidget(
                                            context,
                                            trueQuestion,
                                            falseQuestion,
                                            remainingQuestion,
                                            list[index],
                                            selectedChaptersId,
                                            selected)
                                        : const SizedBox();
                                  }),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
