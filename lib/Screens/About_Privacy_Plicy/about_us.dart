import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool loader = true;
  var about_us;
  var facebook;
  var youtube;
  var instagram;
  var tiktok;

  getAboutUS() async {
    try {
      http.Response response = await http.post(Uri.parse(aboutUsURL));
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        about_us = jsonData['data']['about_us'];
        facebook = jsonData['data']['facebook'];
        youtube = jsonData['data']['youtube'];
        instagram = jsonData['data']['instagram'];
        tiktok = jsonData['data']['tiktok'];
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

    getAboutUS();
  }

  @override
  Widget build(BuildContext context ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: kWhite,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: appbarcolor,
          fontSize: 26,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(color: kBlack),
        leading: appBarIcon(context),
      ),
      body: loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Column(
                children: [
                  (about_us == null)
                      ? const Center(
                          child: Text('No data added yet'),
                        )
                      : showHtmlWidget(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06),
                    child: Row(
                      children: [
                        (facebook == null || facebook.toString().isEmpty)
                            ? const SizedBox()
                            : Expanded(
                                child: InkWell(
                                  onTap: (){
                                    openExternalLink(facebook.toString() , 'Facebook');
                                  },
                                  child: Image.asset(
                                  'assets/images/facebook.png',
                                  width: 45,
                                  height: 45,
                              ),
                                )),
                        (youtube == null  || youtube.toString().isEmpty )
                            ? const SizedBox()
                            : Expanded(
                                child: InkWell(
                                  onTap: (){
                                    openExternalLink(youtube.toString() , 'Youtube');
                                  },
                                  child: Image.asset(
                                  'assets/images/youtube.png',
                                  width: 45,
                                  height: 45,
                              ),
                                )),
                        (instagram == null  || instagram.toString().isEmpty )
                            ? const SizedBox()
                            : Expanded(
                                child: InkWell(
                                  onTap: (){
                                    openExternalLink(instagram.toString() , 'Instagram');
                                  },
                                  child: Image.asset(
                                  'assets/images/instagram.png',
                                  width: 45,
                                  height: 45,
                              ),
                                )),
                        (tiktok == null  || tiktok.toString().isEmpty )
                            ? const SizedBox()
                            : Expanded(
                                child: InkWell(
                                  onTap: (){
                                    openExternalLink(tiktok.toString() , 'Tiktok');
                                  },
                                  child: Image.asset(
                                  'assets/images/tiktok.png',
                                  width: 45,
                                  height: 45,
                              ),
                                )),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget showHtmlWidget() {
    return HtmlWidget(
      about_us.toString(),
      customStylesBuilder: (element) {
        if (element.classes.contains('foo')) {
          return {'color': 'red'};
        }
        return null;
      },
      customWidgetBuilder: (element) {
        if (element.attributes['foo'] == 'bar') {
          return const Center(
            child: Text('No Privacy Policy added'),
          );
        }
        return null;
      },
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CircularProgressIndicator(),
      onTapUrl: (url) async {
        print('url::::::$url');
        return true;
      },
      renderMode: RenderMode.column,
      textStyle: const TextStyle(fontSize: 14),
    );
  }

  openExternalLink(String link , String msg) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('can not launch url::::$link');
      showSnackMessage(context, '$msg not installed');
    }
  }

}
