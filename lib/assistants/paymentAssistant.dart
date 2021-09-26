import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/payment_enums.dart';

class PaymentAssistant {

  dynamic transactionInitialisation;
  final String shortCode = "9074611";

  Future<void> performMPesaTransaction({String? phone, int? amount}) async {

    //Wrap it with a try-catch
    try {

      //Run it
      transactionInitialisation =
      await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: shortCode,
        transactionType: TransactionType.CustomerBuyGoodsOnline,
        amount: amount!.toDouble(),
        partyA: phone!,
        partyB: shortCode,
        callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
        accountReference: "LumiCash App",
        phoneNumber: phone,
        baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
        transactionDesc: "Ordered Item",
        passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",//"MYkVxcUtQ6NMVJcTOrQtzIP/HUA8NCdm1QjWmI03yBLgCS/ft1/epT4iKmM0dNWxJIoDYfA50WEv0O6dgkcIX6iaLvQ2BJ3c2KRPDEvjBC5wlRsx0w4hQPZbwrv232ArIQylJ6ExT03o3jLTcYVPtuVT40X9P8d056suBJVsYtUxZr6G/q+1DaWD+fVGq22JrL++BpNsCWmObPpuoeEEUgvEk8S+wsP9Rx38VeTG6FXLqOVOWmCXHBIqX/UmWh8jpxABCmt3SJU2WB8VeJhVyYs6oPSJrRZWiXP64Er8qNRykIuYM9YBEsEWlRg8GJW/PbA4KB6CVES9kbX88kpmoQ=="//"bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
      );

    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      print("=========For Mpesa=======================${e}=======================");
    }
  }
}