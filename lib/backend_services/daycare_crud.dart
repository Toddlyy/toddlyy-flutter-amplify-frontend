import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toddlyybeta/models/daycare_model.dart';

import '../models/daycare_model.dart';

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

  Future<DaycareDetails> showDaycareDetails(String daycareID) async {
    try {
      var showDaycareDetailsURI = Uri.parse(daycareCRUDURI + "?daycareID=" + daycareID);
      final response =
          await http.get(showDaycareDetailsURI, headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "*/*",
        'authorizationToken': authToken
      });
      final daycare = json.decode(response.body)[0] as Map<String,dynamic>;
      DaycareDetails daycareDetails = new DaycareDetails(
          daycareName: daycare["name"],
          daycareID: daycare["daycareID"],
          accepting: daycare["accepting"]??true,
          address: daycare["address"],
          startTime: daycare["startTime"],
          endTime: daycare["endTime"],
          features: daycare["features"],
          image: daycare["image"],
          timeSlots: daycare["timeSlots"]??[],
          openOnWeekends: daycare["openOnWeekends"]??true,
          region: daycare["region"],
          phoneNo: daycare["phoneNo"],
          charges: daycare["charges"]);
      return daycareDetails;
    } catch (error) {
      throw (error);
    }
  }
}
