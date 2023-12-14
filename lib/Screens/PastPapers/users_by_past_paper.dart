import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/past_paper_user_model.dart';
import '../../Provider/vocabulary_provider.dart';
import '../../Utils/Navigator.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/Network/offline_checker.dart';
import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/past_paper_user_widget.dart';
import 'past_paper_questions_by_user.dart';

class PastPapersScreen extends StatefulWidget {
  const PastPapersScreen({super.key});

  @override
  State<PastPapersScreen> createState() => _PastPapersScreenState();
}

class _PastPapersScreenState extends State<PastPapersScreen> {
  List<PastPaperUserModel> list = <PastPaperUserModel>[];
  bool loader = false;

  bool checkConnection = false;

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
    var book_id = prefs.getString('MainCategoryId');

    Map body = {'book_id': book_id.toString()};

    try {
      http.Response response =
          await http.post(Uri.parse(getUsersByPastPaperURL), body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      List<String> imageList = [];

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          PastPaperUserModel pos = PastPaperUserModel();
          pos = PastPaperUserModel.fromJson(obj);
          list.add(pos);
        }

        for (int i = 0; i < jsonData['images'].length; i++) {
          String pos = jsonData['images'][i].toString();
          imageList.add(pos);
        }
        context.read<VocabularyProvider>().cacheTestImage(imageList);

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
            body: Column(
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
                              size: 24,
                            ),
                          )),
                      Text(
                        'Seleziona scheda',
                        style: TextStyle(
                            color: appbarcolor,
                            fontSize: 21,
                            fontWeight: FontWeight.w600),
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
                    color: kblues,
                    child: loader
                        ? const Center(child: CircularProgressIndicator())
                        : list.isEmpty
                            ? const Center(
                                child: Text('Nessun record trovato qui'),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 6),
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      navPush(
                                          context,
                                          QuizByUsersScreen(
                                            userId:
                                                list[index].user!.id.toString(),
                                            time: int.parse(list[index]
                                                .user!
                                                .time
                                                .toString()),
                                          ));
                                    },
                                    child:
                                        pastPaperUserWidget(index, list[index]),
                                  );
                                }),
                  ),
                ),
              ],
            ),
          ));
  }
}
