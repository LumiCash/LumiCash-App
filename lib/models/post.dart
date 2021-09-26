import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

class Product {
  final String? productId;
  final String? title;
  final String? imageUrl;
  final String? price;
  final String? description;
  final int? count;
  final int? period;
  final String? category;
  final int? timestamp;
  final String? searchKey;
  final String? link;
  final String? publisherID;

  Product( {this.title,
    this.productId,
    this.publisherID,
      this.imageUrl,
    this.category,
    this.searchKey,
      this.price,
    this.link,
      this.description,
      this.period,
    this.timestamp,
      this.count});

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "title": title,
      "imageUrl": imageUrl,
      "price": price,
      "description": description,
      "period": period,
      "count": count,
      "category": category,
      "timestamp": timestamp,
      "searchKey": searchKey,
      "link": link,
      "publisherID": publisherID
    };
  }

  factory Product.fromDocument(DocumentSnapshot doc) {

    return Product(
      productId: doc["productId"],
      title: doc["title"],
      imageUrl: doc["imageUrl"],
      price: doc["price"],
      description: doc["description"],
      period: doc["period"],
      count: doc["count"],
      category: doc["category"],
      timestamp: doc["timestamp"],
      searchKey: doc["searchKey"],
      link: doc["link"],
      publisherID: doc["publisherID"]
    );
  }

}