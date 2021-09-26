import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/widgets/postLayout.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  displayCartList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users').doc(AppConfig.account!.userID).collection("cart")
          //.orderBy("timestamp", descending: true)
          .get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          {
            return Container();
          }
        else
          {
            List<Product> productList = [];

            snapshot.data!.docs.forEach((element) {
              Product product = Product.fromDocument(element);

              productList.add(product);
            });

            return GridView.count(
              crossAxisCount: 2,
              //childAspectRatio: 2/3,
              shrinkWrap: true,
              children: List.generate(productList.length, (index) {
                return ProductLayout(product: productList[index], isCoupon: false,);
              }),
            );
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppConfig.gradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: displayCartList(),
        // child: StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance
        //       .collection('users').doc(AppConfig.account.userID).collection("cart")
        //       .orderBy("timestamp", descending: true).snapshots(),
        //   builder: (context, snapshot) {
        //     if(!snapshot.hasData)
        //     {
        //       return Container();
        //     }
        //     else
        //     {
        //       List<Product> products = [];
        //
        //       snapshot.data.docs.forEach((document) {
        //         Product product = Product.fromDocument(document);
        //
        //         products.add(product);
        //       });
        //
        //       return GridView.count(
        //         crossAxisCount: 2,
        //         childAspectRatio: 2/3,
        //         shrinkWrap: true,
        //         children: List.generate(products.length, (index) {
        //           return ProductLayout(product: products[index],);
        //         }),
        //       );
        //     }
        //   },
        // ),
      ),
    );
  }
}
