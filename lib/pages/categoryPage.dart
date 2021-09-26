import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/widgets/postLayout.dart';

class CategoryPage extends StatefulWidget {

  final Category2? category;

  const CategoryPage({Key? key, this.category}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category!.title!),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppConfig.gradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products').where("category", isEqualTo: widget.category!.title)
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
