import 'package:flutter/material.dart';

import '../Models/chapter_model.dart';
import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget erroriFrequentatiWidget(BuildContext context, ChapterModel model) {
  return Container(
    margin: const EdgeInsets.only(top: 6),
    padding: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: MediaQuery.of(context).size.width * 0.03,
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1), color: appbarcolor),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (model.pic == null ||
                model.pic.toString() == 'null' ||
                model.pic.toString().isEmpty)
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                child: cacheImage(context,
                    '${imageBaseURL}chapters/${model.pic.toString()}')),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, color: kWhite),
                ),
                const SizedBox(height: 2),
                Text(
                  model.description.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: kWhite),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
