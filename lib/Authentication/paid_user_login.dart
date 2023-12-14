import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../Utils/Navigator.dart';
import '../Utils/Network/check_connectivity.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../Utils/url.dart';
import '../language.dart';

class PaidUserLoginScreen extends StatefulWidget {
  const PaidUserLoginScreen({Key? key}) : super(key: key);

  @override
  State<PaidUserLoginScreen> createState() => _PaidUserLoginScreenState();
}

class _PaidUserLoginScreenState extends State<PaidUserLoginScreen> {
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
      loginApi();
    } else {
      showSnackMessage(context, "Please check your internet conncection");
    }
  }

  loginApi() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      'email': emailController.text.toString(),
      'password': passwordController.text.toString(),
      'imei_no': await UniqueIdentifier.serial,
      // 'imei_no': DeviceInfoService.info.identifier,
    };
    print(body);

    try {
      http.Response response =
          await http.post(Uri.parse(paidUserLoginUrl), body: body);

      var jsonData = jsonDecode(response.body);
      print(paidUserLoginUrl);
      print(jsonData);

      if (jsonData['status'] == 200) {
        setState(() {
          loader = false;
        });

        if (jsonData['user']['status'] == '0') {
          showSnackErrorMessage(context,
              'You are not a paid user\n Please login as a guest user' , 4);
        }
        else {
          var id = jsonData['user']['id'];
          var token = jsonData['token'];

          var mainCategoryId = jsonData['user']['book_id'];
          if (mainCategoryId != null) {
            prefs.setString('MainCategoryId', mainCategoryId.toString());
          }
          prefs.setString('id', id.toString());
          prefs.setString('token', token.toString());
          prefs.setString('userType', 'paid');
          prefs.setString('userToken', token.toString());
          showSnackMessage(context, 'Login Succefully');
          navRemove(context, const LanguageScreen());
        }
      } else if (jsonData['statusCode'] == 500) {
        setState(() {
          loader = false;
        });
        showSnackErrorMessage(context, jsonData['message'].toString() , 6);
      } else {
        setState(() {
          loader = false;
        });
        showSnackErrorMessage(context, '${jsonData['message']}' , 4);
      }
    } catch (e) {
      print(e);
      showSnackErrorMessage(context, "Something went wrong!\n$e" , 4);
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DeviceInfoService().init();
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
                GestureDetector(
                  onTap: () {
                    formValidate();
                  },
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
                            "Login",
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )
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
          Container(
            margin: const EdgeInsets.all(4),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: kBlack),
              autofocus: false,
              autocorrect: false,
              controller: emailController,
              validator: MultiValidator([
                RequiredValidator(errorText: "Required *"),
                EmailValidator(errorText: "Not a valid email")
              ]),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: yellow800, width: 2.2)),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: kBlack,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: kBlack)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            margin: const EdgeInsets.all(4),
            child: TextFormField(
              controller: passwordController,
              validator: RequiredValidator(errorText: "Required *"),
              style: TextStyle(color: kBlack),
              autofocus: false,
              autocorrect: false,
              obscureText: _isObscure,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: yellow800, width: 2.2)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: kBlack,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: kBlack,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: kBlack)),
            ),
          ),
        ],
      ),
    );
  }
}
