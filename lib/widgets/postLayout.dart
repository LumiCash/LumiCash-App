import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/assistants/urlOpener.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/pages/detailsPage.dart';
import 'package:responsive_builder/responsive_builder.dart';


class ProductLayout extends StatelessWidget {

  final Product? product;
  final bool? isCoupon;

  const ProductLayout({Key? key, this.product, this.isCoupon}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if(sizeInfo.isDesktop)
          {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: size.width*0.3,
                width: size.width*0.2,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 3.0,
                          blurRadius: 5.0,
                          offset: Offset(2.0, 2.0)
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if(isCoupon!)
                          {
                            UrlOpener().launchURL("https://coupons.lumicashdeals.com/");
                          }
                          else
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage(product: product,)));
                          }
                        },
                        child: Container(
                          //width: size.width*0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                              image: DecorationImage(
                                  image: NetworkImage(product!.imageUrl!.split("|")[0]),
                                  fit: BoxFit.cover
                              )
                          ),
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                          //   child: CachedNetworkImage(
                          //     imageUrl: product.imageUrl.split("|")[0],
                          //     //height: 300.0,
                          //     width: size.width*0.4,
                          //     fit: BoxFit.fitWidth,
                          //     progressIndicatorBuilder: (context, url, downloadProgress) =>
                          //         Center(
                          //           child: Container(
                          //             height: 30.0,
                          //             width: 30.0,
                          //             child: CircularProgressIndicator(
                          //                 strokeWidth: 1.0,
                          //                 value: downloadProgress.progress,
                          //                 valueColor: AlwaysStoppedAnimation(Colors.grey)
                          //             ),
                          //           ),
                          //         ),
                          //     errorWidget: (context, url, error) => Icon(Icons.error_outline_rounded, color: Colors.grey,),
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product!.title!.trimRight(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800),),
                          Text(product!.description!.trimRight(),maxLines: 2, overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: size.height*0.25,
            width: size.width*0.4,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 3.0,
                      blurRadius: 5.0,
                      offset: Offset(2.0, 2.0)
                  )
                ]
            ),
            child: Column(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if(isCoupon!)
                      {
                        UrlOpener().launchURL("https://coupons.lumicashdeals.com/");
                      }
                      else
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage(product: product,)));
                      }
                    },
                    child: Container(
                      //width: size.width*0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                          image: DecorationImage(
                              image: NetworkImage(product!.imageUrl!.split("|")[0]),
                              fit: BoxFit.fitWidth
                          )
                      ),
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                      //   child: CachedNetworkImage(
                      //     imageUrl: product.imageUrl.split("|")[0],
                      //     //height: 300.0,
                      //     width: size.width*0.4,
                      //     fit: BoxFit.fitWidth,
                      //     progressIndicatorBuilder: (context, url, downloadProgress) =>
                      //         Center(
                      //           child: Container(
                      //             height: 30.0,
                      //             width: 30.0,
                      //             child: CircularProgressIndicator(
                      //                 strokeWidth: 1.0,
                      //                 value: downloadProgress.progress,
                      //                 valueColor: AlwaysStoppedAnimation(Colors.grey)
                      //             ),
                      //           ),
                      //         ),
                      //     errorWidget: (context, url, error) => Icon(Icons.error_outline_rounded, color: Colors.grey,),
                      //   ),
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product!.title!.trimRight(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800),),
                      //Text("Ksh ${product.price}", style: TextStyle(color: Colors.blue),)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
