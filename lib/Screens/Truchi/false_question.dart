import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/TruchiModel.dart';
import '../../../Utils/colors.dart';
import '../../Utils/Network/check_connectivity.dart';
import '../../Utils/Network/offline_checker.dart';
import '../../Utils/url.dart';

class FalseTruchiScreen extends StatefulWidget {
  const FalseTruchiScreen({super.key});

  @override
  State<FalseTruchiScreen> createState() => _FalseTruchiScreenState();
}

class _FalseTruchiScreenState extends State<FalseTruchiScreen> {
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
      http.Response response = await http.post(Uri.parse(getFalseTruchiURL) , body: body);

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
                //SizedBox(height: MediaQuery.of(context).size.height*0.02,),
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
                        'FALSA',
                        style: TextStyle(
                          color: kLightRed,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Image(
                            height: MediaQuery.of(context).size.height * 0.058,
                            image: const AssetImage('assets/images/dar.png')),
                      ),
                    ],
                  ),
                ),

                loader
                    ? Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: kblues,
                          ),
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 10),
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.044,
                                      // / margin: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: kWhite),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 4),
                                                child: Text(
                                                  '${list[index].words}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: appbarcolor),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Text(
                                                  '${list[index].questionNo}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: kRed),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //          Container(width: MediaQuery.of(context).size.width*0.8,
                                          //    height: MediaQuery.of(context).size.height*0.01,
                                          //    decoration: BoxDecoration(border: Border.all(width: 1,  color: kBlack,)),
                                          //  )
                                        ],
                                      ),
                                    ));
                              }),
                        ),
                      ),
              ],
            ),
          ));
  }
}
