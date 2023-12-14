import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/colors.dart';
import '../../Models/vocabulary_model.dart';
import '../../Utils/url.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  List<VocabularyModel> list = <VocabularyModel>[];
  List<VocabularyModel> vocabularyList = <VocabularyModel>[];

  bool loader = false;
  var urdu;

  var hindi;

  var punjabi;

  var bangali;

  var forsi;

  bool found = false;
  bool searching = false;
  var meaning;

  getList() async {
    setState(() {
      loader = true;
    });

    try {
      http.Response response = await http.get(Uri.parse(getVocabularyURL));
      print(response.body);

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (int i = 0; i < jsonData.length; i++) {
          VocabularyModel pos = VocabularyModel();
          pos = VocabularyModel.fromJson(jsonData[i]);
          vocabularyList.add(pos);
        }
      }
      print(vocabularyList.length);
    } catch (e) {
      print(e);
    }
    setState(() {
      loader = false;
    });
  }

  _onSubmit(String? val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var language = prefs.getString('language');
    print(language);

    setState(() {
      searching = true;
    });
    for (int i = 0; i < vocabularyList.length; i++) {
      if (vocabularyList[i].word!.toLowerCase().toString() ==
          val!.toLowerCase().toString()) {
        if (language.toString() == 'urdu') {
          meaning = vocabularyList[i].urdu;
        } else if (language.toString() == 'hindi') {
          meaning = vocabularyList[i].hindi;
        } else if (language.toString() == 'punjabi') {
          meaning = vocabularyList[i].punjabi;
        } else if (language.toString() == 'bangali') {
          meaning = vocabularyList[i].bangali;
        } else if (language.toString() == 'forsi') {
          meaning = vocabularyList[i].forsi;
        }
        found = true;

        break;
      } else {
        found = false;
      }
    }
    setState(() {});
  }

  _onChange(String? val) {
    setState(() {
      searching = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                    'Dar Patente',
                    style: TextStyle(
                        color: appbarcolor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
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

            loader
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator())
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: kblues,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.900,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 70),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kWhite,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                TextField(
                                  controller: _textEditingController,
                                  cursorColor: appbarcolor,
                                  onSubmitted: _onSubmit,
                                  onChanged: _onChange,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kLightBlue, width: 2),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    hintText: 'Scrivi la parola in Italiano',
                                    filled: true,
                                    //<-- SEE HERE
                                    fillColor: kLightBlue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                searching
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        child: found
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${_textEditingController.text} :    $meaning')
                                                ],
                                              )
                                            : const Text(
                                                'Nessun significato trovato'),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    ));
  }
}
