import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/language_class.dart';
import 'Utils/Navigator.dart';
import 'Utils/colors.dart';
import 'category_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  DateTime? currentBackPressTime;

  List<MyLanguageClass> list = <MyLanguageClass>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    list = getMyClassList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: WillPopScope(
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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.058,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 90),
                      child: Text(
                        'Dar Patente',
                        style: TextStyle(
                            color: appbarcolor,
                            fontSize: 26,
                            fontWeight: FontWeight.w600),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
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
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ListView.builder(
                    semanticChildCount: 4,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              'language', list[index].value.toString());
                          navReplace(context, const MainCategoryScreen());
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.080,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: kWhite),
                          child: Center(
                              child: Text(
                            '${list[index].name}',
                            style: TextStyle(fontSize: 20, color: appbarcolor),
                          )),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
