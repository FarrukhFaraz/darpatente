import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/total_books_model.dart';
import 'Screens/darpatente_home.dart';
import 'Utils/Navigator.dart';
import 'Utils/Network/check_connectivity.dart';
import 'Utils/colors.dart';
import 'Utils/messages.dart';
import 'Utils/url.dart';

class MainCategoryScreen extends StatefulWidget {
  const MainCategoryScreen({super.key});

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {

  DateTime? currentBackPressTime;

  bool saveLoader = false;
  var userType;

  bool loader = true;
  bool checkConnection = false;


  List<TotalBooksModel> totalBooksList = <TotalBooksModel>[];

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = true;
      });
      getTotalBooksApi();
    } else {
      setState(() {
        checkConnection = true;
      });
      showSnackMessage(context, "Not connected to internet");
    }
  }

  getTotalBooksApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    print("userType::::$userType");

    try {
      http.Response response = await http.post(Uri.parse(totalBooksURL));

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      var categoryId = prefs.getString('MainCategoryId');
      print('category id::::$categoryId');

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          TotalBooksModel pos = TotalBooksModel();
          pos = TotalBooksModel.fromJson(obj);
          if (userType == 'free') {
            totalBooksList.add(pos);
          }else if(userType =='paid'){
            if(categoryId.toString() == pos.id.toString()){
              totalBooksList.add(pos);
            }
          }
        }
        print('list::::::${totalBooksList.length}');
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
    // getUserStatus();
    checkConnectivity();
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
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.058,
                    child: Row(
                      children: [
                        // InkWell(
                        //     onTap: () {
                        //       Navigator.pop(context);
                        //     },
                        //     child: const Padding(
                        //       padding: EdgeInsets.only(left: 10),
                        //       child: Icon(
                        //         Icons.arrow_back_ios,
                        //         size: 24,
                        //       ),
                        //     )),
                        Expanded(
                          child: Center(
                              child: Text(
                            'Dar Patente',
                            style: TextStyle(
                                color: appbarcolor,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                        Image(
                            height: MediaQuery.of(context).size.height * 0.09,
                            // fit: BoxFit.cover,
                            image: const AssetImage('assets/images/dar.png')),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: kblues.withOpacity(0.4),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                      vertical: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child:loader
                            ? const Center(child: CircularProgressIndicator())
                            : totalBooksList.isEmpty
                                ? const Center(
                                    child: Text('No Books are yet assigned to you'),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: totalBooksList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: InkWell(
                                          onTap: () async {
                                            // setState(() {
                                            //   saveLoader = true;
                                            // });
                                            var catId = totalBooksList[index]
                                                .id
                                                .toString();
                                            var catName = totalBooksList[index]
                                                .name
                                                .toString();

                                            print(catName);
                                            print(catId);
                                            // context.read<VocabularyProvider>().fetchAllImage(catId);

                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                'MainCategoryId', catId);
                                            prefs.setString(
                                                'MainCategoryName', catName);

                                            navRemove(
                                                context, const DarScreen());
                                            // Timer(const Duration(seconds: 4), (){
                                            //
                                            // });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.330,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.082,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: kWhite),
                                            child: Center(
                                                child: Text(
                                              '${totalBooksList[index].name}',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                  color: appbarcolor),
                                            )),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                  ),
                ],
              ),
            ),
            saveLoader
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.4),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kblues.withOpacity(0.95),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    ));
  }
}
