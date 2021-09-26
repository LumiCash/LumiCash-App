import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/assistants/paymentAssistant.dart';
import 'package:lumicash/main.dart';
import 'package:lumicash/models/moneyTransfer.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/widgets/ProgressWidget.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'detailsPage.dart';
import 'homePage.dart';

class PaymentPage extends StatefulWidget {

  final Product? product;

  const PaymentPage({Key? key, this.product,}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController numberOfItems = TextEditingController();
  dynamic transactionInitialisation;
  bool showCode = false;
  bool loading = false;


  @override
  void initState() {
    super.initState();

    phoneNumber.text = "2547";
  }

  Future<void> performMPesaTransaction() async {
    //Wrap it with a try-catch
    try {
      //Run it
      transactionInitialisation =
      await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: 1.00,
          partyA: phoneNumber.text.trim(),
          partyB: "174379",
          callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
          accountReference: "LumiCash App",
          phoneNumber: phoneNumber.text.trim(),
          baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
          transactionDesc: "Ordered Item",
          passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
      );

    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      print(e);
    }
  }
  
  performPayment() async {
    setState(() {
      loading = true;
    });

    int amount = int.parse(widget.product!.price!) * int.parse(numberOfItems.text.trim());

    //TODO: Mpesa payment here
    // await PaymentAssistant().performMPesaTransaction(
    //     phone: phoneNumber.text.trim(),
    //     amount: amount,
    // );
    
    //upload order details to firestore
    MoneyTransfer transfer = MoneyTransfer(
      imageUrl: widget.product!.imageUrl,
      transferID: "${phoneNumber.text.trim()}_${numberOfItems.text.trim()}_${widget.product!.productId}",
      title: "Ordered Successful!",
      transferType: "Deals",
      timestamp: DateTime.now().millisecondsSinceEpoch, 
      description: widget.product!.title,
      amount: amount,
    );

    await FirebaseFirestore.instance.collection("products")
        .doc(widget.product!.productId).collection("orders").doc(transfer.transferID)
        .set(transfer.toMap());
    
    // await FirebaseFirestore.instance.collection("users")
    //     .doc(AppConfig.account!.userID).collection("orders").doc(transfer.transferID)
    //     .set(transfer.toMap()).then((value) => Fluttertoast.showToast(msg: "Item Ordered Successfully!"));

    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).get().then((querySnapshot) async {
          double balance = querySnapshot.get("balance");

          await querySnapshot.reference.update({
            "balance": balance + double.parse(widget.product!.price!),
          });

          await querySnapshot.reference.collection("orders").doc(transfer.transferID)
              .set(transfer.toMap()).then((value) => Fluttertoast.showToast(msg: "Item Ordered Successfully!"));
    });
    
    //Generate QR Code
    setState(() {
      showCode = true;
      loading = false;
    });
  }

  getAmount() {
    if(numberOfItems.text.isEmpty)
    {
      return int.parse(widget.product!.price!);
    }
    else
    {
      return int.parse(widget.product!.price!) * int.parse(numberOfItems.text.trim());
    }
  }

  int get totalAmount => getAmount();

  moveToHome() {
    Route route = MaterialPageRoute(builder: (context)=> SplashScreen());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        bool isDesktop = sizeInfo.isDesktop;
        double padding = isDesktop ? size.width*0.3 : 20.0;

        return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
          body: loading ?  circularProgress() : Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: padding),
            child: showCode ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/success.jpg",
                    width: isDesktop ? size.height*0.4 : size.width,
                    height: isDesktop ? size.height*0.4 : size.width * 0.8,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(height: 10.0,),
                  QrImage(
                    data: "${phoneNumber.text.trim()}_${numberOfItems.text.trim()}_${widget.product!.productId}",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  SizedBox(height: 10.0,),
                  InkWell(
                    onTap: () {
                      moveToHome();
                    },
                    child: Container(
                      height: 40.0,
                      //width: 150.0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Proceed", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: AppConfig.gradient
                      ),
                    ),
                  ),
                ],
              ),
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height*0.15,),
                Text(widget.product!.title!, style: TextStyle(fontWeight: FontWeight.w700),),
                SizedBox(height: 10.0,),
                Text("Redeemable Points: KES ${widget.product!.price}"),
                SizedBox(height: 10.0,),
                Text("Total In Wallet: KES ${AppConfig.account!.balance!.toString()}"),
                SizedBox(height: 10.0,),
                DetailsTextField(
                  controller: numberOfItems,
                  hintText: "Number of Items",
                ),
                SizedBox(height: 10.0,),
                DetailsTextField(
                  controller: phoneNumber,
                  hintText: "M-Pesa Phone Number",
                ),
                SizedBox(height: 20.0,),
                InkWell(
                  onTap: () {
                    if(phoneNumber.text.isNotEmpty && numberOfItems.text.isNotEmpty)
                    {
                      try
                      {
                        performPayment();
                      }
                      catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                  child: Container(
                    height: 40.0,
                    //width: 150.0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Generate QR Code", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: AppConfig.gradient
                    ),
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //         });
                //       },
                //       child: Container(
                //         height: 40.0,
                //         //width: 150.0,
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: Text("Save", style: TextStyle(color: Colors.blue),),
                //           ),
                //         ),
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5.0),
                //             //gradient: AppConfig.gradient
                //           border: Border.all(
                //             color: Colors.blue,
                //             width: 2.0
                //           )
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 10.0,),
                //     InkWell(
                //       onTap: () {
                //         if(phoneNumber.text.isNotEmpty && numberOfItems.text.isNotEmpty)
                //           {
                //             try
                //                 {
                //                   Fluttertoast.showToast(msg: "Payment is not available");//performPayment();
                //                 }
                //                 catch (e) {
                //               print(e.toString());
                //                 }
                //           }
                //       },
                //       child: Container(
                //         height: 40.0,
                //         //width: 150.0,
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Text("Proceed to Pay", style: TextStyle(color: Colors.white),),
                //           ),
                //         ),
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5.0),
                //             gradient: AppConfig.gradient
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
