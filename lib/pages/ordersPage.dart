import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/moneyTransfer.dart';
import 'package:lumicash/pages/searchPage.dart';
import 'package:lumicash/widgets/ProgressWidget.dart';
import 'package:lumicash/widgets/orderLayout.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'cart.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  List<String> tabList = [
    "All",
    "Recharges",
    "Tickets",
    "Bill",
    "Shopping",
    "Travel",
    "Deals"
  ];

  displayOrders(String orderType) {

    return StreamBuilder<QuerySnapshot>(
      stream: orderType == "All"
          ? FirebaseFirestore.instance.collection("users")
          .doc(AppConfig.account!.userID).collection("orders").orderBy("timestamp", descending: true).snapshots()
          : FirebaseFirestore.instance.collection("users")
          .doc(AppConfig.account!.userID).collection("orders").where("transferType", isEqualTo: orderType).orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          {
            return circularProgress();
          }
        else {
          List<MoneyTransfer> transfers = [];

          snapshot.data!.docs.forEach((document) {
            MoneyTransfer transfer = MoneyTransfer.fromDocument(document);

            transfers.add(transfer);
          });

          return ListView.builder(
            itemCount: transfers.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {

              return OrderLayout(transfer: transfers[index],);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if(sizeInfo.isDesktop)
          {
            return DefaultTabController(
              length: tabList.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  //flexibleSpace: Container(decoration: BoxDecoration(gradient: AppConfig.gradient),),
                  title: Text("My Orders", style: TextStyle(color: Colors.grey),),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(value: "",)));
                      },
                      icon: Icon(Icons.search, color: Colors.grey,),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
                      },
                      icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey,),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                    tabs: List.generate(tabList.length, (index) {
                      return Tab(text: tabList[index],);
                    }),
                  ),
                ),
                body: TabBarView(
                  children: List.generate(tabList.length, (index) {
                    return displayOrders(tabList[index]);
                  }),
                ),
              ),
            );
          }

        return DefaultTabController(
          length: tabList.length,
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(decoration: BoxDecoration(gradient: AppConfig.gradient),),
              title: Text("My Orders"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(value: "",)));
                  },
                  icon: Icon(Icons.search, color: Colors.white,),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
                  },
                  icon: Icon(Icons.shopping_cart_outlined, color: Colors.white,),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: List.generate(tabList.length, (index) {
                  return Tab(text: tabList[index],);
                }),
              ),
            ),
            body: TabBarView(
              children: List.generate(tabList.length, (index) {
                return displayOrders(tabList[index]);
              }),
            ),
          ),
        );
      },
    );
  }
}
