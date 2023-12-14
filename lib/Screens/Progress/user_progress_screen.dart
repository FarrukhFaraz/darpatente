import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/colors.dart';
import '../../Models/Progress/progress_by_chapter_model.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/app_bar_title.dart';
import '../../widgets/progress_widget.dart';
import 'total_quiz_attempted.dart';

class UserProgressScreen extends StatefulWidget {
  const UserProgressScreen({super.key});

  @override
  State<UserProgressScreen> createState() => _UserProgressScreenState();
}

class _UserProgressScreenState extends State<UserProgressScreen> {
  var papersPassedByBooks;

  var papersFailedByBooks;

  bool bookLoader = true;
  bool chapterLoader = true;

  var bookId;

  List<ProgressByChapterModel> chaptersProgressList =
      <ProgressByChapterModel>[];

  checkConnectivity() async {
    if (await connection()) {
      progressByBook();
      progressByChapter();
    } else {
      showSnackMessage(context, 'No Internet Connection');
    }
  }

  progressByBook() async {
    print('progress by book');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var catId = prefs.getString('MainCategoryId');
    bookId = catId;
    try {
      Map body = {
        'user_id': id.toString(),
        'cat_id': catId.toString(),
      };
      http.Response response =
          await http.post(Uri.parse(progressByBooksURL), body: body);
      Map jsonData = jsonDecode(response.body);
      print('books data:::::$jsonData');
      if (jsonData['status'] == 200) {
        setState(() {
          papersPassedByBooks = jsonData['pass'];
          papersFailedByBooks = jsonData['fail'];
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      bookLoader = false;
    });
  }

  progressByChapter() async {
    print('progress by chapter');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var catId = prefs.getString('MainCategoryId');
    try {
      Map body = {
        'user_id': id.toString(),
        'book_id': catId.toString(),
      };
      http.Response response =
          await http.post(Uri.parse(progressByChaptersURL), body: body);
      Map jsonData = jsonDecode(response.body);
      print('chapters data  ::::: $jsonData');

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          ProgressByChapterModel pos = ProgressByChapterModel();
          pos = ProgressByChapterModel.fromJson(obj);
          chaptersProgressList.add(pos);
        }
        print(chaptersProgressList.length);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      chapterLoader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.058,
            color: kWhite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBarIcon(context),
                appBarTitle('Dar Patente'),
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
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                    height: MediaQuery.of(context).size.height * 0.18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: appbarcolor,
                    ),
                    child: bookLoader
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () {
                              if (papersFailedByBooks > 0 ||
                                  papersPassedByBooks > 0) {
                                navPush(
                                    context,
                                    TotalQuizAttemptedScreen(
                                      catId: bookId,
                                      type: '0',
                                    ));
                              }
                            },
                            child: progressTotalQuizWidget(
                                context,
                                papersPassedByBooks.toString(),
                                papersFailedByBooks.toString()),
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.700,
                    height: MediaQuery.of(context).size.height * 0.04,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: appbarcolor),
                        borderRadius: BorderRadius.circular(4),
                        color: appbarcolor),
                    child: Center(
                        child: Text(
                      'CAPITOLI',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: kWhite),
                    )),
                  ),
                  chapterLoader
                      ? Container(
                          margin: const EdgeInsets.only(top: 100),
                          width: 40,
                          height: 40,
                          child: const CircularProgressIndicator())
                      : Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(22),
                                      bottomRight: Radius.circular(22)),
                                  color: kblues),
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  shrinkWrap: true,
                                  itemCount: chaptersProgressList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return chaptersProgressList[index]
                                                .chapter !=
                                            null
                                        ? InkWell(
                                            onTap: () {
                                              if (chaptersProgressList[index]
                                                          .fail! >
                                                      0 ||
                                                  chaptersProgressList[index]
                                                          .pass! >
                                                      0) {
                                                navPush(
                                                    context,
                                                    TotalQuizAttemptedScreen(
                                                      catId:
                                                          chaptersProgressList[
                                                                  index]
                                                              .chapter!
                                                              .id
                                                              .toString(),
                                                      type: '1',
                                                    ));
                                              }
                                            },
                                            child: progressWidget(context,
                                                chaptersProgressList[index]),
                                          )
                                        : const SizedBox();
                                  })),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
