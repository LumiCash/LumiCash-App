import 'package:flutter/material.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/pages/category2List.dart';
import 'package:lumicash/pages/categoryPage.dart';
import 'package:responsive_builder/responsive_builder.dart';


class Category2Layout extends StatelessWidget {

  final Category2? category2;

  const Category2Layout({Key? key, this.category2}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        if(sizeInfo.isDesktop)
          {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  if(category2!.title == "More")
                  {
                    return Category2List();
                  }
                  else
                  {
                    return CategoryPage(category: category2);
                  }
                }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: size.width*0.1,
                    width: size.width*0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                            image: AssetImage( category2!.imageUrl!),
                            fit:  BoxFit.cover
                        )
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text(category2!.title!)
                ],
              ),
            );
          }

        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if(category2!.title == "More")
              {
                return Category2List();
              }
              else
              {
                return CategoryPage(category: category2);
              }
            }));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                        image: AssetImage( category2!.imageUrl!),
                        fit:  BoxFit.cover
                    )
                ),
              ),
              SizedBox(height: 5.0,),
              Text(category2!.title!)
            ],
          ),
        );
      },
    );
  }
}
