
import 'package:lumicash/assistants/requestAssistant.dart';

class OnlineStoreAPI {
  final String url = "https://aliexpress19.p.rapidapi.com/products/33061907177";
  final Map<String, String> headers = {
  'x-rapidapi-key': 'c6fd8d4084msh0f81d6af2c4c3c3p10e482jsnf3689e9734af',
  'x-rapidapi-host': 'aliexpress19.p.rapidapi.com'
  };

  getData() async {
    var result = await RequestAssistant.getRequest(url, headers);

    print(result);
  }
}

class FlightDataAPI {
  final String url = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/autosuggest/v1.0/KE/GBP/en-GB/?query=";
  final Map<String, String> headers = {
        "x-rapidapi-key": "c6fd8d4084msh0f81d6af2c4c3c3p10e482jsnf3689e9734af",
        "x-rapidapi-host": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com"
      };

  getPlaces(String query) async {
    var result = await RequestAssistant.getRequest(url+query, headers);

    print(result);
  }
}

class BookingAPI {
  final String url = "https://booking-com.p.rapidapi.com/v1/hotels/search-filters?locale=en-gb&filter_by_currency=KES&adults_number=2&dest_type=hotel&order_by=price&room_number=1&dest_id=-553173&checkin_date=2021-11-25&checkout_date=2021-11-26&units=metric";
  final Map<String, String> headers = {

  };
}