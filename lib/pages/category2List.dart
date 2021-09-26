import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/pages/searchPage.dart';

import 'categoryPage.dart';


class Category2List extends StatelessWidget {
  const Category2List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(value: "",)));
            },
            icon: Icon(Icons.search, color: Colors.white,),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppConfig.gradient),
        ),
      ),
      body: ListView.builder(
        itemCount: category2s.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Category2 category2 = category2s[index];

          return category2.title == "More"? Container(): Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryPage(category: category2,)));
              },
              child: Stack(
                children: [
                  Container(
                    height: size.height*0.2,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage((category2.imageUrl)!),
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
                    bottom: size.height*0.08,
                    right: 20.0,
                    child: Text(category2.title!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
