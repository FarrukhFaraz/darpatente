import 'package:flutter/material.dart';

import '../Utils/colors.dart';
import '../Utils/url.dart';
import 'cache_image.dart';

Widget progressWidget(BuildContext context, dynamic model) {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1), color: appbarcolor),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (model.chapter!.pic == null ||
                      model.chapter!.pic.toString().isEmpty ||
                      model.chapter!.pic.toString() == 'null')
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.2,
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: cacheImage(context,
                          "${imageBaseURL}chapters/${model.chapter!.pic}"),
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        textAlign: TextAlign.left,
                        '${model.chapter!.name}',
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: kWhite),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${model.chapter!.description}',
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kWhite),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                children: [
                  Text(
                    'Idoneo',
                    style: TextStyle(color: kWhite, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.044,
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kLightGreen),
                      child: Center(
                          child: Text(
                        '${model.pass}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ))),
                ],
              ),
            ),
            //SizedBox(width: MediaQuery.of(context).size.width*0.14,),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Text(
                    'Non Idoneo',
                    style: TextStyle(color: kWhite, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.044,
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: kRed),
                      child: Center(
                          child: Text(
                        '${model.fail}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ))),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

Widget progressTotalQuizWidget(BuildContext context, String papersPassedByBooks,
    String papersFailedByBooks) {
  return Column(
    children: [
      Container(
          margin: const EdgeInsets.only(top: 10),
          child: Center(
              child: Text(
            'Tutti i Quiz',
            style: TextStyle(
                fontSize: 28, color: kWhite, fontWeight: FontWeight.w500),
          ))),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.03,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Idoneo',
                style: TextStyle(color: kWhite, fontSize: 16),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.044,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kLightGreen),
                  child: Center(
                      child: Text(
                    papersPassedByBooks,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ))),
            ],
          ),
          Column(
            children: [
              Text(
                'Non Idoneo',
                style: TextStyle(color: kWhite, fontSize: 16),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.044,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: kRed),
                  child: Center(
                      child: Text(
                    papersFailedByBooks,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ))),
            ],
          )
        ],
      )
    ],
  );
}


Widget progressTotalQuizAttemptedWidget(dynamic model , String formattedDate){
  return Container(
    padding: const EdgeInsets.symmetric(
        vertical: 10, horizontal: 20),
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: appbarcolor),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          alignment: Alignment.topLeft,
          child: Text(
            '${model.quizeId}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kWhite),
          ),
        ),
        Container(
          margin:
          const EdgeInsets.only(bottom: 6),
          alignment: Alignment.bottomRight,
          child: Text(
            formattedDate,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kWhite),
          ),
        ),
      ],
    ),
  );
}
