import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../Utils/Navigator.dart';
import 'false_question.dart';
import 'true_question.dart';

class TrueFalseScreen extends StatefulWidget {
  const TrueFalseScreen({super.key});

  @override
  State<TrueFalseScreen> createState() => _TrueFalseScreenState();
}

class _TrueFalseScreenState extends State<TrueFalseScreen> {
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
                    ),
                  ),
                  Text(
                    'Dar Patente',
                    style: TextStyle(
                      color: appbarcolor,
                      fontSize: 20,
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

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: kblues,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 210),
                    child: InkWell(
                      onTap: () {
                        navPush(context, const TrueTruchiScreen());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.900,
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kWhite,
                        ),
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Column(
                              children: [
                                const Text(
                                  'Parole solo nei quiz',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Text(
                                  'VERA',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: kgreen),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      navPush(context, const FalseTruchiScreen());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.900,
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      height: MediaQuery.of(context).size.height * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kWhite,
                      ),
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Column(
                            children: [
                              const Text(
                                'Parole solo nei quiz',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'FALSA',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: kLightRed),
                              )
                            ],
                          )),
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
