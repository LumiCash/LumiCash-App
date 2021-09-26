import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/widgets/postLayout.dart';


class UserPosts extends StatefulWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: AppConfig.gradient
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products').where("publisherID", isEqualTo: AppConfig.account!.userID)
            .orderBy("timestamp", descending: true).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
          {
            return Container();
          }
          else
          {
            List<Product> products = [];

            snapshot.data!.docs.forEach((document) {
              Product product = Product.fromDocument(document);

              products.add(product);
            });

            return GridView.count(
              crossAxisCount: 2,
              physics: BouncingScrollPhysics(),
              //childAspectRatio: 2/3,
              shrinkWrap: true,
              children: List.generate(products.length, (index) {
                return ProductLayout(product: products[index], isCoupon: false,);
              }),
            );
          }
        },
      ),
    );
  }
}
