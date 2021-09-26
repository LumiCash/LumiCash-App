import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/pages/physicalStore.dart';
import 'package:lumicash/pages/timeline.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'accountPage.dart';
import 'mall.dart';
import 'ordersPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int getPageIndex = 0;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String page = "Home";

  @override
  void initState() {
    super.initState();

    checkDeviceToken();

  }

  checkDeviceToken() async {

    //Get Device Token

    await messaging.getToken(vapidKey: AppConfig.vapidKey,).then((deviceToken) async {
      //print(deviceToken);

      await FirebaseFirestore.instance.collection("tokens").doc("tokenList").get().then((querySnapshot) async {
        List<dynamic> tokens = [];

        //print(querySnapshot.data());

        setState(() {
          tokens = querySnapshot.data()?["tokens"];
        });

        if(!tokens.contains(deviceToken))
          {
            print("Device Token is Absent");
            tokens.add(deviceToken);

            await FirebaseFirestore.instance.collection("tokens").doc("tokenList").set(
                {
                  "timestamp": DateTime.now().millisecondsSinceEpoch,
                  "count": tokens.length,
                  "tokens": tokens,
                });
          }
        else
          {
            print("Device Token is Present");
          }

      });
    });

    //Check if it is in Firestore

    //Add if it is not

  }

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  onPageChanged(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.bounceInOut,
    );
  }

  displayPage() {
    switch (page) {
      case 'Home':
        return MallPage();
        //break;
      case 'Store':
        return PhysicalStore();
        //break;
      case 'Orders':
        return OrdersPage();
        //break;
      case 'Account':
        return AccountPage();
        //break;
      default:
        return MallPage();
    }
  }

  changePage(String choice) {
    setState(() {
      page = choice;
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if(sizeInfo.isDesktop)
          {
            return Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width*0.2,
                    height: size.height,
                    //color: Colors.blue.shade700,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.lightBlueAccent],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/new_icon.png", height: 30.0, width: 30.0,),
                              SizedBox(width: 10.0,),
                              Text("LumiCash", style: Theme.of(context).textTheme.headline5!.apply(color: Colors.white),)
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Column(
                          children: List.generate(pages.length, (index) {
                            bool isSelected = page == pages[index].name;

                            return Container(
                              color: isSelected ? Colors.black26 : Colors.transparent,
                              child: ListTile(
                                onTap: () => changePage(pages[index].name!),
                                leading: Icon(
                                  pages[index].icon,
                                  color: Colors.white,
                                ),
                                title: Text(pages[index].name!, style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.white)),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: displayPage(),
                  )
                ],
              ),
            );
          }

        return Scaffold(
          body: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: NeverScrollableScrollPhysics(),
            children: [
              MallPage(),
              //TimelinePage(),
              PhysicalStore(),
              OrdersPage(),
              AccountPage()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.grey,
                ),
                label: "Home",
                activeIcon: Icon(
                  Icons.home_outlined,
                  color: Colors.blue,
                ),
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(
              //     Icons.monetization_on_outlined,
              //     color: Colors.grey,
              //   ),
              //   label: "Transact",
              //   activeIcon: Icon(
              //     Icons.monetization_on_outlined,
              //     color: Colors.blue,
              //   ),
              // ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.store_mall_directory_rounded,
                  color: Colors.grey,
                ),
                label: "Store",
                activeIcon: Icon(
                  Icons.store_mall_directory_rounded,
                  color: Colors.blue,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.grey,
                ),
                label: "Orders",
                activeIcon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.blue,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                label: "Account",
                activeIcon: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ],
            currentIndex: getPageIndex,
            elevation: 40.0,
            onTap: onTapChangePage,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        );
      },
    );
  }
}


class MyPage {
  final String? name;
  final IconData? icon;

  MyPage({this.name, this.icon});

}

final List<MyPage> pages = [
  MyPage(
    name: "Home",
    icon: Icons.home_outlined,
  ),
  MyPage(
    name: "Store",
    icon: Icons.store_mall_directory_rounded,
  ),
  MyPage(
    name: "Orders",
    icon: Icons.shopping_bag_outlined,
  ),
  MyPage(
    name: "Account",
    icon: Icons.person,
  ),
];