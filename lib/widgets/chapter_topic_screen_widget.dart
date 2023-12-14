import 'package:flutter/material.dart';

import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget chapterTopicScreenWidget(BuildContext context, dynamic model) {
  return Container(
    margin: const EdgeInsets.only(top: 6),
    height: MediaQuery.of(context).size.height * 0.145,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1), color: appbarcolor),
    child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 4),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.22,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: model.pic == null
                      ? const SizedBox()
                      : cacheImage(context,
                          "${imageBaseURL}chapters/${model.pic.toString()}"),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 6),
                  child: Text(
                    model.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kWhite),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 6),
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${model.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kWhite),
                  ),
                ),
              ],
            ),
          ],
        )),
  );
}
