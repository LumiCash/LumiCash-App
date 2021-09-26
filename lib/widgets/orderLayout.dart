import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumicash/Config/timeConverter.dart';
import 'package:lumicash/models/moneyTransfer.dart';
import 'package:lumicash/pages/orderDetails.dart';


class OrderLayout extends StatelessWidget {

  final MoneyTransfer? transfer;

  const OrderLayout({Key? key, this.transfer}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (context)=> OrderDetails(
            transfer: transfer,
          ));

          Navigator.push(context, route);
        },
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(7.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 3.0,
                  blurRadius: 5.0,
                  offset: Offset(2.0, 2.0)
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("Order Num ${transfer!.timestamp!}", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),),
                  subtitle: Text(TimeConverter().readTimestamp(transfer!.timestamp!),),
                  trailing: Text("KES ${transfer!.amount.toString()}", style: TextStyle(fontWeight: FontWeight.w700),),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(transfer!.imageUrl!.split("|")[0]),
                  ),
                  title: Text(transfer!.title!, style: TextStyle(fontWeight: FontWeight.w700),),
                  subtitle: Text(transfer!.description!,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
