import 'package:flutter/material.dart';


class TransactionType {
  final Icon? icon;
  final String? title;

  TransactionType({this.icon, this.title});


}

List<TransactionType> transactionTypes = [
  TransactionType(
    icon: Icon(Icons.arrow_upward_rounded,),
    title: "Pay or Send",//TODO: For sending to another user
  ),
  TransactionType(
    icon: Icon(Icons.add),
    title: "Add Money",
  ),
  TransactionType(
    icon: Icon(Icons.arrow_downward_rounded),
    title: "Get Payment",
  ),
  TransactionType(
    icon: Icon(Icons.receipt),
    title: "Withdraw",
  ),
];