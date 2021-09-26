import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/DialogBox/errorDialog.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/models/listItem.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/pages/timeline.dart';
import 'package:lumicash/widgets/listItemLayout.dart';
import 'package:lumicash/widgets/postLayout.dart';


class SearchPage extends StatefulWidget {

  final String? value;

  const SearchPage({Key? key, this.value}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot<Object?>>? futureResults;


  @override
  void initState() {
    super.initState();

    if(widget.value!.isNotEmpty)
      {
        setState(() {
          searchController.text = widget.value!;
        });
        controlSearch(widget.value!);
      }
  }

  controlSearch(String val) async {

    await FirebaseFirestore.instance.collection("users").doc(AppConfig.account!.userID).collection("searches").add(
        {
          "title": val,
          "timestamp": DateTime.now().millisecondsSinceEpoch
        });

    Future<QuerySnapshot<Object?>>? results = FirebaseFirestore.instance.collection("products")
        .where("searchKey", isGreaterThanOrEqualTo: val.toLowerCase())
        .limit(5).get();

    setState(() {
      futureResults = results;
    });
  }

  displayResults() {
    return FutureBuilder<QuerySnapshot>(
      future: futureResults,
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
              childAspectRatio: 2/3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(products.length, (index) {
                return ProductLayout(product: products[index],isCoupon: false,);
              }),
            );
          }
      },
    );
  }

  displayDialog() {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: "Service currently not available",);
        }
    );
  }

  quickLinks(Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          height: 80.0,
          child: ListView.builder(
            itemCount: categoryOnes.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: displayDialog,
                  child: Column(
                    children: [
                      categoryOnes[index].icon!,
                      Text(categoryOnes[index].title!,)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  recentSearches(Size size) {
    return Container(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recent Searches", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("users")
                  .doc(AppConfig.account!.userID).collection("searches").orderBy("timestamp", descending: true)
                  .limit(5).get(),
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  {
                    return Container();
                  }
                else
                  {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(snapshot.data!.docs[index]["title"]),
                        );
                      },
                    );
                  }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        bottom: PreferredSize(
          preferredSize: Size(size.width, 60.0),
          child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: searchController,
              cursorColor: Theme.of(context).primaryColor,
              onFieldSubmitted: (String value) {
                controlSearch(value.trim());
              },
              decoration: InputDecoration(
                focusColor: Theme.of(context).primaryColor,
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: Icon(Icons.clear,),
                ),
                hintText: "What're you looking for?",
                hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            futureResults != null ? displayResults() : recentSearches(size),
            Container(
              height: 3.0,
              width: size.width,
              color: Colors.grey.shade300,
            ),
            quickLinks(size),
            MyCard(
              imageUrl: "assets/2.jpg",
              height: 0.25,
              title: "Save on Bill Payments",
              child: Container(
                height: size.height*0.15,
                width: size.width,
                child: ListView.builder(
                  itemCount: items.length,
                  //shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    ListItem item = items[index];

                    return ListItemLayout(item: item, function: displayDialog,);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
