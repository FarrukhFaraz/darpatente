import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newdarpetente/widgets/app_bar_vocabulary_widget.dart';

import '../../Utils/colors.dart';
import '../../Utils/messages.dart';
import '../../Utils/url.dart';
import '../../widgets/app_bar_icon.dart';
import '../../widgets/app_bar_image.dart';
import '../../widgets/audio.dart';
import '../../widgets/cache_image.dart';
import '../../widgets/vocabulary_clickable_text.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen(
      {super.key,
      required this.questionNo,
      required this.topicImage,
      required this.question,
      required this.questionImage,
      required this.voice});

  final String questionNo;
  final String topicImage;
  final String question;
  final String questionImage;
  final String voice;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool showVocabulary = false;

  bool isPlay = false;

  onChange(val) {
    setState(() {
      showVocabulary = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // player!.dispose();
        Timer(const Duration(milliseconds: 100), () {
          Navigator.pop(context);
        });

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.058,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // player!.dispose();
                            Timer(
                                const Duration(
                                  milliseconds: 100,
                                ), () {
                              Navigator.pop(context);
                            });
                          },
                          child: appBarIcon(context),
                        ),
                        appBarImage(context),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.height,
                      color: kblues,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.066,
                            width: MediaQuery.of(context).size.width,
                            color: kblues,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex: 6, child: Text('')),
                                Center(
                                    child: Text(
                                  widget.questionNo.toString().toString(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: kWhite),
                                )),
                                const Expanded(flex: 4, child: Text('')),
                                appBarVocabularyWidget(
                                    context, 'paid', showVocabulary, onChange),
                                const SizedBox(width: 3),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                              color: kWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    margin: const EdgeInsets.only(top: 4),
                                    child: (widget.topicImage.isEmpty ||
                                            widget.topicImage == 'null')
                                        ? const SizedBox()
                                        : cacheImage(context,
                                            "${imageBaseURL}topics/${widget.topicImage.toString()}"),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: showVocabulary
                                            ? VocabularyClickableText(
                                                text: widget.question,
                                              )
                                            : Text(
                                                widget.question,
                                                maxLines: 50,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: kBlack,
                                                    height: 1.4),
                                              ),
                                      )),
                                  const SizedBox(height: 10),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      margin: const EdgeInsets.only(top: 4),
                                      child: widget.questionImage == 'null' ||
                                              widget.questionImage.isEmpty
                                          ? const SizedBox()
                                          : cacheImage(context,
                                              '${imageBaseURL}topics/${widget.questionImage.toString()}')),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isPlay
                  ? widget.voice == 'null'
                      ? const SizedBox()
                      : MyAudion(url: widget.voice)
                  : Container(
                      constraints: const BoxConstraints(maxHeight: 40),
                      margin: const EdgeInsets.only(left: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (widget.voice != 'null') {
                            setState(() {
                              isPlay = true;
                            });
                          } else {
                            showSnackMessage(context, 'coming soon');
                          }
                        },
                        child: Image.asset(
                          'assets/images/sounds.png',
                          height: 40,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
