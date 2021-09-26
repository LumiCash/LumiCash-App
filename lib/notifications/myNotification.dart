
import 'package:firebase_messaging/firebase_messaging.dart';

class MyNotification {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getToken() async {
    String? token = await firebaseMessaging.getToken();

    return token!;
  }

}