import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Navigator.dart';
import '../Utils/Network/check_connectivity.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../Utils/url.dart';
import '../category_screen.dart';
import '../widgets/app_text_field.dart';
import '../widgets/button_with_text.dart';

class FreeUserLoginScreen extends StatefulWidget {
  const FreeUserLoginScreen({Key? key}) : super(key: key);

  @override
  State<FreeUserLoginScreen> createState() => _FreeUserLoginScreenState();
}

class _FreeUserLoginScreenState extends State<FreeUserLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loader = false;
  bool isLogin = false;

  bool _isObscure = true;

  formValidate() {
    if (_formKey.currentState!.validate()) {
      checkConnectivity();
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      freeUserLoginApi();
    } else {
      showSnackMessage(context, "Please check your internet connection");
    }
  }

  freeUserLoginApi() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      'email': emailController.text.toString(),
      'password': passwordController.text.toString(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(freeUserLoginUrl), body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == '200') {
        setState(() {
          loader = false;
        });

        if (jsonData['user']['status'] == '0') {
          var id = jsonData['user']['id'];
          var token = jsonData['token'];
          prefs.setString('id', id.toString());
          prefs.setString('token', token.toString());
          prefs.setString('userType', 'free');
          showSnackMessage(context, 'Login Successfully');
          navRemove(context, const MainCategoryScreen());
        } else if (jsonData['user']['status'] == '1') {
          showSnackMessage(context,
              'You are a paid user.\nPlease try to login as paid user');
        }
      } else if (response.statusCode == 500) {
        setState(() {
          loader = false;
        });
        showSnackMessage(context,
            "You already login on another device. If you want to login on this device. Please contact admin");
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Invalid Email/Password");
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
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  onTap: () {
                    formValidate();
                  },
                  loader: loader,
                  text: "Login",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?  "),
                    InkWell(
                        onTap: () {
                          // navPush(context, const FreeUserRegisterScreen());
                          showSnackMessage(context, 'Coming Soon...');
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 16),
                        )),
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
              validator: MultiValidator([
                RequiredValidator(errorText: 'Required *'),
              ]),
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
