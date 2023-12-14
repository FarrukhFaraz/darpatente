import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import 'Authentication/paid_or_without_paid_screen.dart';
import 'Provider/vocabulary_provider.dart';
import 'Screens/darpatente_home.dart';
import 'Utils/Navigator.dart';
import 'Utils/messages.dart';
import 'Utils/url.dart';
import 'category_screen.dart';
import 'language.dart';
import 'Utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String appVersion = '';

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = 'V${packageInfo.version}';
    setState(() {});
  }

  splash(VocabularyProvider provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    if (id == null) {
      prefs.setString('from_splash', 'ok');
      Timer(const Duration(milliseconds: 3400), (() {
        navReplace(context, const PaidOrWithoutPaidScreen());
      }));
    } else {
      checkStatusAPi(context, id.toString(), provider);
    }
  }

  checkStatusAPi(
      BuildContext context, String id, VocabularyProvider provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map body = {
      'user_id': id.toString(),
      'imei_no': await UniqueIdentifier.serial,
    };

    print('body:::::$body');
    try {
      http.Response response =
          await http.post(Uri.parse(majorAPIURL), body: body);
      print("major api:::${response.body}");
      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        if (jsonData['user'] != null) {
          if (jsonData['user']['block_user'] == 0) {
            var status = jsonData['user']['status'];

            var mainCategoryId = jsonData['user']['book_id'];
            if (mainCategoryId == null) {
              prefs.remove('MainCategoryId');
            } else {
              prefs.setString('MainCategoryId', mainCategoryId.toString());
            }

            prefs.setString('from_splash', 'ok');

            List<dynamic> images = jsonData['images'];
            List<String> imageList = [];
            for (var image in images) {
              if (image != null) {
                imageList.add(image.toString());
              }
            }
            provider.cacheAllImage(imageList);

            getStatus(status.toString());
          } else {
            showSnackErrorMessage(context,
                'Your account has been blocked\n Please contact to admin', 6);
            prefs.clear();
            navReplace(context, const PaidOrWithoutPaidScreen());
          }
        }
      } else if (jsonData['status'] == 500) {
        showSnackErrorMessage(context, jsonData['message'].toString(), 6);
        prefs.clear();
        navReplace(context, const PaidOrWithoutPaidScreen());
      }
    } catch (e) {
      prefs.remove('from_splash');
      showSnackMessage(context, '$e');
      print("major api exception ::::$e");
      navReplace(context, const DarScreen());
    }
  }

  getStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (status == '0') {
      prefs.setString('userType', 'free');
    } else if (status == '1') {
      prefs.setString('userType', 'paid');
    }

    var token = prefs.getString('token');
    var language = prefs.getString('language');
    var categoryName = prefs.getString('MainCategoryName');
    var userStatus = prefs.getString('userType');
    if (userStatus.toString() == 'paid') {
      if (language == null) {
        navReplace(context, const LanguageScreen());
      } else {
        if (categoryName == null) {
          navReplace(context, const MainCategoryScreen());
        } else {
          navReplace(context, const DarScreen());
        }
      }
    } else {
      navReplace(context, const PaidOrWithoutPaidScreen());
    }
    prefs.setString('userToken', token.toString());
  }

  callProvider(VocabularyProvider provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var all = prefs.getString('allImages');
    if (all == null) {
      provider.fetchAllImage();
    }
    provider.fetchVocabulary();
  }

  @override
  void initState() {
    super.initState();
    getAppVersion();

    final provider = context.read<VocabularyProvider>();
    splash(provider);
    callProvider(provider);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            appVersion,
            style: TextStyle(fontSize: 16, color: kBlack),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/logo.png",
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
