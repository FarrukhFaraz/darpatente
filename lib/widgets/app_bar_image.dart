
import 'package:flutter/material.dart';

Widget appBarImage(BuildContext context){
  return Padding(
    padding: const EdgeInsets.only(right: 6),
    child: Image(
        height: MediaQuery.of(context).size.height * 0.09,
        image: const AssetImage('assets/images/dar.png')),
  );
}