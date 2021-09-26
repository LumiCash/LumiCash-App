import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/assistants/paymentAssistant.dart';
import 'package:lumicash/models/listItem.dart';
import 'package:lumicash/widgets/listItemLayout.dart';
import 'package:lumicash/widgets/wideButton.dart';


class AddMoney extends StatefulWidget {
  const AddMoney({Key? key}) : super(key: key);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {

  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double balance = 0.00;

  @override
  void initState() {
    super.initState();


    setState(() {
      balance = AppConfig.account!.balance!;
    });
  }

  saveMoney() async {
    if(phoneController.text.isNotEmpty && amountController.text.isNotEmpty)
      {
        try{
          await PaymentAssistant().performMPesaTransaction(
            phone: phoneController.text.trim(),
            amount: int.parse(amountController.text.trim()),
          ).then((value) async {
            await FirebaseFirestore.instance.collection("users")
                .doc(AppConfig.account!.userID).get().then((value) async {
                  double? myBalance = value.data()!["balance"] + int.parse(amountController.text.trim()).toDouble();

                  await value.reference.update({
                    "balance": myBalance,
                  });

                  setState(() {
                    balance = myBalance!;
                  });

                  Fluttertoast.showToast(msg: "Added Money Successfully! Balance: $myBalance");
            });
          });

        }
        catch (e) {
          print("==================${e.toString()}=================");
        }
      }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Add Money", style: TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        bottom:  PreferredSize(
          preferredSize: Size(size.width, 200.0),
          child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                MyField(
                  controller: amountController,
                  hintText: "Enter Amount",
                  onPressed: () {
                    setState(() {
                      amountController.clear();
                    });
                  },
                ),
                SizedBox(height: 10,),
                MyField(
                  controller: phoneController,
                  hintText: "M-Pesa Number (2547...)",
                  onPressed: () {
                    setState(() {
                      phoneController.clear();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: WideButton(title: "Add Money", onTap: ()=> saveMoney(),),
                ),
                Text("Balance: KES $balance", style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(height: size.height*0.2, width: size.width,),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: size.height*0.15,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/2.jpg"),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 10.0,
                  left: 10.0,
                  child: ListItemLayout(item: items[0], function: () {},),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: items.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ListItem item = items[index];

                  return ListItemLayout(item: item, function: () {},);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyField extends StatelessWidget {

  final TextEditingController? controller;
  final Function? onPressed;
  final String? hintText;


  const MyField({Key? key, this.controller, this.onPressed, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      onFieldSubmitted: (String value) {
        //controlSearch(value.trim());
      },
      decoration: InputDecoration(
        focusColor: Theme.of(context).primaryColor,
        suffixIcon: IconButton(
          onPressed: () => onPressed,
          icon: Icon(Icons.clear,),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}

