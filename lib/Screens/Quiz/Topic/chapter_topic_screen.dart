import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/chapter_model.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/Network/check_connectivity.dart';
import '../../../Utils/Network/offline_checker.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/messages.dart';
import '../../../Utils/url.dart';
import '../../../widgets/app_bar_icon.dart';
import '../../../widgets/app_bar_image.dart';
import '../../../widgets/app_bar_title.dart';
import '../../../widgets/chapter_topic_screen_widget.dart';
import 'topic_screen.dart';

class ChapterForTopicScreen extends StatefulWidget {
  const ChapterForTopicScreen({super.key});

  @override
  State<ChapterForTopicScreen> createState() => _ChapterForTopicScreenState();
}

class _ChapterForTopicScreenState extends State<ChapterForTopicScreen> {
  List<ChapterModel> chapterList = <ChapterModel>[];

  bool checkConnection = false;
  bool loader = false;

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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString('MainCategoryId');

    Map body = {
      'id': catId.toString(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(getChapterURL.toString()), body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          ChapterModel pos = ChapterModel();
          pos = ChapterModel.fromJson(obj);
          chapterList.add(pos);
        }
        print(chapterList.length);
      } else {}
    } catch (e) {
      print(e);
      showSnackMessage(context, 'Qualcosa è andato storto!');
    }
    setState(() {
      loader = false;
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
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
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
                        appBarTitle('Seleziona capitolo'),
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
                      child: loader
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 6),
                              itemCount: chapterList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    navPush(
                                        context,
                                        TopicsScreen(
                                          id: chapterList[index].id.toString(),
                                          name: chapterList[index]
                                              .name
                                              .toString(),
                                        ));
                                  },
                                  child: chapterTopicScreenWidget(
                                      context, chapterList[index]),
                                );
                              },
                            ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
