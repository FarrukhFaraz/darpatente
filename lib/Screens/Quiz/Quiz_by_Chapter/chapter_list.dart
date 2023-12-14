import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/QuestionModel.dart';
import '../../../Models/chapter_model.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/Network/check_connectivity.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/messages.dart';
import '../../../Utils/url.dart';
import '../QuestionPaper/no_question_paper.dart';
import '../QuestionPaper/yes_question_paper.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({super.key});

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  List<ChapterModel> chapterList = <ChapterModel>[];

  final List<int> _selectedChapterId = [];

  List<QuestionModel> questionList = <QuestionModel>[];

  bool loader = false;
  bool dialogLoader = false;

  bool checkConnection = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callChapterApi();
  }

  callChapterApi() async {
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
      showSnackMessage(context, '$e');
    }
    setState(() {
      loader = false;
    });
  }

  void _onOptionSelected(int id, int bookId) {
    setState(() {
      if (_selectedChapterId.contains(id)) {
        _selectedChapterId.remove(id);
      } else {
        _selectedChapterId.add(id);
      }
    });

    print("${id} \n${_selectedChapterId.length}");
  }

  selectedAll() {
    if (_selectedChapterId.length == chapterList.length) {
      _selectedChapterId.clear();
    } else {
      _selectedChapterId.clear();
      for (int i = 0; i < chapterList.length; i++) {
        _selectedChapterId.add(chapterList[i].id!);
      }
    }
    setState(() {});
    print(_selectedChapterId.length);
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
                                      var user_id = prefs.getString('id');
                                      var book_id =
                                          prefs.getString('MainCategoryId');
                                      Map body = {
                                        'user_id': user_id.toString(),
                                        'book_id': book_id.toString(),
                                      };
                                      for (int i = 0;
                                          i < _selectedChapterId.length;
                                          i++) {
                                        body.addAll({
                                          'chapter_id[$i]':
                                              '${_selectedChapterId[i]}',
                                        });
                                      }

                                      print(body);

                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(questionByChapterURL
                                                    .toString()),
                                                body: body);
                                        print(response.body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        print(jsonData);

                                        if (jsonData['status'] == 200) {
                                          int time = 0;
                                          var t = jsonData['Books']['time'];
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
                                          if (questionList.isNotEmpty) {
                                            Navigator.pop(context);
                                            navPush(
                                                context,
                                                NoQuestionPaperScreen(
                                                  time: time,
                                                  questionList: questionList,
                                                  type: '1',
                                                  catId: _selectedChapterId
                                                              .length ==
                                                          1
                                                      ? _selectedChapterId[0]
                                                          .toString()
                                                      : '-1', //////  for multiple chapters default cat_id = -1
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
                                      var book_id =
                                          prefs.getString('MainCategoryId');
                                      Map body = {
                                        'user_id': user_id.toString(),
                                        'book_id': book_id.toString(),
                                      };
                                      for (int i = 0;
                                          i < _selectedChapterId.length;
                                          i++) {
                                        body.addAll({
                                          'chapter_id[$i]':
                                              '${_selectedChapterId[i]}',
                                        });
                                      }

                                      print(body);

                                      try {
                                        http.Response response =
                                            await http.post(
                                                Uri.parse(questionByChapterURL
                                                    .toString()),
                                                body: body);
                                        print(response.body);
                                        Map jsonData =
                                            jsonDecode(response.body);
                                        print("$jsonData");

                                        if (jsonData['status'] == 200) {
                                          int time = 0;
                                          var t = jsonData['Books']['time'];
                                          if (t.toString().isNotEmpty ||
                                              t != null) {
                                            time = int.parse(t.toString());
                                          } else {
                                            time = 30;
                                          }
                                          print(time);

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
                                            navPush(
                                                context,
                                                YesQuestionPaperScreen(
                                                  questionList: questionList,
                                                  time: time,
                                                  type: '1',
                                                  catId: _selectedChapterId
                                                              .length ==
                                                          1
                                                      ? _selectedChapterId[0]
                                                          .toString()
                                                      : '-1', //////  for multiple chapters default cat_id = -1
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
        backgroundColor: kWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.058,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      if (_selectedChapterId.isNotEmpty) {
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
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image(
                        height: MediaQuery.of(context).size.height * 0.09,
                        image: const AssetImage('assets/images/dar.png')),
                  ),
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
                      const SizedBox(height: 6),
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
                                      selectedAll();
                                    },
                                    child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            color: _selectedChapterId.length ==
                                                    chapterList.length
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
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(22),
                                bottomRight: Radius.circular(22)),
                          ),
                          child: loader
                              ? const SizedBox(
                                  height: 41,
                                  child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: chapterList.length,
                                  itemBuilder: (context, index) {
                                    // final option = list[index].name.toString();
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.93,
                                      margin: const EdgeInsets.only(top: 6),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.145,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          color: appbarcolor),
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.22,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: chapterList[index]
                                                                .pic ==
                                                            null
                                                        ? const SizedBox()
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            child:CachedNetworkImage(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height *
                                                                  0.10,
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width *
                                                                  0.26,
                                                              imageUrl:
                                                              "${imageBaseURL}chapters/${chapterList[index].pic.toString()}",
                                                              progressIndicatorBuilder: (context,
                                                                  url, downloadProgress) =>
                                                                  SizedBox(
                                                                    height: 200,
                                                                    child: Center(
                                                                      child: CircularProgressIndicator(
                                                                          value: downloadProgress
                                                                              .progress),
                                                                    ),
                                                                  ),
                                                              errorWidget: (context, url, error) =>
                                                              const Icon(Icons.error),
                                                            )
                                                                /*Image.network(
                                                              "${imageBaseURL}chapters/${chapterList[index].pic.toString()}",
                                                              fit: BoxFit.cover,
                                                              loadingBuilder:
                                                                  (context, wid,
                                                                      pro) {
                                                                return Center(
                                                                    child: wid);
                                                              },
                                                              frameBuilder:
                                                                  (context,
                                                                      wid,
                                                                      frame,
                                                                      loaded) {
                                                                return wid;
                                                              },
                                                              errorBuilder:
                                                                  (context, wid,
                                                                      trace) {
                                                                return const Center(
                                                                    child:
                                                                        Tooltip(
                                                                  message:
                                                                      'error in fetching image',
                                                                  showDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                  triggerMode:
                                                                      TooltipTriggerMode
                                                                          .tap,
                                                                  enableFeedback:
                                                                      true,
                                                                  child: Icon(
                                                                    Icons.info,
                                                                    size: 40,
                                                                  ),
                                                                ));
                                                              },
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.10,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.26,
                                                            )*/
                                                      ,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 4),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      chapterList[index]
                                                          .name
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kWhite),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    //margin: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      '${chapterList[index].description}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kWhite),
                                                    ),
                                                  ),
                                                  const Expanded(
                                                      child: Text('')),
                                                  LinearPercentIndicator(
                                                    width: 230.0,
                                                    lineHeight: 10.0,
                                                    percent: 0.5,
                                                    backgroundColor: kWhite,
                                                    progressColor: kWhite,
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30,
                                                    right: 26,
                                                    top: 10),
                                                child: Transform.scale(
                                                    scale: 2,
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 22),
                                                        GestureDetector(
                                                            onTap: () {
                                                              _onOptionSelected(
                                                                  chapterList[
                                                                          index]
                                                                      .id!
                                                                      .toInt(),
                                                                  int.parse(chapterList[
                                                                          index]
                                                                      .bookId
                                                                      .toString()));
                                                            },
                                                            child: Container(
                                                              // color: Colors.green,
                                                              height: 17,
                                                              width: 17,
                                                              decoration: BoxDecoration(
                                                                  color: _selectedChapterId.contains(
                                                                          chapterList[index]
                                                                              .id)
                                                                      ? kWhite
                                                                      : appbarcolor,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              34)),
                                                              child: _selectedChapterId
                                                                      .contains(
                                                                          chapterList[index]
                                                                              .id)
                                                                  ? Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(30),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      height:
                                                                          16,
                                                                      width: 16,
                                                                    )
                                                                  : Container(
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              2),
                                                                      height:
                                                                          12,
                                                                      width: 12,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(30),
                                                                          color: appbarcolor,
                                                                          border: Border.all(
                                                                            color:
                                                                                appbarcolor,
                                                                          )),
                                                                    ),
                                                            )),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
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
