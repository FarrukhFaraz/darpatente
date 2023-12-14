import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/About_Privacy_Plicy/about_us.dart';
import '../Screens/About_Privacy_Plicy/privacy_policy.dart';
import '../Screens/DemoLesson/demo_main_category_screen.dart';
import '../Screens/darpatente_home.dart';
import '../Utils/Navigator.dart';
import '../Utils/colors.dart';
import '../category_screen.dart';
import 'free_user_login.dart.dart';
import 'paid_user_login.dart';

class PaidOrWithoutPaidScreen extends StatefulWidget {
  const PaidOrWithoutPaidScreen({super.key});

  @override
  State<PaidOrWithoutPaidScreen> createState() =>
      _PaidOrWithoutPaidScreenState();
}

class _PaidOrWithoutPaidScreenState extends State<PaidOrWithoutPaidScreen> {
  @override
  void initState() {
    super.initState();
  }

  checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var id = prefs.getString('id');
    var categoryId = prefs.getString('MainCategoryId');
    if (id == null) {
      navPush(context, const FreeUserLoginScreen());
    } else {
      if (categoryId == null) {
        navReplace(context, const MainCategoryScreen());
      } else {
        navReplace(context, const DarScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.058,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Container(
              //           margin: const EdgeInsets.only(left: 90),
              //           child: Text(
              //             'Dar Patente',
              //             style: TextStyle(
              //                 color: appbarcolor,
              //                 fontSize: 26,
              //                 fontWeight: FontWeight.w600),
              //           )),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 70),
              //         child: Image(
              //             height: MediaQuery.of(context).size.height * 0.09,
              //             image: const AssetImage('assets/images/dar.png')),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: kblues,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        navPush(context, const DemoMainCategoryScreen());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.080,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: kWhite),
                        child: Center(
                            child: Text(
                          'Demo Lesson',
                          style: TextStyle(fontSize: 20, color: appbarcolor),
                        )),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.022),
                    InkWell(
                      onTap: () {
                        navPush(context, const PaidUserLoginScreen());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.080,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: kWhite),
                        child: Center(
                            child: Text(
                          'Paid User Login',
                          style: TextStyle(fontSize: 20, color: appbarcolor),
                        )),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.022),
                    InkWell(
                      onTap: () {
                        checkCredentials();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.080,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: kWhite),
                        child: Center(
                            child: Text(
                          'As a Guest',
                          style: TextStyle(fontSize: 20, color: appbarcolor),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
