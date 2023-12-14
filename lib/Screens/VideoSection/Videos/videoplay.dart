import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Navigator.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/url.dart';
import 'chewi.dart';

class VidePlayScreen extends StatefulWidget {

  final String videoId;
  final String name;
  final String video;
  final String thumbnail;

  const VidePlayScreen({
    super.key,
    required this.name,
    required this.video,
    required this.thumbnail,
    required this.videoId,
  });

  @override
  State<VidePlayScreen> createState() => _VidePlayScreenState();
}

class _VidePlayScreenState extends State<VidePlayScreen> {
  bool loader = false;
  var userToken;

  userVideoHistoryAPI() async {
    setState(() {
      loader = true;
    });

    Map body = {'video_id': widget.videoId};

    try {
      http.Response response =
          await http.post(Uri.parse(uservideohistoryurl), body: body, headers: {
        "Authorization": "Bearer $userToken",
        'Accept': 'application/json',
      });
      print("bodyy$body");
      print("useertokenn=====$userToken");

      var jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 'success') {
        setState(() {
          loader=false;
        });
        navPush(
            context,
            ChewiScreen(
              video: widget.video.toString(),
              title: widget.name.toString(),
            ));
      } else {
        setState(() {
          loader=false;
        });
      }
    } catch (e) {
      setState(() {
        loader=false;
      });
      print(e);
    }
  }

  getShare() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userToken = sharedPreferences.getString('userToken');
    print(userToken);
    print(widget.videoId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShare();
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
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
                            Text(
                              widget.name.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: kWhite,
                                  fontWeight: FontWeight.w500),
                            )
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
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.home,
                        size: 40,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
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
                  //      SizedBox(        height: MediaQuery.of(context).size.height*0.01,
                  // ),
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
              loader?Container(
                color: Colors.grey.withOpacity(0.1),
                  height: MediaQuery.of(context).size.height*0.95,
                  child: const Center(child: CircularProgressIndicator(),)):const SizedBox()
            ],
          ),
        ),
      ),
    ));
  }

  Widget demoLesson() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            // color: kLightRed,
          ),
          child: Image.network(
            '${imageBaseURL}category/${widget.thumbnail.toString()}',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.24,
            left: MediaQuery.of(context).size.height * 0.04,
            right: MediaQuery.of(context).size.height * 0.04,
            child: GestureDetector(
              onTap: () {
                userVideoHistoryAPI();
              },
              child: Icon(
                Icons.play_arrow,
                size: 80,
                color: yellow800,
              ),
            ))
      ],
    );
  }
}
