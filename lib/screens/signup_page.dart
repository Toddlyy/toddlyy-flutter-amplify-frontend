import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/screens/login_page.dart';
import 'package:toddlyybeta/user_profile.dart';
import 'package:toddlyybeta/providers.dart';
import '../amplifyconfiguration.dart';

import 'package:toddlyybeta/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

String phoneNumber1(number) {
  String newNumber;
  if (number.length == 12 && number.startsWith('91')) {
    newNumber = number.substring(2);
  } else if (number.length == 13 && number.startsWith('+91')) {
    newNumber = number.substring(3);
  } else {
    newNumber = number;
  }
  return newNumber;
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _activationCodeController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _activationCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();

    //   if (checkIfUserSignedIn() == 'true')
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => UserProfileScreen()));
  }

  @override
  void dispose() {
    _activationCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _signUpUser(String phoneNumber) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: phoneNumber,
        password: "admin**ADMIN12",
        options: CognitoSignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.phoneNumber: phoneNumber,
          },
        ),
      );
    } on AuthException catch (e) {
      print(e.message);
    }
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm the user'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Check your phone number and enter the code below'),
            OutlinedAutomatedNextFocusableTextFormField(
              controller: _activationCodeController,
              padding: const EdgeInsets.only(top: 16),
              labelText: 'Activation Code',
              inputType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Amplify.Auth.confirmSignUp(
                username: phoneNumber,
                confirmationCode: _activationCodeController.text,
              ).then((result) {
                if (result.isSignUpComplete) {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text('Your accout is created!'),
                              content: const Text(
                                  "Thanks for creating an account, please verify your phone number once again for Signing In"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Sign In'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                ),
                              ]));
                } else {
                  Navigator.of(context).pop();
                  debugPrint("Incorrect activation code");
                }
              });
            },
          ),
        ],
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Sign Up'),
      ),
      body:
          // FutureBuilder<void>(
          // future: _configureAmplify(),
          // builder: (context, snapshot) {
          //   if (snapshot.connectionState == ConnectionState.done) {
          // return
          ListView(
        children: [
          //TextButton(onPressed: () {}, child: Text("Hello"),),

          Row(
            children: [
              Image.asset(
                  height: 60,
                  width: 60,
                  'icons/flags/png/in.png',
                  package: 'country_icons'),
              Expanded(
                child: OutlinedAutomatedNextFocusableTextFormField(
                  controller: _phoneNumberController,
                  labelText: 'Phone Number(+91)',
                  inputType: TextInputType.phone,
                ),
              )
            ],
          ),
          /*
            OutlinedAutomatedNextFocusableTextFormField(

              controller: _phoneNumberController,
              labelText: 'Phone Number',
              inputType: TextInputType.phone,
              
               
            ),
            */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final phoneNumber =
                    '+91' + phoneNumber1(_phoneNumberController.text);
                if (phoneNumber.isEmpty) {
                  debugPrint('Phone number is empty. Not ready to submit.');
                } else {
                  // if (await _signInUser(phoneNumber)) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => UserProfileScreen()));
                  // }
                  _signUpUser(phoneNumber);
                }
              },
              child: const Text('Sign Up'),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text("Already created a user? Click to Sign In"))
        ],
      ),
    );
    // }
    // if (snapshot.hasError) {
    //   return Text('Some error happened: ${snapshot.error}');
    // } else {
    //   return const Center(child: CircularProgressIndicator());
    // }
  }
  // )

}

class OutlinedAutomatedNextFocusableTextFormField extends StatelessWidget {
  const OutlinedAutomatedNextFocusableTextFormField({
    this.padding = const EdgeInsets.all(8),
    this.obscureText = false,
    this.labelText,
    this.controller,
    this.inputType,
    Key? key,
  }) : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final EdgeInsets padding;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
