import 'dart:convert';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
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
    final response = await http.post(createUserURI, headers: <String, String>{
      'Content-Type': 'application/json',
      "Accept": "*/*",
      'authorizationToken': authToken
    }, body: jsonEncode({
      "username": username,
      "phoneNo": phoneNumber,
      "firstName": firstName,
      "lastName": lastName
    }));
  }
}
