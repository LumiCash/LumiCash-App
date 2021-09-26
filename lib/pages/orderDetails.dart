import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/Config/timeConverter.dart';
import 'package:lumicash/models/moneyTransfer.dart';
import 'package:qr_flutter/qr_flutter.dart';


class OrderDetails extends StatefulWidget {

  final MoneyTransfer? transfer;

  const OrderDetails({Key? key, this.transfer}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text("Order Details", style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppConfig.gradient
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 10.0,),
            Container(
              height: 300.0,
              width: size.width,
              child: ListView.builder(
                itemCount: widget.transfer!.imageUrl!.split("|").length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var imageUrl = widget.transfer!.imageUrl!.split("|")[index];

                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 300.0,
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.contain
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.0,),
            Text(widget.transfer!.description!, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),),
            SizedBox(height: 10.0,),
            Text("Quantity: ${widget.transfer!.transferID!.split("_")[1]}"),
            SizedBox(height: 10.0,),
            ListTile(
              title: Text("Order Num ${widget.transfer!.timestamp}", style: TextStyle(fontWeight: FontWeight.w400),),
              subtitle: Text(TimeConverter().readTimestamp(widget.transfer!.timestamp!),),
              trailing: Text("KES ${widget.transfer!.amount.toString()}", style: TextStyle(fontWeight: FontWeight.w700),),
            ),
            SizedBox(height: 10.0,),
            QrImage(
              data: widget.transfer!.transferID!,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}
