import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/colors.dart';
import '../../Models/TruchiModel.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/Network/offline_checker.dart';
import '../../Utils/url.dart';

class TrueTruchiScreen extends StatefulWidget {
  const TrueTruchiScreen({super.key});

  @override
  State<TrueTruchiScreen> createState() => _TrueTruchiScreenState();
}

class _TrueTruchiScreenState extends State<TrueTruchiScreen> {
  bool loader = false;
  List<TruchiModel> list = [];

  bool checkConnection = false;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      callApi();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  callApi() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var catId = prefs.getString('MainCategoryId');
    Map body = {
      'cat_id':catId.toString(),
    };


    try {
      http.Response response = await http.post(Uri.parse(getTrueTruchiURL) , body: body);

      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          TruchiModel pos = TruchiModel();
          pos = TruchiModel.fromJson(obj);
          list.add(pos);
        }
        print(list.length);
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
                          'VERA',
                          style: TextStyle(
                            color: kgreen,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
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
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: loader
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                            height: MediaQuery.of(context).size.height *
                                0.890,
                            margin:
                                const EdgeInsets.only(left: 8, right: 8),
                            //decoration: BoxDecoration(border: Border.all(width: 1)),
                            child: list.isEmpty
                                ? const Center(
                                    child: Text('Nessun dato trovato'),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    padding: const EdgeInsets.only(bottom: 16),
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.044,
                                          // / margin: EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      4),
                                              color: kWhite),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            left: 10,
                                                            top: 4),
                                                    child: Text(
                                                      '${list[index].words}',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              appbarcolor),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            right: 10),
                                                    child: Text(
                                                      '${list[index].questionNo}',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: kgreen),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
          );
  }
}
