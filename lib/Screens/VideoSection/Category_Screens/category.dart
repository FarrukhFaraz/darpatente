import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/category_model.dart';
import '../../../Utils/Navigator.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/url.dart';
import 'chapters.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool loader = false;
  var userToken;
  var categoryName;
  List<Chapters> chapters = [];

  getShare() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userToken = sharedPreferences.getString('token');
    getCategoryApi();
  }

  getCategoryApi() async {
    setState(() {
      loader = true;
    });
    print('user token:::::$userToken');
    http.Response response = await http.get(Uri.parse(userinfourl),
        headers: {"Authorization": "Bearer $userToken"});

    print(userToken);

    print(response.body.toString());
    Map jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        categoryName = jsonData['data']['category']['name'];
        loader = false;
      });

      for (int i = 0; i < jsonData['data']["chapters"].length; i++) {
        Map<String, dynamic> object = jsonData['data']["chapters"][i];
        Chapters test = Chapters();
        test = Chapters.fromJson(object);
        chapters.add(test);
      }
    } else {
      print("Error");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong")));
    }

    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShare();
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    print('object');
    return SafeArea(
        child: Scaffold(
          body: loader
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(
            //  width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 2.2, color: yellow800)),
            margin: EdgeInsets.only(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.04,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.06,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.06,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.02,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * 0.04,
                      // left: MediaQuery.of(context).size.width *0.06,
                      // right: MediaQuery.of(context).size.width *0.06,
                      // bottom: MediaQuery.of(context).size.height *0.02,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.10,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: yellow800,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              image: const AssetImage(
                                  "assets/images/Last logo.jpeg"),
                              height:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.1,
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.1,
                            ),
                            Text(
                              "Category",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: kWhite,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                  GestureDetector(
                      onTap: () {
                        navPush(
                            context,
                            const ChapterScreen(
                              // catid: catid,
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.02,
                          right: MediaQuery
                              .of(context)
                              .size
                              .width * 0.02,
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.02,
                        ),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.08,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(14)),
                        child: Text(
                          categoryName.toString(),
                          style: TextStyle(
                              fontSize: 24,
                              color: yellow800,
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.46,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.home,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      Divider(
                        color: yellow800,
                        //color of divider
                        height: 5,
                        //height spacing of divider
                        thickness: 2,
                        //thickness of divier line
                        indent: 25,
                        //spacing at the start of divider
                        endIndent: 25, //spacing at the end of divider
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Text(
                            "Dar formazione per patente e lingue italiana\n patente AM, B,C,D , Corse CQC,\n info. 3779870452",
                            style: TextStyle(
                              fontSize: 14,
                              color: kBlack,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

}