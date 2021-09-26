import 'package:flutter/material.dart';

class Category1 {
  final String? title;
  final Icon? icon;

  Category1({this.title, this.icon});
}


class Category2 {
  final String? title;
  final String? imageUrl;

  Category2({this.title, this.imageUrl});

}

List<Category2> category2s = [
  Category2(
    title: "Fashion",
    imageUrl: "assets/fashion.jpg",
  ),
  Category2(
    title: "Electronics",
    imageUrl: "assets/ele.jpg",
  ),
  Category2(
    title: "Phones",
    imageUrl: "assets/phone.jpg",
  ),
  Category2(
    title: "Devices",
    imageUrl: "assets/devices.jpg",
  ),
  Category2(
    title: "Appliances",
    imageUrl: "assets/appliances.jpg",
  ),
  Category2(
    title: "Beauty",
    imageUrl: "assets/beauty.jpg",
  ),
  Category2(
    title: "Sports",
    imageUrl: "assets/Sports.jpg",
  ),
  Category2(
    title: "Restaurants",
    imageUrl: "assets/restaurant.jpg",
  ),
  Category2(
    title: "Salon",
    imageUrl: "assets/salon.jpg",
  ),
  Category2(
    title: "Tours & Travel",
    imageUrl: "assets/tour.png",
  ),
  // Category2(
  //   title: "More",
  //   imageUrl: "assets/more.jpg",
  // ),
];

List<Category1> categoryOnes = [
  Category1(
    title: "Recharge",
    icon: Icon(Icons.phone_android_outlined, color: Colors.grey,),
  ),
  Category1(
    title: "Electricity",
    icon: Icon(Icons.electrical_services_rounded, color: Colors.grey,),
  ),
  Category1(
    title: "Train Ticket",
    icon: Icon(Icons.train_rounded, color: Colors.grey,),
  ),
  Category1(
    title: "Flights",
    icon: Icon(Icons.airplanemode_active_rounded, color: Colors.grey,),
  ),
  Category1(
    title: "Bus",
    icon: Icon(Icons.directions_bus_rounded, color: Colors.grey,),
  ),
  Category1(
    title: "DSTv",
    icon: Icon(Icons.network_check_sharp, color: Colors.grey,),
  ),
  Category1(
    title: "Zuku",
    icon: Icon(Icons.gradient, color: Colors.grey,),
  ),
  Category1(
    title: "More",
    icon: Icon(Icons.more_horiz_rounded, color: Colors.grey,),
  ),
];