import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumicash/Auth/register.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/DialogBox/errorDialog.dart';
import 'package:lumicash/DialogBox/loadingDialog.dart';
import 'package:lumicash/models/account.dart';
import 'package:lumicash/pages/homePage.dart';
import 'package:lumicash/widgets/customTextField.dart';
import 'package:responsive_builder/responsive_builder.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();


  loginUser() async {
    await Firebase.initializeApp();

    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: 'Signing in...',);
        }
    );

    if(_emailTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty)
      {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailTextEditingController.text.trim(),
              password: _passwordTextEditingController.text.trim()
          );

          await FirebaseFirestore.instance.collection("users")
              .doc(userCredential.user!.uid).get().then((value) {

            Account account = Account.fromDocument(value);

            setState(() {
              AppConfig.account = account;
            });
          });

          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (context)=> HomePage());
          Navigator.pushReplacement(context, route);

        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(message: 'User not found',);
                }
            );
          } else if (e.code == 'wrong-password') {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(message: 'The password provided is wrong',);
                }
            );
          } else {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(message: e.toString(),);
                }
            );
          }
        }
      }
    else
      {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(message: "Fill the Required fields",);
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
                            Text("SIGN IN", style: TextStyle(color: Colors.blue),),
                            SizedBox(height: 10.0),
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
                            SizedBox(height: 30.0,),
                            InkWell(
                              splashColor: Theme.of(context).scaffoldBackgroundColor,
                              onTap: () => loginUser(),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    height: 40.0,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        gradient: AppConfig.gradient
                                    ),
                                    child: Center(child: Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))),
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Don't have an Account? "),
                                InkWell(
                                    onTap: () {
                                      Route route = MaterialPageRoute(builder: (context)=> RegisterPage());
                                      Navigator.pushReplacement(context, route);
                                    },
                                    child: Text("Register", style: TextStyle(color: Colors.blue),)),
                              ],
                            ),
                            // SizedBox(height: 30.0,),
                            // RaisedButton(
                            //   onPressed: () async {
                            //     await FirebaseFirestore.instance.collection("users").get()
                            //         .then((QuerySnapshot querySnapshot) {
                            //       querySnapshot.docs.forEach((document) {
                            //         document.reference.set({
                            //           "accountType": "individual",
                            //         }, SetOptions(merge: true));
                            //       });
                            //     });
                            //
                            //     Fluttertoast.showToast(msg: "Success");
                            //   },
                            //   child: Text("Update", style: TextStyle(color: Colors.white),),
                            //   color: Colors.blue,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(30.0),
                            //   ),
                            // )
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
            title: Text("SIGN IN", style: TextStyle(color: Colors.white),),
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
                SizedBox(height: 10.0,),
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
                SizedBox(height: 30.0,),
                InkWell(
                  splashColor: Theme.of(context).scaffoldBackgroundColor,
                  onTap: () => loginUser(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        height: 40.0,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            gradient: AppConfig.gradient
                        ),
                        child: Center(child: Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))),
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an Account? "),
                    InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(builder: (context)=> RegisterPage());
                          Navigator.pushReplacement(context, route);
                        },
                        child: Text("Register", style: TextStyle(color: Colors.blue),)),
                  ],
                ),
                // SizedBox(height: 30.0,),
                // RaisedButton(
                //   onPressed: () async {
                //     await FirebaseFirestore.instance.collection("users").get()
                //         .then((QuerySnapshot querySnapshot) {
                //       querySnapshot.docs.forEach((document) {
                //         document.reference.set({
                //           "accountType": "individual",
                //         }, SetOptions(merge: true));
                //       });
                //     });
                //
                //     Fluttertoast.showToast(msg: "Success");
                //   },
                //   child: Text("Update", style: TextStyle(color: Colors.white),),
                //   color: Colors.blue,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(30.0),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
