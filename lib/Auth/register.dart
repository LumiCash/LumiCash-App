import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/DialogBox/errorDialog.dart';
import 'package:lumicash/DialogBox/loadingDialog.dart';
import 'package:lumicash/models/account.dart';
import 'package:lumicash/pages/homePage.dart';
import 'package:lumicash/widgets/customTextField.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'login.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _phoneTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  String userID = "";
  Account? account;

  beginRegistration() async {

    await Firebase.initializeApp();

    showDialog(
      context: context,
      builder: (c) {
        return LoadingAlertDialog(message: "Registering, Please wait...",);
      }
    );

    if(_usernameTextEditingController.text.isNotEmpty
        && _phoneTextEditingController.text.isNotEmpty
        && _emailTextEditingController.text.isNotEmpty
        && _passwordTextEditingController.text.isNotEmpty
        && _cPasswordTextEditingController.text.isNotEmpty
        && _cPasswordTextEditingController.text == _passwordTextEditingController.text)
      {
        try
            {
              await controlUserRegistration();

              await saveUserInfoToFirestore();

              Navigator.pop(context);
              Route route = MaterialPageRoute(builder: (context)=> HomePage());
              Navigator.pushReplacement(context, route);
            }
            catch (e) {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(message: e.toString(),);
                  }
              );
            }
      }
    else if(_cPasswordTextEditingController.text != _passwordTextEditingController.text)
      {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(message: 'Password does not match',);
            }
        );
      }
    else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: 'Fill in the Required fields!',);
          }
      );
    }
  }

  saveUserInfoToFirestore() async {
    await FirebaseFirestore.instance.collection("users").doc(userID).set({
      "username": _usernameTextEditingController.text.trim(),
      "phone": _phoneTextEditingController.text.trim(),
      "email": _emailTextEditingController.text.trim(),
      "url": "",
      "accountType": "individual",
    });
  }

  controlUserRegistration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim()
      );

      setState(() {
        AppConfig.account = Account(
          username: _usernameTextEditingController.text.trim(),
          userID: userCredential.user!.uid,
          email: _emailTextEditingController.text.trim(),
          phone: _phoneTextEditingController.text.trim(),
          url: ""
        );
        userID = userCredential.user!.uid;
      });

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(message: 'The password provided is too weak.',);
            }
        );
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(message: 'The account already exists for that email.',);
            }
        );
      }
    } catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: e.toString(),);
          }
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if(sizeInfo.isDesktop)
          {
            return Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: size.height,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/login.jpg"),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        child: Container(color: Colors.black45,),
                      ),
                      Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          child: Center(
                            child: Text(AppConfig.appName,
                              style: TextStyle(
                                  color: AppConfig.appThemeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width*0.05
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10.0,),
                            Text("SIGN UP", style: TextStyle(color: Colors.blue),),
                            SizedBox(height: 10.0),
                            CustomTextField(
                              controller: _usernameTextEditingController,
                              isObscure: false,
                              hintText: "Username",
                              data: Icons.person,
                            ),
                            CustomTextField(
                              controller: _phoneTextEditingController,
                              isObscure: false,
                              hintText: "Phone",
                              data: Icons.phone_android_outlined,
                            ),
                            CustomTextField(
                              controller: _emailTextEditingController,
                              isObscure: false,
                              hintText: "Email",
                              data: Icons.email_outlined,
                            ),
                            CustomTextField(
                              controller: _passwordTextEditingController,
                              isObscure: true,
                              hintText: "Password",
                              data: Icons.lock_outline_rounded,
                            ),
                            CustomTextField(
                              controller: _cPasswordTextEditingController,
                              isObscure: true,
                              hintText: "Confirm Password",
                              data: Icons.lock_outline_rounded,
                            ),
                            SizedBox(height: 30.0,),
                            InkWell(
                              splashColor: Theme.of(context).scaffoldBackgroundColor,
                              onTap: () => beginRegistration(),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    height: 40.0,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        gradient: AppConfig.gradient
                                    ),
                                    child: Center(child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))),
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Already have an Account? "),
                                InkWell(
                                    onTap: () {
                                      Route route = MaterialPageRoute(builder: (context)=> LoginPage());
                                      Navigator.pushReplacement(context, route);
                                    },
                                    child: Text("Login", style: TextStyle(color: Colors.blue),)),
                              ],
                            ),
                            SizedBox(height: 20.0,),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text("SIGN UP", style: TextStyle(color: Colors.white),),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: size.height * 0.3,
                      width: size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/login.jpg"),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      child: Container(color: Colors.black45,),
                    ),
                    Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        child: Center(
                          child: Text(AppConfig.appName,
                            style: TextStyle(color: AppConfig.appThemeColor, fontWeight: FontWeight.bold,
                                fontSize: size.width*0.05),),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                CustomTextField(
                  controller: _usernameTextEditingController,
                  isObscure: false,
                  hintText: "Username",
                  data: Icons.person,
                ),
                CustomTextField(
                  controller: _phoneTextEditingController,
                  isObscure: false,
                  hintText: "Phone",
                  data: Icons.phone_android_outlined,
                ),
                CustomTextField(
                  controller: _emailTextEditingController,
                  isObscure: false,
                  hintText: "Email",
                  data: Icons.email_outlined,
                ),
                CustomTextField(
                  controller: _passwordTextEditingController,
                  isObscure: true,
                  hintText: "Password",
                  data: Icons.lock_outline_rounded,
                ),
                CustomTextField(
                  controller: _cPasswordTextEditingController,
                  isObscure: true,
                  hintText: "Confirm Password",
                  data: Icons.lock_outline_rounded,
                ),
                SizedBox(height: 30.0,),
                InkWell(
                  splashColor: Theme.of(context).scaffoldBackgroundColor,
                  onTap: () => beginRegistration(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        height: 40.0,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            gradient: AppConfig.gradient
                        ),
                        child: Center(child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))),
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Already have an Account? "),
                    InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(builder: (context)=> LoginPage());
                          Navigator.pushReplacement(context, route);
                        },
                        child: Text("Login", style: TextStyle(color: Colors.blue),)),
                  ],
                ),
                SizedBox(height: 20.0,),
              ],
            ),
          ),
        );
      },
    );
  }
}
