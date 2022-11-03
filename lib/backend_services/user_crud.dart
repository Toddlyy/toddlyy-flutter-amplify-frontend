import 'dart:convert';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/user_profile.dart';
import 'package:http/http.dart' as http;

class UserCRUDService {
  var userCRUDURI =
      'https://fecf1hpu9d.execute-api.ap-south-1.amazonaws.com/dev/user';

  String authToken =
      "hs0fqkufqomtg7duiltaxr56s115je5yvfbc0gj3jpg4d1itm684uvjtdli6";

  Future<void> createUser(String username, String phoneNumber, String firstName,
      String lastName) async {
    var createUserURI = Uri.parse(userCRUDURI);
    final response = await http.post(createUserURI,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Accept": "*/*",
          'authorizationToken': authToken
        },
        body: jsonEncode({
          "username": username,
          "phoneNo": phoneNumber,
          "firstName": firstName,
          "lastName": lastName
        }));
  }

  Future<void> createBabyUser(String username, String babyFirstName,
      String babyLastName, String dob, String relation, String gender) async {
    var createBabyURI = Uri.parse(userCRUDURI);
    var babiesList = [];
    var babyInfo = {};
    babyInfo["firstName"] = babyFirstName;
    babyInfo["lastName"] = babyLastName;
    babyInfo["dob"] = dob;
    babyInfo["relation"] = relation;
    babyInfo["gender"] = gender;
    babiesList.add(babyInfo);
    final response = await http.patch(createBabyURI,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Accept": "*/*",
          'authorizationToken': authToken
        },
        body: jsonEncode({
          "username": username,
          "updateKey": "babies",
          "updateValue": babiesList
        }));
  }

  Future<List<BabyDetails>> displayBabyProfile(String username) async {
    var getUserURI = Uri.parse(userCRUDURI + "?username=" + username);
    try {
      final response = await http.get(getUserURI, headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "*/*",
        'authorizationToken': authToken
      });
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final babyList = extractedData["babies"];
      List<BabyDetails> babyDetails = [];
      for (final baby in babyList) {
        babyDetails.add(BabyDetails(
            babyFirstName: baby['firstName']!,
            babyLastName: baby['lastName']!,
            dob: baby['dob']!,
            relation: baby['relation']!,
            gender: baby['gender']!));
      }
      return babyDetails;
    } catch (error) {
      throw (error);
    }
  }
}
