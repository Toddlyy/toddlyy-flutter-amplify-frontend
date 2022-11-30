import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingCRUDService {
  var bookingsCRUDURI =
      'https://fecf1hpu9d.execute-api.ap-south-1.amazonaws.com/dev/booking';

  String authToken =
      "hs0fqkufqomtg7duiltaxr56s115je5yvfbc0gj3jpg4d1itm684uvjtdli6";

  Future<void> createBooking(
      String username,
      String babyName,
      String daycareID,
      String daycareName,
      String dropTime,
      String pickUpTime,
      double charge,
      String status) async {
    var createBookingURI = Uri.parse(bookingsCRUDURI);
    try {
      final response = await http.post(createBookingURI,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Accept": "*/*",
            'authorizationToken': authToken
          },
          body: jsonEncode({
            "bookingID": username,
            "babyName": babyName,
            "daycareID": daycareID,
            "daycareName": daycareName,
            "startTime": dropTime,
            "endTime": pickUpTime,
            "charge": charge,
            "status": status
          }));
    } catch (error) {
      throw (error);
    }
  }

  Future<List<dynamic>> listUpcomingBookings(String username) async {
    try {
      var listUpcomingBookingsURI =
          Uri.parse(bookingsCRUDURI + "?username=" + username);
      final response =
          await http.get(listUpcomingBookingsURI, headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "*/*",
        'authorizationToken': authToken
      });

      final upcomingBookings = json.decode(response.body) as List<dynamic>;
      return upcomingBookings;
    } catch (error) {
      throw (error);
    }
  }
}
