import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

import '../../Utils/colors.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool loader = true;
  var privacy_policy;

  getPrivacyPolicy() async {
    try {
      http.Response response = await http.post(Uri.parse(privacyPolicyURL));
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        privacy_policy = jsonData['data']['privacy_policy'];
        print(privacy_policy);
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

    getPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        backgroundColor: kWhite,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: appbarcolor,
          fontSize: 26,
          fontWeight: FontWeight.w500,
        ),
        leading: appBarIcon(context),
        iconTheme: IconThemeData(color: kBlack),
      ),
      body: loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: privacy_policy == null || privacy_policy.toString().isEmpty
                  ? const Center(
                      child: Text('No Privacy Policy added yet'),
                    )
                  : showHtmlWidget(),
            ),
    );
  }

  Widget showHtmlWidget() {
    print('privacy::::::::::::::::');
    return HtmlWidget(
      privacy_policy.toString(),
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
}
