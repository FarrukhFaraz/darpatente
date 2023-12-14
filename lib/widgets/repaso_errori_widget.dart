import 'package:flutter/material.dart';

import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget repasoErroriWidget(
  BuildContext context,
  int trueQuestion,
  int falseQuestion,
  int remainingQuestion,
  dynamic model,
  dynamic selectedChaptersId,
  var selected,
) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.900,
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.symmetric(horizontal: 6),
    height: MediaQuery.of(context).size.height * 0.140,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1), color: appbarcolor),
    child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: model.chapter!.pic != null
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: cacheImage(context,
                          "${imageBaseURL}chapters/${model.chapter!.pic}"),
                    )
                  : const SizedBox(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 6),
                    height: MediaQuery.of(context).size.height * 0.044,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      model.chapter!.name.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kWhite),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.044,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '${model.chapter!.description}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kWhite),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        top: 6,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 10,
                        color: kWhite,
                        child: Row(
                          children: [
                            Expanded(
                                flex: trueQuestion,
                                child: Container(
                                  color: kgreen,
                                )),
                            Expanded(
                                flex: falseQuestion,
                                child: Container(
                                  color: kRed,
                                )),
                            Expanded(
                                flex: remainingQuestion,
                                child: Container(
                                  color: kWhite,
                                )),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 26, top: 10),
              child: Transform.scale(
                  scale: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 22),
                      GestureDetector(
                          onTap: () {
                            selected(int.parse(model.chapter!.id.toString()),
                                model.chapter!.bookId.toString());
                          },
                          child: Container(
                            // color: Colors.green,
                            height: 17,
                            width: 17,
                            decoration: BoxDecoration(
                                color: selectedChaptersId
                                        .contains(model.chapter!.id)
                                    ? kWhite
                                    : appbarcolor,
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(34)),
                            child: selectedChaptersId
                                    .contains(model.chapter!.id)
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    height: 16,
                                    width: 16,
                                  )
                                : Container(
                                    margin: const EdgeInsets.all(2),
                                    height: 12,
                                    width: 12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: appbarcolor,
                                        border: Border.all(
                                          color: appbarcolor,
                                        )),
                                  ),
                          )),
                    ],
                  )),
            ),
          ],
        )),
  );
}
