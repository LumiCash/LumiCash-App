import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {

  static Future<dynamic> getRequest(String link, Map<String, String> headers) async {

    var url = Uri.parse(link);

    //await http.post(url, headers: , body: ,)

    http.Response response = await http.get(url, headers: headers);

    try{
      if(response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);

        return decodeData;
      }
      else
      {
        return "Failed";
      }
    }
    catch(exp) {
      return "Failed";
    }
  }
}