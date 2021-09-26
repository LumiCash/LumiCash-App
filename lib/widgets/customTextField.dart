import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget
{
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final bool? isObscure;



  CustomTextField(
      {Key? key, this.controller, this.data, this.hintText,this.isObscure}
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                width: 1.0,
              )
          ),
          prefixIcon: Icon(data, color: Colors.blue,),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}



class MyCustomTextField extends StatelessWidget
{
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;



  MyCustomTextField({Key? key, this.controller, this.hintText, this.keyboardType}) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        maxLines: null,
        keyboardType: keyboardType,
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
      ),
    );
  }
}
