import 'package:flutter/material.dart';
import 'package:lumicash/models/listItem.dart';


class ListItemLayout extends StatelessWidget {

  final ListItem? item;
  final Function? function;

  const ListItemLayout({Key? key, this.item, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Container(
        height: size.height*0.15,
        width: size.width*0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  spreadRadius: 3.0,
                  offset: Offset(1.0, 1.0)
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(item!.title!, style: TextStyle(fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Expanded(
                    child: Text(item!.description!, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  ),
                  RaisedButton(
                    onPressed: () => function,
                    color: Colors.blue,
                    child: Text("Know more", style: TextStyle(color: Colors.white),),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  )
                ],
              ),
              Text("*Terms & Conditions apply")
            ],
          ),
        ),
      ),
    );
  }
}
