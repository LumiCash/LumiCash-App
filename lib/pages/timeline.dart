import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/DialogBox/errorDialog.dart';
import 'package:lumicash/bookings/booking.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/models/listItem.dart';
import 'package:lumicash/models/transaction.dart';
import 'package:lumicash/pages/searchPage.dart';
import 'package:lumicash/transactionPages/addMoney.dart';
import 'package:lumicash/widgets/listItemLayout.dart';
import 'package:provider/provider.dart';


class TimelinePage extends StatefulWidget {

  BannerAd? banner;

  TimelinePage({Key? key, this.banner}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  displayDialog() {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: "Service currently not available",);
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleTextStyle: TextStyle(fontWeight: FontWeight.normal),
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(value: "",)));
          },
          child: Container(
            width: size.width,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Search", style: TextStyle(color: Colors.grey),),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Image.asset(AppConfig.appIcon, height: 30.0, fit: BoxFit.fitHeight,),
              //         SizedBox(width: 10.0,),
              //         Text("Lumicash", style: TextStyle(color: AppConfig.appThemeColor),),
              //       ],
              //     ),
              //     Icon(Icons.search_rounded, color: Colors.grey,)
              //   ],
              // ),
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppConfig.gradient
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height*0.2,
                  width: size.width,
                  //color: Colors.grey,
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: size.height*0.1, //50.0,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
                      gradient: AppConfig.gradient
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: size.height*0.15,
                      width: size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 6.0,
                            spreadRadius: 3.0,
                            offset: Offset(2.0, 2.0)
                          )
                        ],
                        color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(transactionTypes.length, (index) {

                              TransactionType type = transactionTypes[index];

                              return InkWell(
                                onTap: () {
                                  if(type.title == "Add Money")
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddMoney()));
                                    }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 50.0,
                                          width: 50.0,
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: Container(
                                            height: 40.0,
                                            width: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25.0),
                                              border: Border.all(
                                                color: Colors.black45,
                                                width: 1.0,
                                              )
                                            ),
                                            child: Center(
                                              child: Text("\$", style: TextStyle(fontSize: 16.0),),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 10.0,
                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                              child: Center(child: type.icon, ),
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(type.title!,),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            MyCard(
              imageUrl: "assets/1.jpg",
              height: 0.3,
              title: "Quick Recharges & Bill Pays",
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: size.width,
                  height: size.height*0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).scaffoldBackgroundColor
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.count(
                        crossAxisCount: 4,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(categoryOnes.length, (index) {
                          Category1 category1 = categoryOnes[index];

                          return InkWell(
                            onTap: () {
                              if(category1.title == "Train Ticket"
                              || category1.title == "Flights"
                                  || category1.title == "Bus" )
                                {
                                  Route route = MaterialPageRoute(builder: (context)=> BookingPage());
                                  Navigator.push(context, route);
                                }
                            },
                            child: Column(
                              children: [
                                category1.icon!,
                                Text(category1.title!,)
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            // if (widget.banner == null) Container() else Container(
            //     height: widget.banner.size.height.toDouble(),
            //     width: widget.banner.size.width.toDouble(),
            //     child: AdWidget(ad: widget.banner)),
            SizedBox(height: 5.0,),
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


class MyCard extends StatelessWidget {

  final String? imageUrl;
  final String? title;
  final Widget? child;
  final double? height;

  const MyCard({Key? key, this.imageUrl, this.title, this.child, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: size.height*height!,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: AssetImage(imageUrl!),
              fit: BoxFit.cover,
            )
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10.0)
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
                padding: const EdgeInsets.all(10.0),
                child: Text(title!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              child!
            ],
          ),
        )
      ],
    );
  }
}
