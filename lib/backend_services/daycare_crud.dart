import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DaycareCRUDService {
  var daycareCRUDURI =
      'https://fecf1hpu9d.execute-api.ap-south-1.amazonaws.com/dev/daycare';

  String authToken =
      "hs0fqkufqomtg7duiltaxr56s115je5yvfbc0gj3jpg4d1itm684uvjtdli6";

  Future<List<dynamic>> displayDaycares() async {
    try {
      var displayDaycaresURI = Uri.parse(daycareCRUDURI);
      final response =
          await http.get(displayDaycaresURI, headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "*/*",
        'authorizationToken': authToken
      });
      // final extractedData =
      //     json.decode(response.body) as List<Map<String, dynamic>>;
      final daycares = json.decode(response.body) as List<dynamic>;
      return daycares;
    } catch (error) {
      throw (error);
    }
  }
}
