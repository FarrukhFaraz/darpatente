import 'package:flutter/material.dart';

import '../Utils/colors.dart';



class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Widget prefixIcon;
  final bool isObscure;
  final Widget? suffixIcon;

  final Function(String?)? validator;
  final TextInputType keyboardType;


  const AppTextField(
      {Key? key,
      required this.textController,
      required this.suffixIcon,
      required this.hintText,
      required this.prefixIcon,
      this.validator,
      required this.keyboardType,
      this.isObscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: TextFormField(
        keyboardType: keyboardType,
        style: TextStyle(color: kBlack),
        autofocus: false,
        autocorrect: false,
        controller: textController,
        validator: (String? value) => validator!(value),
        obscureText: isObscure ? true : false,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: yellow800, width: 2.2)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: hintText,
            hintStyle: TextStyle(color: kBlack)),
      ),
    );
  }
}
