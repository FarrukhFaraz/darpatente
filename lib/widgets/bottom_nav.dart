import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/timer_provider.dart';
import '../Utils/colors.dart';

Widget showYesBottomNav(
  BuildContext context,
  String answer,
  bool questionAttempted,
  bool quizComplete,
  var playSound,
  var saveAnswer,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (!(context.read<TimerProvider>().secRemaining < 1)) {
              playSound();
            }
          },
          child: Opacity(
              opacity: (context.read<TimerProvider>().secRemaining < 1 ||
                      quizComplete)
                  ? 0.4
                  : 1.0,
              child: Image(
                height: MediaQuery.of(context).size.height * 0.064,
                image: const AssetImage('assets/images/sounds.png'),
              )),
        ),
        Opacity(
          opacity: (context.read<TimerProvider>().secRemaining < 1) ? 0.4 : 1.0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.170,
            height: MediaQuery.of(context).size.height * 0.060,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: kWhite,
                border: Border.all(width: 2, color: kblues)),
            child: Consumer<TimerProvider>(
              builder: (context, value, child) {
                return Text(
                  value.timeToDisplay.toString(),
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if ((context.read<TimerProvider>().secRemaining > 0 &&
                questionAttempted == false)) {
              bool? isAnswer;

              if (answer == 'vera') {
                isAnswer = true;
              } else {
                isAnswer = false;
              }
              saveAnswer(isAnswer, 'vera');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.220,
            height: MediaQuery.of(context).size.height * 0.060,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: (context.read<TimerProvider>().secRemaining < 1 ||
                        questionAttempted)
                    ? kWhite.withOpacity(0.4)
                    : kWhite,
                border: Border.all(width: 2, color: kblues)),
            child: Center(
                child: Text('vera',
                    style: TextStyle(
                        fontSize: 18,
                        color:
                            (context.read<TimerProvider>().secRemaining < 1 ||
                                    questionAttempted)
                                ? kBlack.withOpacity(0.4)
                                : kBlack))),
          ),
        ),
        InkWell(
          onTap: () {
            if ((context.read<TimerProvider>().secRemaining > 0 &&
                questionAttempted == false)) {
              bool? isAnswer;
              if (answer == 'falsa') {
                isAnswer = true;
              } else {
                isAnswer = false;
              }
              saveAnswer(isAnswer, 'falsa');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.220,
            height: MediaQuery.of(context).size.height * 0.060,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: (context.read<TimerProvider>().secRemaining < 1 ||
                        questionAttempted)
                    ? kWhite.withOpacity(0.4)
                    : kWhite,
                border: Border.all(width: 2, color: kblues)),
            child: Center(
                child: Text(
              'falsa',
              style: TextStyle(
                  fontSize: 18,
                  color: (context.read<TimerProvider>().secRemaining < 1 ||
                          questionAttempted)
                      ? kBlack.withOpacity(0.4)
                      : kBlack),
            )),
          ),
        ),
      ],
    ),
  );
}

Widget showNoBottomNav(
  BuildContext context,
  String answer,
  bool opVera,
  bool opFalsa,
  var playSound,
  var saveAnswer,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (!(context.read<TimerProvider>().secRemaining < 1)) {
              playSound();
            }
          },
          child: Opacity(
            opacity:
                (context.read<TimerProvider>().secRemaining < 1) ? 0.4 : 1.0,
            child: Image(
              height: MediaQuery.of(context).size.height * 0.064,
              image: const AssetImage('assets/images/sounds.png'),
            ),
          ),
        ),
        Opacity(
          opacity: (context.read<TimerProvider>().secRemaining < 1) ? 0.4 : 1.0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.170,
            height: MediaQuery.of(context).size.height * 0.060,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: kWhite,
                border: Border.all(width: 2, color: kblues)),
            child: Consumer<TimerProvider>(
              builder: (context, value, child) {
                return Text(
                  value.timeToDisplay.toString(),
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (!(context.read<TimerProvider>().secRemaining < 1)) {
              bool? isAnswer;

              if (answer == 'vera') {
                isAnswer = true;
              } else {
                isAnswer = false;
              }
              saveAnswer(isAnswer, 'vera');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.220,
            height: MediaQuery.of(context).size.height * 0.060,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: (context.read<TimerProvider>().secRemaining < 1)
                    ? kWhite.withOpacity(0.4)
                    : opVera
                        ? kLightBlue.withOpacity(0.4)
                        : kWhite,
                border: Border.all(width: 2, color: kblues)),
            child: Center(
                child: Text('vera',
                    style: TextStyle(
                        fontSize: 18,
                        color: (context.read<TimerProvider>().secRemaining < 1)
                            ? kBlack.withOpacity(0.4)
                            : kBlack))),
          ),
        ),
        InkWell(
          onTap: () {
            if (!(context.read<TimerProvider>().secRemaining < 1)) {
              bool? isAnswer;
              if (answer == 'falsa') {
                isAnswer = true;
              } else {
                isAnswer = false;
              }
              saveAnswer(isAnswer, 'falsa');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.220,
            height: MediaQuery.of(context).size.height * 0.060,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: (context.read<TimerProvider>().secRemaining < 1)
                    ? kWhite.withOpacity(0.4)
                    : opFalsa
                        ? kLightBlue.withOpacity(0.5)
                        : kWhite,
                border: Border.all(width: 2, color: kblues)),
            child: Center(
                child: Text(
              'falsa',
              style: TextStyle(
                  fontSize: 18,
                  color: (context.read<TimerProvider>().secRemaining < 1)
                      ? kBlack.withOpacity(0.4)
                      : kBlack),
            )),
          ),
        ),
      ],
    ),
  );
}
