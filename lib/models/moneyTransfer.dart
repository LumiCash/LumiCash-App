
import 'package:cloud_firestore/cloud_firestore.dart';

class MoneyTransfer {
  final String? imageUrl;
  final String? transferID;
  final String? title;
  final String? transferType;
  final int? timestamp;
  final String? description;
  final int? amount;

  MoneyTransfer(
      {this.imageUrl,
      this.transferID,
      this.title,
      this.transferType,
      this.timestamp,
      this.description,
      this.amount});

  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      "transferID": transferID,
      "title": title,
      "transferType": transferType,
      "timestamp": timestamp,
      "description": description,
      "amount": amount,
    };
  }

  factory MoneyTransfer.fromDocument(DocumentSnapshot doc) {
    return MoneyTransfer(
      imageUrl: doc["imageUrl"],
      transferID: doc["transferID"],
      title: doc["title"],
      transferType: doc["transferType"],
      timestamp: doc["timestamp"],
      description: doc["description"],
      amount: doc["amount"]
    );
  }

}