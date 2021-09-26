
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/pages/searchPage.dart';
import 'package:lumicash/pages/uploadPage.dart';
import 'package:lumicash/widgets/postLayout.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'cart.dart';
import 'category2List.dart';
import 'categoryPage.dart';


class PhysicalStore extends StatefulWidget {
  const PhysicalStore({Key? key}) : super(key: key);

  @override
  _PhysicalStoreState createState() => _PhysicalStoreState();
}

class _PhysicalStoreState extends State<PhysicalStore> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    bool isBusiness = AppConfig.account!.accountType == "business";

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        if(sizeInfo.isDesktop)
          {
            return Scaffold(
              floatingActionButton: isBusiness ? FloatingActionButton(
                onPressed: () {

                  //List<File> imageList = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ChoosePhotos()));

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage()));
                },
                child: Icon(Icons.upload, color: Colors.white,),
              ) : Container(),
              appBar: AppBar(
                //elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Container(
                  width: size.width,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: ListTile(
                      leading: Icon(Icons.search_rounded, color: Colors.grey,),
                      title: TextFormField(
                        controller: searchController,
                        cursorColor: Theme.of(context).primaryColor,
                        onFieldSubmitted: (String value) {
                          if(value.isNotEmpty)
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(value: value,)));
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Search Product, brand, etc",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey,),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
                        },
                      ),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Physical Store", style: Theme.of(context).textTheme.headline5,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          gradient: AppConfig.gradient,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("A Summer Surprise", style: Theme.of(context).textTheme.headline6!.apply(color: Colors.white),),
                              Text("Cashback 20%", style: Theme.of(context).textTheme.headline4!.apply(color: Colors.white,),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const DisplayCategories(),
                    const DisplayProducts()
                  ],
                ),
              ),
            );
          }

        return Scaffold(
          floatingActionButton: isBusiness ? FloatingActionButton(
            onPressed: () {

              //List<File> imageList = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ChoosePhotos()));

              Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage()));
            },
            child: Icon(Icons.upload, color: Colors.white,),
          ) : Container(),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Container(
              width: size.width,
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: ListTile(
                  leading: Icon(Icons.search_rounded, color: Colors.grey,),
                  title: TextFormField(
                    controller: searchController,
                    cursorColor: Theme.of(context).primaryColor,
                    onFieldSubmitted: (String value) {
                      if(value.isNotEmpty)
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(value: value,)));
                      }
                    },
                    decoration: InputDecoration.collapsed(
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Search Product, brand, etc",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey,),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
                    },
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: AppConfig.gradient,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("A Summer Surprise", style: TextStyle(color: Colors.white),),
                          Text("Cashback 20%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
                        ],
                      ),
                    ),
                  ),
                ),
                DisplayCategories(),
                DisplayProducts()
              ],
            ),
          ),
        );
      },
    );
  }
}


class DisplayCategories extends StatelessWidget {
  const DisplayCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if(sizeInfo.isDesktop)
          {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Special for you", style: Theme.of(context).textTheme.headline5,),
                      InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Category2List()));
                          },
                          child: Text("See All", style: TextStyle(color: Colors.grey),))
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  width: size.width,
                  height: size.height*0.35,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: category2s.length,
                    itemBuilder: (context, index) {
                      Category2 category = category2s[index];

                      return category.title == "More"
                          ? Container()
                          : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(builder: (context)=> CategoryPage(category: category,));

                            Navigator.push(context, route);
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: size.width*0.4,
                                height: size.height*0.35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                        image: AssetImage(category.imageUrl!),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Positioned(
                                top: 0.0,
                                left: 0.0,
                                right: 0.0,
                                bottom: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20.0,
                                left: 20.0,
                                child: Text(category.title!, style: Theme.of(context).textTheme.headline6!.apply(color: Colors.white),),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Special for you", style: TextStyle(fontWeight: FontWeight.w800),),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Category2List()));
                      },
                      child: Text("See All", style: TextStyle(color: Colors.grey),))
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: size.width,
              height: size.height*0.15,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: category2s.length,
                itemBuilder: (context, index) {
                  Category2 category = category2s[index];

                  return category.title == "More"
                      ? Container()
                      : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(builder: (context)=> CategoryPage(category: category,));

                        Navigator.push(context, route);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: size.width*0.6,
                            height: size.height*0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: AssetImage(category.imageUrl!),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            left: 0.0,
                            right: 0.0,
                            bottom: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20.0,
                            left: 20.0,
                            child: Text(category.title!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}


class DisplayProducts extends StatefulWidget {
  const DisplayProducts({Key? key}) : super(key: key);

  @override
  _DisplayProductsState createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        if(sizeInfo.isDesktop)
          {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                  child: Text("Popular Products", style: Theme.of(context).textTheme.headline5,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')//.where("category", isEqualTo: widget.category.title)
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
                          physics: NeverScrollableScrollPhysics(),
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
              ],
            );
          }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15.0),
              child: Text("Popular Products", style: TextStyle(fontWeight: FontWeight.w800),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')//.where("category", isEqualTo: widget.category.title)
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
                      physics: NeverScrollableScrollPhysics(),
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
          ],
        );
      },
    );
  }
}

