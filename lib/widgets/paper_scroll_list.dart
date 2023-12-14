import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Utils/colors.dart';
import '../widgets/question.dart';
import '../widgets/triangle_shape.dart';

Widget showPaperScrollList(
    BuildContext context,
    int selectedIndex,
    Color color,
    List<dynamic> list,
    ScrollController _scrollController,
    List<Question>? _questions,
    var onSelectedItemChanged) {
  return Container(
    // padding: const EdgeInsets.only(top: 10.2),
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        1,
      ),
      color: kblues,
    ),
    height: MediaQuery.of(context).size.height * 0.076,
    width: MediaQuery.of(context).size.width,
    child: RotatedBox(
      quarterTurns: 3,
      child: ListWheelScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        itemExtent: MediaQuery.of(context).size.height * 0.076,
        useMagnifier: false,
        perspective: 0.0001,
        clipBehavior: Clip.none,
        squeeze: 1,
        diameterRatio: RenderListWheelViewport.defaultDiameterRatio,
        children: List.generate(_questions!.length, (index) {
          return RotatedBox(
            quarterTurns: 1,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.016,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.044,
                    width: MediaQuery.of(context).size.width * 0.11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(width: 1, color: appbarcolor),
                      color: list[index].backGroundColor,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                            fontSize: 20,
                            color: index == selectedIndex ? color : kBlack),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: index == selectedIndex ? true : false,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child: CustomPaint(
                        size: const Size(14.5, 14.58),
                        painter: DrawTriangleShape(
                            index == selectedIndex ? Colors.white : kblues)),
                  ),
                ],
              ),
              // ),
            ),
          );
        }),
      ),
    ),
  );
}
