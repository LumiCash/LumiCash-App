import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/Config/timeConverter.dart';
import 'package:lumicash/ads/ads_state.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/pages/paymentPage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cart.dart';


class DetailsPage extends StatefulWidget {

  final Product? product;

  const DetailsPage({Key? key, this.product}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  String itemSize = "";
  String itemColor = "";
  bool isFav = false;
  bool isInCart = false;
  bool isValid = true;
  // BannerAd banner;
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final adState = Provider.of<AdState>(context);
  //
  //   adState.initialization.then((status) {
  //     setState(() {
  //       banner = BannerAd(
  //         adUnitId: adState.bannerAdUnitId,
  //         size: AdSize.banner,
  //         request: AdRequest(),
  //         listener: adState.adListener,
  //       )..load();
  //     });
  //   });
  // }



  @override
  void initState() {
    super.initState();

    checkCart();
    checkFavourites();
    updateTimeViewed();

    checkValidity();
  }

  checkValidity() {
    int now = DateTime.now().millisecondsSinceEpoch;

    if(now > (widget.product!.period! + widget.product!.timestamp!))
      {
        setState(() {
          isValid = false;
        });
      }

  }

  updateTimeViewed() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("viewed")
        .doc(widget.product!.productId).get().then((value) {
          if(value.exists)
            {
              value.reference.update({"timestamp": DateTime.now().millisecondsSinceEpoch});
            }
          else
            {

              value.reference.set(widget.product!.toMap());
            }
    });
  }

  checkFavourites() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("favourites")
        .doc(widget.product!.productId).get().then((value) {
      if(value.exists)
      {
        setState(() {
          isFav = true;
        });
      }
    });
  }

  checkCart() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("cart")
        .doc(widget.product!.productId).get().then((value) {
          if(value.exists)
            {
              setState(() {
                isInCart = true;
              });
            }
    });
  }

  changeSize(dynamic choice) {
    setState(() {
      itemSize = choice.toString();
    });
  }

  changeColor(dynamic choice) {
    setState(() {
      itemColor = choice.toString();
    });
  }

  addProductToCart() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("cart")
        .doc(widget.product!.productId).set(widget.product!.toMap()).then((value) {
          Fluttertoast.showToast(msg: "Added to Cart");
    });

    setState(() {
      isInCart = true;
    });
  }

  removeFromCart() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("cart")
        .doc(widget.product!.productId).get().then((value) {
          if(value.exists)
            {
              value.reference.delete().then((value) => Fluttertoast.showToast(msg: "Removed from Cart"));
              setState(() {
                isInCart = false;
              });
            }
          else
            {
              Fluttertoast.showToast(msg: "Removed from Cart");
            }
    });
  }

  addToFavourites() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("favourites")
        .doc(widget.product!.productId).set(widget.product!.toMap()).then((value) {
      Fluttertoast.showToast(msg: "Added to Favourites");
    });

    setState(() {
      isFav = true;
    });
  }

  removeFromFavourites() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).collection("favourites")
        .doc(widget.product!.productId).get().then((value) {
          if(value.exists)
            {
              value.reference.delete().then((value) => Fluttertoast.showToast(msg: "Removed from Favourites"));
              setState(() {
                isFav = false;
              });
            }
          else
            {
              Fluttertoast.showToast(msg: "Unable to remove from Favourites");
            }
    });
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    BoxDecoration decoration = BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 2.0,
          blurRadius: 4.0,
          offset: Offset(2.0, 0.0)
        )
      ]
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DisplayCarousel(product: widget.product!,),
            SizedBox(height: 10.0,),
            Container(
              width: size.width,
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.product!.title!, maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold),)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isFav
                            ? IconButton(onPressed: removeFromFavourites, icon: Icon(Icons.favorite, color: Colors.red,),)
                            : IconButton(onPressed: addToFavourites, icon: Icon(Icons.favorite_border_rounded),),
                        IconButton(onPressed: () {}, icon: Icon(Icons.share),),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: size.width,
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available Slots"),
                    Text(widget.product!.count.toString())
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: size.width,
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time Limit"),
                    Text(TimeConverter().getDuration(widget.product!.timestamp!, widget.product!.period!)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: size.width,
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget.product!.description!),
              ),
            ),
            // SizedBox(height: 5.0,),
            // if (banner == null) Container() else Container(
            //     height: banner.size.height.toDouble(),
            //     width: banner.size.width.toDouble(),
            //     child: AdWidget(ad: banner)),
            SizedBox(height: 10.0,),
            isValid ? InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> PaymentPage(
                      product: widget.product,
                    )));
              },
              child: Container(
                height: 40.0,
                width: 120.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Get Gift", style: TextStyle(color: Colors.white),),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: AppConfig.gradient
                ),
              ),
            ) : Text("Time Limit Elapsed", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: size.width,
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ksh ${widget.product!.price}", style: TextStyle(fontWeight: FontWeight.bold),),
              InkWell(
                onTap: isInCart ? removeFromCart : addProductToCart,
                child: Container(
                  height: 40.0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text( isInCart ? "Remove from Cart" : "Add to Cart", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: AppConfig.gradient
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayCarousel extends StatefulWidget {

  final Product? product;

  const DisplayCarousel({Key? key, this.product}) : super(key: key);

  @override
  _DisplayCarouselState createState() => _DisplayCarouselState();
}

class _DisplayCarouselState extends State<DisplayCarousel> {

  int pageNumber = 1;

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      pageNumber = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMany = widget.product!.imageUrl!.split("|").length > 1;

    return Stack(
      children: [
        CarouselSlider(
            items: List.generate(widget.product!.imageUrl!.split("|").length, (index) {
              String imageUrl = widget.product!.imageUrl!.split("|")[index];

              return Hero(
                tag: imageUrl,
                child: Container(
                  height: size.height*0.35,
                  width: size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              );

            }),
            options: CarouselOptions(
              height: size.height*0.35,
              //aspectRatio: 16/9,
              //viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              onPageChanged: onPageChange,
              scrollDirection: Axis.horizontal,
            )
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: isMany ? Container(
            height: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black54
            ),
            child: Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
              child: Text("$pageNumber/${widget.product!.imageUrl!.split("|").length}", style: TextStyle(color: Colors.white),),
            )),
          ) : Text(""),
        )
      ],
    );
  }
}


class DetailsTextField extends StatelessWidget {

  final TextEditingController? controller;
  final String? hintText;

  const DetailsTextField({Key? key, this.controller, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              width: 1.0,
            )
        ),
        focusColor: Theme.of(context).primaryColor,
        hintText: hintText,
        labelText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }
}
