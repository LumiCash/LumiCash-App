import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/assistants/urlOpener.dart';
import 'package:lumicash/pages/scan.dart';
import 'package:lumicash/pages/userPosts.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../main.dart';
import 'editProfile.dart';
import 'favourites.dart';
import 'notificationPage.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: "rateMyApp_",
      // minDays: 3,
      // minLaunches: 4,
      // remindDays: 2,
      // remindLaunches: 4,
      googlePlayIdentifier: "com.lumicash");

  void rateApp() {
    _rateMyApp.init().then((_) {
        _rateMyApp.showStarRateDialog(
          context,
          ignoreNativeDialog: true,
          title: "Enjoying LumiCash App?",
          message:
          "If you like LumiCash app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.",
          dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20.0)),
          starRatingOptions: StarRatingOptions(
            borderColor: Colors.orangeAccent,),
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          actionsBuilder: (context, stars) {
            // Triggered when the user updates the star rating.
            return [
              // Return a list of actions (that will be shown at the bottom of the dialog).
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  if (stars != null) {
                    //TODO: Fix this

                    _rateMyApp.save();//.then((value) => Navigator.pop(context));

                    if (stars >= 4) {
                      _rateMyApp.launchStore();
                    } else {
                      Fluttertoast.showToast(
                          msg: "We appreciate your feedback");
                    }
                  }
                  // print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                  // // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                  // // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                  await _rateMyApp
                      .callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                },
              ),
            ];
          },
        );
    });
  }

  ImageProvider<Object>? displayImage() {
    String? url = AppConfig.account!.url;

    if(url == "")
      {
        return AssetImage("assets/profile.png");
      }
    else
      {
        return NetworkImage(url!);
      }
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height*0.3,
                  width: size.width,
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 20.0,
                  child: Container(
                    // height: size.height*0.3,
                    // width: size.width,
                    decoration: BoxDecoration(
                      gradient: AppConfig.gradient,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0))
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.0,
                  left: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 90.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45.0),
                          image: DecorationImage(
                            image: displayImage() as ImageProvider,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((AppConfig.account!.username)!, style: TextStyle(color: Colors.white, fontSize: 20.0),),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfilePage()));
                            },
                            child: Text("View Profile", style: TextStyle(color: Colors.white),),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            AppConfig.account!.accountType == "business"
                ? ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanPage()));
                    },
                    leading: Icon(Icons.qr_code_scanner_rounded, color: Colors.blue,),
                    title: Text("Scan QR Code", style: TextStyle(fontWeight: FontWeight.bold),),
            ) : Container(),
            AppConfig.account!.accountType == "business"
                ? ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserPosts()));
                    },
                    leading: Icon(Icons.photo, color: Colors.blue,),
                    title: Text("My Posts", style: TextStyle(fontWeight: FontWeight.bold),),
            ) : Container(),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> FavouritesPage()));
              },
              leading: Icon(Icons.favorite_border_rounded, color: Colors.blue,),
              title: Text("Favourites", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationPage()));
              },
              leading: Icon(Icons.notifications_active_outlined, color: Colors.blue,),
              title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: () {
                UrlOpener().launchURL("https://business.lumicashdeals.com/info/help");
              },
              leading: Icon(Icons.help_outline_rounded, color: Colors.blue,),
              title: Text("Need Help?", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: () {
                rateApp();
              },
              leading: Icon(Icons.star_rate_outlined, color: Colors.blue,),
              title: Text("Rate Us", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: () {
                UrlOpener().launchURL("https://business.lumicashdeals.com/info/terms_and_conditions");
              },
              leading: Icon(Icons.subject_rounded, color: Colors.blue,),
              title: Text("Terms & Conditions", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.translate_rounded, color: Colors.blue,),
              title: Text("Select Language", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SplashScreen()));
              },
              leading: Icon(Icons.logout, color: Colors.blue,),
              title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
