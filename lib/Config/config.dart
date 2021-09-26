
import 'package:flutter/material.dart';
import 'package:lumicash/models/account.dart';

class AppConfig {
  static final String appName = "LumiCash";
  static final String appIcon = "assets/icon.png";
  static final String appLogo = "assets/logo.png";
  static final Color appThemeColor = Color.fromRGBO(56, 151, 171, 1.0);
  static Account? account;

  static final LinearGradient gradient = LinearGradient(
    colors: [Colors.blue.shade700, Colors.lightBlueAccent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight
  );

  static final BoxDecoration buttonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    gradient: gradient
  );


  static final String mPesaConsumerKey = "gFhEipHACGHuVwgLOUG7zA6lCiHLprbn";
  static final String mPesaConsumerSecret = "kroYKD5E98hIVLgF";

  static final String vapidKey = "BAQy8qJw16hOxC9CCmyTkZx4Ibfw4JpxLVaCAxkOOwUzsnxPUUchUoTylr_adNmCUihE-dvEr42uSmANf2fiJYs";


}
