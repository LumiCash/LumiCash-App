import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/widgets/postLayout.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppConfig.gradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users').doc(AppConfig.account!.userID).collection("favourites")
              //.orderBy("timestamp", descending: true)
              .snapshots(),
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
                //childAspectRatio: 2/3,
                shrinkWrap: true,
                children: List.generate(products.length, (index) {
                  return ProductLayout(product: products[index], isCoupon: false,);
                }),
              );
            }
          },
        ),
      ),
    );
  }
}
