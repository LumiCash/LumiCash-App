import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lumicash/pages/homePage.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'Auth/login.dart';
import 'Config/config.dart';
import 'ads/ads_state.dart';
import 'models/account.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // final initFuture = MobileAds.instance.initialize();
  // final adState = AdState(initFuture);

  MpesaFlutterPlugin.setConsumerKey(AppConfig.mPesaConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(AppConfig.mPesaConsumerSecret);

  runApp(MyApp());

  // runApp(Provider.value(
  //   value: adState,
  //   builder: (context, child) => MyApp(),
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done)
            {
              return SplashScreen();
            }

          return Scaffold();
        },
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
    
    displaySplash();
  }

  displaySplash() async {
    Timer(Duration(seconds: 4), () async {

      auth.authStateChanges()
          .listen((User? user) async {
        if (user == null) {
          Route route = MaterialPageRoute(builder: (context)=> LoginPage());
          Navigator.pushReplacement(context, route);
        } else {

          await FirebaseFirestore.instance.collection("users")
              .doc(user.uid).get().then((value) async {

                if(value.data()!.containsKey("accountType"))
                  {
                    Account account = Account.fromDocument(value);

                    setState(() {
                      AppConfig.account = account;
                    });
                  }
                else
                  {
                    await value.reference.set({
                      "accountType": "individual",
                    }, SetOptions(merge: true));

                    Account account = Account.fromDocument(value);

                    setState(() {
                      AppConfig.account = account;
                    });
                  }
          });


          Route route = MaterialPageRoute(builder: (context)=> HomePage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("assets/splash.jpg"),
                //   fit: BoxFit.cover
                // )
              ),
            ),
            Center(
              child: ResponsiveBuilder(
                builder: (context, sizeInfo) {

                  return AnimatedContainer(
                    duration: Duration(seconds: 4),
                    curve: Curves.easeIn,
                    height: sizeInfo.isDesktop ? size.height*0.4 : size.width * 0.6,
                    width: sizeInfo.isDesktop ?  size.height*0.4 : size.width * 0.6,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppConfig.appLogo),
                            fit: BoxFit.contain
                        )
                    ),
                  );
                },
              )
            ),
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Coupons & Cashback Repository", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5.0,),
                  //circularProgress()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

