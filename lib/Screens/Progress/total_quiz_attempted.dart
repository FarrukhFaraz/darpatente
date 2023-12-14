import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Progress/total_quiz_attempted.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/colors.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/app_bar_title.dart';
import '../../widgets/progress_widget.dart';
import 'question_attempted_by_quiz_progress.dart';

class TotalQuizAttemptedScreen extends StatefulWidget {
  const TotalQuizAttemptedScreen({
    super.key,
    required this.catId,
    required this.type,
  });

  final String catId;
  final String type;

  @override
  State<TotalQuizAttemptedScreen> createState() =>
      _TotalQuizAttemptedScreenState();
}

class _TotalQuizAttemptedScreenState extends State<TotalQuizAttemptedScreen> {
  bool loader = true;

  List<TotalQuizAttemptedModel> list = <TotalQuizAttemptedModel>[];

  getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    Map body = {
      'user_id': userId.toString(),
      'cat_id': widget.catId.toString(),
      'type': widget.type.toString(),
    };

    try {
      http.Response response = await http
          .post(Uri.parse(totalQuizAttemptedURL.toString()), body: body);
      print(response.body);
      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          TotalQuizAttemptedModel pos = TotalQuizAttemptedModel();
          pos = TotalQuizAttemptedModel.fromJson(obj);
          list.add(pos);
        }
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
                  appBarTitle('Tentativo di quiz'),
                  appBarImage(context),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: kblues,
                child: loader
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        color: kblues,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var formattedDate = '';

                            if (list[index].updatedAt.toString() != 'null') {
                              final originalDate =
                                  list[index].updatedAt.toString();
                              final dateFormat = DateFormat('dd MMM, yyyy');
                              final parsedDate = DateTime.parse(originalDate);
                              formattedDate = dateFormat.format(parsedDate);
                            }

                            return InkWell(
                              onTap: () {
                                navPush(
                                    context,
                                    QuestionAttemptedByQuizProgressScreen(
                                      quizId: list[index].quizeId.toString(),
                                      type: widget.type,
                                    ));
                              },
                              child: progressTotalQuizAttemptedWidget(
                                  list[index], formattedDate.toString()),
                            );
                          },
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
