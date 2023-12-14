import 'package:flutter/material.dart';

import '../Utils/colors.dart';


class ButtonWithText extends StatelessWidget {
  const ButtonWithText(
      {super.key,
      required this.loader,
      required this.text,
      required this.onTap});

  final bool loader;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kBlack,
        ),
        child: loader
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                text,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
