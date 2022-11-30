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
}
  // Future<UserDetails> displayUserProfile(String username) async {
  //   var getUserURI = Uri.parse(userCRUDURI + "?username=" + username);
  //   try {
  //     final response = await http.get(getUserURI, headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       "Accept": "*/*",
  //       'authorizationToken': authToken
  //     });
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;

  //     String _firstName = extractedData["firstName"];
  //     String _lastName = extractedData["lastName"]??"";
  //     String _phoneNo = extractedData["phoneNo"];
  //     String _gmail = extractedData["gmail"]??"";
  //     String _address = extractedData["address"]??"";

  //     UserDetails userDetails = UserDetails(
  //         firstName: _firstName,
  //         lastName: _lastName,
  //         phoneNo: _phoneNo,
  //         gmail: _gmail,
  //         address: _address);
  //     return userDetails;
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // Future<void> editUserProfile(
  //     String username, Map<String, String> updatedUserValues) async {
  //   var editUserURI = Uri.parse(userCRUDURI);

  //   updatedUserValues.forEach((key, value) async {
  //     final response = await http.patch(editUserURI,
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           "Accept": "*/*",
  //           'authorizationToken': authToken
  //         },
  //         body: jsonEncode(
  //             {"username": username, "updateKey": key, "updateValue": value}));
  //   });
  // }

  // Future<void> createBabyUser(String username, String babyFirstName,
  //     String babyLastName, String dob, String relation, String gender) async {
  //   var createBabyURI = Uri.parse(userCRUDURI);
  //   var babiesList = [];
  //   var babyInfo = {};
  //   babyInfo["firstName"] = babyFirstName;
  //   babyInfo["lastName"] = babyLastName;
  //   babyInfo["dob"] = dob;
  //   babyInfo["relation"] = relation;
  //   babyInfo["gender"] = gender;
  //   babiesList.add(babyInfo);
  //   final response = await http.patch(createBabyURI,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         "Accept": "*/*",
  //         'authorizationToken': authToken
  //       },
  //       body: jsonEncode({
  //         "username": username,
  //         "updateKey": "babies",
  //         "updateValue": babiesList
  //       }));
  // }

  // Future<List<BabyDetails>> displayBabyProfile(String username) async {
  //   var getUserURI = Uri.parse(userCRUDURI + "?username=" + username);
  //   try {
  //     final response = await http.get(getUserURI, headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       "Accept": "*/*",
  //       'authorizationToken': authToken
  //     });
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;

  //     final babyList = extractedData["babies"]??[];
  //     List<BabyDetails> babyDetails = [];
  //     for (final baby in babyList) {
  //       babyDetails.add(BabyDetails(
  //           babyFirstName: baby['firstName']!,
  //           babyLastName: baby['lastName']!,
  //           dob: baby['dob']!,
  //           relation: baby['relation']!,
  //           gender: baby['gender']!));
  //     }
  //     return babyDetails;
  //   } catch (error) {
  //     throw (error);
  //   }
  // }
// }
