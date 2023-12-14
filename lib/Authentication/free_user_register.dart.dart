import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

import '../Utils/Navigator.dart';
import '../Utils/Network/check_connectivity.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../Utils/url.dart';
import '../widgets/app_text_field.dart';
import '../widgets/button_with_text.dart';
import 'free_user_login.dart.dart';

class FreeUserRegisterScreen extends StatefulWidget {
  const FreeUserRegisterScreen({Key? key}) : super(key: key);

  @override
  State<FreeUserRegisterScreen> createState() => _FreeUserRegisterScreenState();
}

class _FreeUserRegisterScreenState extends State<FreeUserRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loader = false;
  bool isLogin = false;

  bool _isObscure = true;

  bool checkConnection = false;

  formValidate(){
    print('${nameController.text}');
    print('${emailController.text}');
    print('${passwordController.text}');
    if(_formKey.currentState!.validate()){
      checkConnectivity();
    }
  }

  checkConnectivity()async{
    if (await connection()) {
      freeUserRegisterApi();
    } else {
      showSnackMessage(context, "Please check your internet connection");
    }
  }

  freeUserRegisterApi() async {
    setState(() {
      loader = true;
    });

    Map body = {
      'user_name': nameController.text.toString(),
      'email': emailController.text.toString(),
      'password': passwordController.text.toString(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(freeUserregisterUrl), body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == '200') {
        showSnackMessage(context, "Your account has been successfully created");
        navReplace(context, const FreeUserLoginScreen());
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, jsonData['message'].toString());
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Something went wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.height * 0.02,
            right: MediaQuery.of(context).size.height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                      )),
                ),
                Image.asset(
                  "assets/images/logo3.png",
                  height: MediaQuery.of(context).size.height * 0.32,
                ),
                formWidget(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                ButtonWithText(
                    loader: loader,
                    text: "Register",
                    onTap: () {
                      formValidate();
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?  "),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            keyboardType: TextInputType.text,
            textController: nameController,
            hintText: "Enter your name",
            prefixIcon: Icon(
              Icons.person_2_outlined,
              color: kBlack,
            ),
            validator: MultiValidator(
                [
                  RequiredValidator(errorText: 'Required *'),
                ]
            ),
            //empty container as a suffix icon does not show the hint text
            suffixIcon: const SizedBox(height: 2, width: 2),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          AppTextField(
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
            hintText: "Enter your Email",
            prefixIcon: Icon(
              Icons.email_outlined,
              color: kBlack,
            ),
            //empty container as a suffix icon does not show the hint text
            suffixIcon: const SizedBox(height: 2, width: 2),
            validator: MultiValidator([
              RequiredValidator(errorText: "Required *"),
              EmailValidator(errorText: "Not a valid Email")
            ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          AppTextField(
              keyboardType: TextInputType.text,
              textController: passwordController,
              hintText: "Enter your password",
              isObscure: _isObscure,
              validator: MultiValidator(
                  [
                    RequiredValidator(errorText: 'Required *'),
                  ]
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: kBlack,
              ),
              suffixIcon: IconButton(
                icon: _isObscure
                    ? Icon(
                        Icons.visibility_off,
                        color: kBlack,
                      )
                    : Icon(
                        Icons.visibility,
                        color: kBlack,
                      ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )),
        ],
      ),
    );
  }
}
