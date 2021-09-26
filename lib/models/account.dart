import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String? userID;
  String? username;
  String? phone;
  String? email;
  String? url;
  String? accountType;
  double? balance;//TODO: Should be more than KES 200 to withdraw

  Account({this.userID, this.balance, this.url, this.username, this.phone, this.accountType, this.email});

  factory Account.fromDocument(DocumentSnapshot doc) {
    return Account(
      username: doc['username'],
      phone: doc['phone'],
      email: doc['email'],
      url: doc["url"],
      userID: doc["userID"],
      accountType: doc["accountType"],
      balance: doc["balance"]
    );
  }

}