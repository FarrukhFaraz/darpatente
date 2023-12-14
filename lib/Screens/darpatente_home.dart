import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/home_page_class.dart';
import '../Utils/Navigator.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../main.dart';
import 'About_Privacy_Plicy/about_us.dart';
import 'About_Privacy_Plicy/privacy_policy.dart';
import 'FrequentError/frequent_error_screen.dart';
import 'PastPapers/users_by_past_paper.dart';
import 'Progress/user_progress_screen.dart';
import 'Quiz/start_quiz.dart';
import 'RipassoError/repasso_error.dart';
import 'Truchi/truchi.dart';
import 'VOCABULARY/vocabulary.dart';
import 'VideoSection/Category_Screens/category.dart';

class DarScreen extends StatefulWidget {
  const DarScreen({super.key});

  @override
  State<DarScreen> createState() => _DarScreenState();
}

class _DarScreenState extends State<DarScreen> {
  DateTime? currentBackPressTime;
  bool loader = false;

  List<HomePageClass> list = <HomePageClass>[];
  var userType;

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    print("userType::::$userType");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserType();
    list = getList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          elevation: 0,
          centerTitle: true,
          title: const Text('Dar Patente'),
          titleTextStyle: TextStyle(
            color: appbarcolor,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: appbarcolor),
          actions: <Widget>[
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'about',
                  child: Text('About Us'),
                ),
                const PopupMenuItem(
                  value: 'privacy',
                  child: Text('Privacy Policy'),
                ),
              ],
              onSelected: (value) {
                if (value == 'about') {
                  navPush(context, const AboutUs());
                  print('About Us selected');
                } else if (value == 'privacy') {
                  print('Privacy Policy selected');
                  navPush(context, const PrivacyPolicy());
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              gridView(context),
            ],
          ),
        ),
      ),
    ));
  }

  Widget gridView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: kblues,
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
              // maxCrossAxisExtent: 200,
              childAspectRatio: 9 / 10,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          shrinkWrap: true,
          itemCount: getList().length,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
                padding: EdgeInsets.only(bottom: list[index].padding),
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20, left: 14, right: 14),
                decoration: BoxDecoration(

                    // color: Colors.amber,

                    borderRadius: BorderRadius.circular(20),
                    color: kWhite),
                child: InkWell(
                  onTap: () async {
                    print('userType::::$userType');
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var from_splash = prefs.getString('from_splash');

                    if (from_splash == null) {
                      setState(() {
                        loader =true;
                      });

                      showSnackMessage(context, 'Checking netwok connection:');
                      Timer(const Duration(seconds: 3), () {
                        showSnackMessage(context, 'Restarting App');
                        Timer(const Duration(seconds: 3), (){
                          navRemove(context, const MyApp());
                        });
                      });

                    }
                    else
                    {
                      if (index == 0) {
                        navPush(context, const StartQuizScreen());
                      } else if (index == 1) {
                        if (userType == 'paid') {
                          navPush(context, const CategoryScreen());
                        } else {
                          showSnackMessage(context, 'Only for Paid Users');
                        }
                      } else if (index == 2) {
                        if (userType == 'paid') {
                          navPush(context, const FrequentErrorScreen());
                        } else {
                          showSnackMessage(context, 'Only for Paid Users');
                        }
                      } else if (index == 3) {
                        if (userType == 'paid') {
                          navPush(context, const RepassoErrorScreen());
                        } else {
                          showSnackMessage(context, 'Only for Paid Users');
                        }
                      } else if (index == 4) {
                        if (userType == 'paid') {
                          navPush(context, const PastPapersScreen());
                        }
                      } else if (index == 5) {
                        if (userType == 'paid') {
                          navPush(context, const UserProgressScreen());
                        } else {
                          showSnackMessage(context, 'Only for Paid Users');
                        }
                      } else if (index == 6) {
                        navPush(context, const TrueFalseScreen());
                      } else if (index == 7) {
                        if (userType == 'paid') {
                          navPush(context, const VocabularyScreen());
                        } else {
                          showSnackMessage(context, 'Only for Paid Users');
                        }
                      }
                    }
                  },
                  child: (index == 4 && userType == 'free')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                                child: Image(
                                    height: list[index].height,
                                    width: list[index].width,
                                    image: AssetImage(list[index].textA))),
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    list[index].textB,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: appbarcolor),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text('Coming Soon...'),
                              ],
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                                child: Image(
                                    height: list[index].height,
                                    width: list[index].width,
                                    image: AssetImage(list[index].textA))),
                            Center(
                              child:
                                  // Padding(

                                  // padding: const EdgeInsets.only(left: 6),
                                  // child:
                                  Text(
                                list[index].textB,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: appbarcolor),
                              ),
                            )
                            //),
                          ],
                        ),
                ));
          }),
    );
  }
}
