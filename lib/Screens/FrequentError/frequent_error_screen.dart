import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/QuestionModel.dart';
import '../../Models/chapter_model.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/app_bar_title.dart';
import '../../widgets/errori_frequentati_widget.dart';
import 'Quiz/errori_frequenti_no_question_paper.dart';
import 'Quiz/errori_frequenti_yes_question_paper.dart';

class FrequentErrorScreen extends StatefulWidget {
  const FrequentErrorScreen({super.key});

  @override
  State<FrequentErrorScreen> createState() => _FrequentErrorScreenState();
}

class _FrequentErrorScreenState extends State<FrequentErrorScreen> {
  List<ChapterModel> chapterList = <ChapterModel>[];
  List<QuestionModel> questionList = <QuestionModel>[];

  bool loader = true;
  bool dialogLoader = false;
  bool checkConnection = false;

  getList() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString('MainCategoryId');

    Map body = {
      'id': catId.toString(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(getChapterURL), body: body);
      print(response.body);

      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          ChapterModel pos = ChapterModel();
          pos = ChapterModel.fromJson(obj);
          chapterList.add(pos);
        }
        print(chapterList.length);
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
    getList();
  }

  Future<void> showEmail(BuildContext context, String id) async {
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
                                      var savedKey = 'erroriFrequenti$id';
                                      var erroriFrequenti =
                                          prefs.getInt(savedKey);
                                      if (erroriFrequenti == null) {
                                        prefs.setInt(savedKey, 1);
                                        erroriFrequenti = 1;
                                      }
                                      Map body = {
                                        'chapter_id': id.toString(),
                                        'page_no': erroriFrequenti.toString(),
                                      };
                                      print(body);
                                      try {
                                        http.Response response = await http
                                            .post(Uri.parse(errorFrequentiURL),
                                                body: body);

                                        print(response.body);

                                        Map jsonData =
                                            jsonDecode(response.body);

                                        if (jsonData['status'] == 200) {
                                          for (int i = 0;
                                              i < jsonData['questions'].length;
                                              i++) {
                                            Map<String, dynamic> obj =
                                                jsonData['questions'][i];
                                            QuestionModel pos = QuestionModel();
                                            pos = QuestionModel.fromJson(obj);
                                            questionList.add(pos);
                                          }
                                          setState(() {
                                            dialogLoader = false;
                                          });

                                          if (questionList.isNotEmpty) {
                                            var total_page =
                                                jsonData['total_page'];
                                            int totalPage = int.parse(
                                                total_page.toString());
                                            if (erroriFrequenti < totalPage) {
                                              erroriFrequenti++;
                                              prefs.setInt(
                                                  savedKey, erroriFrequenti);
                                            } else if (erroriFrequenti ==
                                                totalPage) {
                                              prefs.setInt(savedKey, 1);
                                            }
                                            Navigator.pop(context);

                                            navPush(
                                                context,
                                                ErroriFrequentiNoQuestionPaperScreen(
                                                  questionList: questionList,
                                                ));
                                          } else {
                                            Navigator.pop(context);
                                            showSnackMessage(context,
                                                'No important Questions in this chapter');
                                          }
                                        } else {
                                          setState(() {
                                            dialogLoader = false;
                                          });
                                        }
                                      } catch (e) {
                                        setState(() {
                                          dialogLoader = false;
                                        });
                                        print(e);
                                      }
                                    } else {
                                      print('no internet connection');
                                    }
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
                                    if (await connection()) {
                                      setState(() {
                                        dialogLoader = true;
                                        questionList.clear();
                                      });
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var savedKey = 'erroriFrequenti$id';
                                      var erroriFrequenti =
                                          prefs.getInt(savedKey);
                                      if (erroriFrequenti == null) {
                                        prefs.setInt(savedKey, 1);
                                        erroriFrequenti = 1;
                                      }
                                      Map body = {
                                        'chapter_id': id.toString(),
                                        'page_no': erroriFrequenti.toString(),
                                      };
                                      print(body);
                                      try {
                                        http.Response response = await http
                                            .post(Uri.parse(errorFrequentiURL),
                                                body: body);

                                        print(response.body);

                                        Map jsonData =
                                            jsonDecode(response.body);

                                        if (jsonData['status'] == 200) {
                                          for (int i = 0;
                                              i < jsonData['questions'].length;
                                              i++) {
                                            Map<String, dynamic> obj =
                                                jsonData['questions'][i];
                                            QuestionModel pos = QuestionModel();
                                            pos = QuestionModel.fromJson(obj);
                                            questionList.add(pos);
                                          }
                                          setState(() {
                                            dialogLoader = false;
                                          });

                                          if (questionList.isNotEmpty) {
                                            var total_page =
                                                jsonData['total_page'];
                                            int totalPage = int.parse(
                                                total_page.toString());
                                            if (erroriFrequenti < totalPage) {
                                              erroriFrequenti++;
                                              prefs.setInt(
                                                  savedKey, erroriFrequenti);
                                            } else if (erroriFrequenti ==
                                                totalPage) {
                                              prefs.setInt(savedKey, 1);
                                            }
                                            Navigator.pop(context);

                                            navPush(
                                                context,
                                                ErroriFrequentiYesQuestionPaperScreen(
                                                  questionList: questionList,
                                                ));
                                          } else {
                                            Navigator.pop(context);
                                            showSnackMessage(context,
                                                'No important Questions in this chapter');
                                          }
                                        } else {
                                          setState(() {
                                            dialogLoader = false;
                                          });
                                        }
                                      } catch (e) {
                                        setState(() {
                                          dialogLoader = false;
                                        });
                                        print(e);
                                      }
                                    } else {
                                      print('no internet connection');
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
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.058,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appBarIcon(context),
                  appBarTitle('Errori Frequenti'),
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: chapterList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        showEmail(context,
                                            chapterList[index].id.toString());
                                      },
                                      child: erroriFrequentatiWidget(
                                          context, chapterList[index]),
                                    );
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
