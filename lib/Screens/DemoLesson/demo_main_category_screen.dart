import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/demo_chapter_model.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/url.dart';

class DemoMainCategoryScreen extends StatefulWidget {
  const DemoMainCategoryScreen({
    super.key,
  });

  @override
  State<DemoMainCategoryScreen> createState() => _DemoMainCategoryScreenState();
}

class _DemoMainCategoryScreenState extends State<DemoMainCategoryScreen> {
  bool loader = true;
  List<DemoMainCategoryModel> getDemoChapterList = [];

  getDemoChapterApi() async {

    http.Response response = await http.get(Uri.parse(
      getdemochapterurl,
    ));

    Map jsonData = jsonDecode(response.body);
    print(jsonData);

    if (jsonData['status'] == 'success') {
      setState(() {
        loader = false;
      });

      for (int i = 0; i < jsonData['data'].length; i++) {
        Map<String, dynamic> object = jsonData['data'][i];
        DemoMainCategoryModel test = DemoMainCategoryModel();
        test = DemoMainCategoryModel.fromJson(object);
        getDemoChapterList.add(test);
      }
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDemoChapterApi();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2.2, color: yellow800)),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.04,
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: yellow800,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(
                          image:
                              const AssetImage("assets/images/Last logo.jpeg"),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Text(
                          "Demo",
                          style: TextStyle(
                              fontSize: 30,
                              color: kWhite,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              demoLesson(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.home,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Divider(
                    color: yellow800,
                    height: 5,
                    thickness: 2,
                    indent: 25,
                    endIndent: 25,
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

  Widget demoLesson() {
    return loader?SizedBox(
      height: MediaQuery.of(context).size.height*0.3,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ): ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: getDemoChapterList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            openExternalLink(getDemoChapterList[index].link.toString());
          },
          child: Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: background, borderRadius: BorderRadius.circular(14)),
            child: Text(
              getDemoChapterList[index].name.toString(),
              style: TextStyle(
                  fontSize: 24,
                  color: yellow800,
                  fontWeight: FontWeight.w400),
            ),
          ),
        );
      },
    );
  }

  openExternalLink(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('can not launch url::::$link');
    }
  }

}
