import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toddlyybeta/user_profile.dart';

import 'amplifyconfiguration.dart';
import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // fetchAuthSession();
  }

  Future<void> fetchAuthSession() async {
    try {
      // CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
      //   options: CognitoSessionOptions(getAWSCredentials: true),
      // ) as CognitoAuthSession;
      var getUserURI = Uri.parse(
          'https://b8hs1ht2ah.execute-api.ap-south-1.amazonaws.com/dev/getuser/2');

      // CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
      //         options: CognitoSessionOptions(getAWSCredentials: true))
      //     as CognitoAuthSession;
      var _currentUser = await Amplify.Auth.getCurrentUser();

      String authToken =
          "hs0fqkufqomtg7duiltaxr56s115je5yvfbc0gj3jpg4d1itm684uvjtdli6";

      // String authToken = session.userPoolTokens!.accessToken;
      final response = await http.get(getUserURI, headers: <String, String>{
        'Content-Type': 'application/json',
        "Accept": "*/*",
        'authorizationToken': authToken
      });
      print("Response =" + response.body);
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('You are logged in to User profile page'));
  }
}
