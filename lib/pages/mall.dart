import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/ads/ads_state.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/pages/searchPage.dart';
import 'package:lumicash/widgets/category2Widget.dart';
import 'package:lumicash/widgets/postLayout.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'cart.dart';


class MallPage extends StatefulWidget {

  @override
  _MallPageState createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {

  TextEditingController searchController = TextEditingController();
  //BannerAd? banner;


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        if(sizeInfo.isDesktop)
          {
            return Scaffold(
              appBar: AppBar(
                //elevation: 0.0,
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
                      leading: Icon(Icons.search_rounded, color: Colors.grey.shade600,),
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
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey.shade600,),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
                        },
                      ),
                    ),
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                // flexibleSpace: Container(
                //   decoration: BoxDecoration(
                //       gradient: AppConfig.gradient
                //   ),
                // ),
              ),

              body: MyBody(),
            );
          }

        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage()));
          //   },
          //   child: Icon(Icons.upload, color: Colors.white,),
          // ),
          appBar: AppBar(
            elevation: 0.0,
            title: Container(
              width: size.width,
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.white,
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
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: AppConfig.gradient
              ),
            ),
          ),

          body: MyBody(),
        );
      },
    );
  }
}

class MyBody extends StatelessWidget {

  // final BannerAd? banner;
  //
  // const MyBody({Key? key, this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        if(sizeInfo.isDesktop)
          {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Home", style: Theme.of(context).textTheme.headline5,),
                    ),
                    Container(
                      //height: size.height*0.8,
                      width: size.width,
                      decoration: BoxDecoration(
                          gradient: AppConfig.gradient,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Shop by Categories", style: Theme.of(context).textTheme.headline5!.apply(color: Colors.white),),
                                TextButton.icon(
                                  onPressed: () {},
                                  label: Text("See All", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
                                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: size.width,
                              //height: size.height*0.35,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GridView.count(
                                  crossAxisCount: 5,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(category2s.length, (index) {
                                    Category2 cat = category2s[index];

                                    return Category2Layout(category2: cat,);
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Coupon & Cashback Deals", style: Theme.of(context).textTheme.headline5,),
                          TextButton.icon(
                            onPressed: () {},
                            label: Text("See All", style: TextStyle(fontWeight: FontWeight.w800),),
                            icon: Icon(Icons.arrow_forward_ios,),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products').limit(9).orderBy("timestamp", descending: true).snapshots(),
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
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: List.generate(products.length, (index) {
                                Product product = products[index];

                                return ProductLayout(product: product, isCoupon: true,);
                              }),
                            );
                          }
                        },
                      ),
                    ),
                    // ProductCard(
                    //   backgroundImg: "assets/2.jpg",
                    //   title: "Coupon and Cash Back Deals",
                    //   stream: FirebaseFirestore.instance
                    //       .collection('products').orderBy("timestamp", descending: true).snapshots(),
                    // ),
                    SizedBox(height: 10.0,),
                    // if (banner == null) Container() else Container(
                    //     height: banner!.size.height.toDouble(),
                    //     width: banner!.size.width.toDouble(),
                    //     child: AdWidget(ad: banner!)),
                    // SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Recently Viewed", style: Theme.of(context).textTheme.headline5,),
                          TextButton.icon(
                            onPressed: () {},
                            label: Text("See All", style: TextStyle(fontWeight: FontWeight.w800),),
                            icon: Icon(Icons.arrow_forward_ios,),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users').doc(AppConfig.account!.userID).collection("viewed").limit(6).orderBy("timestamp", descending: true).snapshots(),
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
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: List.generate(products.length, (index) {
                                Product product = products[index];

                                return ProductLayout(product: product, isCoupon: false,);
                              }),
                            );
                          }
                        },
                      ),
                    ),
                    // ProductCard(
                    //   backgroundImg: "assets/man.jpg",
                    //   title: "Recently Viewed",
                    //   stream: FirebaseFirestore.instance
                    //       .collection('users').doc(AppConfig.account!.userID).collection("viewed").orderBy("timestamp", descending: true).snapshots(),
                    // ),
                    SizedBox(height: 30.0,),
                    // RaisedButton(
                    //   onPressed: () async {
                    //     await FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
                    //       querySnapshot.docs.forEach((document) {
                    //         document.reference.set({
                    //           "balance": 0.00,
                    //         }, SetOptions(merge: true));
                    //       });
                    //     });
                    //   },
                    // ),
                    // SizedBox(height: 30.0,),
                  ],
                ),
              ),
            );
          }

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height*0.3,
                width: size.width,
                decoration: BoxDecoration(
                    gradient: AppConfig.gradient,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Shop by Categories", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: size.width,
                        height: size.height*0.22,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.count(
                            crossAxisCount: 4,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(category2s.length, (index) {
                              Category2 cat = category2s[index];

                              return Category2Layout(category2: cat,);
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              ProductCard(
                backgroundImg: "assets/2.jpg",
                title: "Coupon and Cash Back Deals",
                stream: FirebaseFirestore.instance
                    .collection('products').orderBy("timestamp", descending: true).snapshots(),
              ),
              SizedBox(height: 10.0,),
              // if (banner == null) Container() else Container(
              //     height: banner!.size.height.toDouble(),
              //     width: banner!.size.width.toDouble(),
              //     child: AdWidget(ad: banner!)),
              // SizedBox(height: 10.0,),
              ProductCard(
                backgroundImg: "assets/man.jpg",
                title: "Recently Viewed",
                stream: FirebaseFirestore.instance
                    .collection('users').doc(AppConfig.account!.userID).collection("viewed").orderBy("timestamp", descending: true).snapshots(),
              ),
              SizedBox(height: 30.0,),
              // RaisedButton(
              //   onPressed: () async {
              //     await FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
              //       querySnapshot.docs.forEach((document) {
              //         document.reference.set({
              //           "balance": 0.00,
              //         }, SetOptions(merge: true));
              //       });
              //     });
              //   },
              // ),
              // SizedBox(height: 30.0,),
            ],
          ),
        );
      },
    );
  }
}



class ProductCard extends StatefulWidget {
  
  final Stream<QuerySnapshot>? stream;
  final String? title;
  final String? backgroundImg;
  
  const ProductCard({Key? key, this.stream, this.title, this.backgroundImg}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  // Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
  //     .collection('products').orderBy("timestamp", descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height*0.35,
          //color: Colors.grey,
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: size.height*0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(widget.backgroundImg!),
                fit: BoxFit.cover,
              )
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: size.height*0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black38
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(widget.title!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: widget.stream,
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

                        return Container(
                          height: size.height*0.25,
                          //width: size.width,
                          child: ListView.builder(
                            itemCount: products.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              Product product = products[index];

                              return ProductLayout(product: product, isCoupon: true,);
                            },
                          ),
                        );
                      }
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
