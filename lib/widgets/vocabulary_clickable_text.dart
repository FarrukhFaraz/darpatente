import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/vocabulary_model.dart';
import '../Provider/vocabulary_provider.dart';
import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

class VocabularyClickableText extends StatefulWidget {
  final String text;
  final double fontSize;

  const VocabularyClickableText({
    super.key,
    required this.text,
    this.fontSize = 20.0,
  });

  @override
  State<VocabularyClickableText> createState() =>
      _VocabularyClickableTextState();
}

class _VocabularyClickableTextState extends State<VocabularyClickableText> {
  String sentence = '';

  getMeaning(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var language = prefs.getString('language');
    String meaning = '';
    List<VocabularyModel> list =
        context.read<VocabularyProvider>().vocabularyList;
    for (int i = 0; i < list.length; i++) {
      if (list[i].word.toString().toLowerCase() ==
          word.toString().toLowerCase()) {
        String image = list[i].picture.toString();

        if (language.toString() == 'urdu') {
          meaning = list[i].urdu.toString();
        } else if (language.toString() == 'hindi') {
          meaning = list[i].hindi.toString();
        } else if (language.toString() == 'punjabi') {
          meaning = list[i].punjabi.toString();
        } else if (language.toString() == 'bangali') {
          meaning = list[i].bangali.toString();
        } else if (language.toString() == 'forsi') {
          meaning = list[i].forsi.toString();
        }

        showWordMeaning(word, meaning, image);
        break;
      }
    }
  }

  showWordMeaning(String word, String meaning, String image) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              title: Container(
                color: kLightBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      word,
                      style: TextStyle(fontSize: 20, color: kWhite),
                    ),
                    const Expanded(child: Text('')),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close)),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.all(0),
              content: Container(
                height: image.isEmpty || image =='null'
                    ? MediaQuery.of(context).size.height * 0.1
                    : MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
                child: image.isEmpty || image == 'null'
                    ? Text(
                        meaning,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                meaning,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: cacheImage(
                                context, '${imageBaseURL}vocabulary/$image'),
                          ),
                        ],
                      ),
              ),
            );
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = widget.text;

    final provider = Provider.of<VocabularyProvider>(context);
    final wordsList = provider.vocabularyWords;

    wordsList.sort((a, b) => b.length.compareTo(a.length));

    String newSentence = sentence;
    List<String> newList = [];

    for (String wordInList in wordsList) {
      List<String> wo = wordInList.split(' ');
      List<String> words = newSentence.split(' ');
      bool isAll = wo.every((element) => words.contains(element));
      if (isAll) {
        newList.add(wordInList);
        newSentence = newSentence.replaceAll(wordInList, '');
      }
    }

    // final sortedList = sortListByPosition(sentence, newList);

    final sortedList = sortListBasedOnSentence(newList, sentence);
    //
    // print(sentence);
    // print(newList);
    // print(sortedList);

    List<InlineSpan> textSpans = [];

    for (String wordInSortedList in sortedList) {
      if (sentence.contains(wordInSortedList)) {
        final index = sentence.indexOf(wordInSortedList);
        final textSpan = TextSpan(
          text: sentence.substring(0, index),
          style: const TextStyle(color: Colors.black),
        );
        final highlightedSpan = TextSpan(
            text: sentence.substring(index, index + wordInSortedList.length),
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('words::::$wordInSortedList');
                getMeaning(wordInSortedList);
              });
        textSpans.add(textSpan);
        textSpans.add(highlightedSpan);
        sentence = sentence.substring(index + wordInSortedList.length);
      }
    }

    if (sentence.isNotEmpty) {
      final textSpan = TextSpan(
        text: sentence,
        style: const TextStyle(color: Colors.black),
      );
      textSpans.add(textSpan);
    }

    return RichText(
      text: TextSpan(
          children: textSpans,
          style: TextStyle(height: 1.4, fontSize: widget.fontSize)),
    );
  }

  // List<String> sortListByPosition(String sentence, List<String> wordsList) {
  //   // final regex = RegExp(r'\b\w+\b');
  //   // final words = regex.allMatches(sentence).map((match) => match.group(0)).toList();
  //   //
  //   // wordsList.sort((a, b) {
  //   //   final indexA = words.indexOf(a.split(' ').first);
  //   //   final indexB = words.indexOf(b.split(' ').first);
  //   //   return indexA.compareTo(indexB);
  //   // });
  //   List<String> newList = [];
  //
  //   List<String> sen = sentence.split(' ');
  //
  //   print(sentence);
  //   print(wordsList);
  //   for(int i=0; i<sen.length; i++){
  //
  //   }
  //
  //   return wordsList;
  // }

  List<String> sortListBasedOnSentence(
      List<String> inputList, String sentence) {
    List<String> sortedList = List<String>.from(inputList);

    // Custom comparator function to sort the list based on the word order in the sentence
    sortedList.sort((a, b) {
      int indexA = sentence.indexOf(a);
      int indexB = sentence.indexOf(b);
      return indexA.compareTo(indexB);
    });

    return sortedList;
  }
}
