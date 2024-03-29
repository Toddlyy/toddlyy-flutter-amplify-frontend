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
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

String get10DigitPhoneNumber(number) {
  String newNumber;
  number = number.replaceAll(' ', '');
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

  Future<void> _dialogBuilder(BuildContext context, String phoneNumber) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm the user'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter the activation code'),
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              try {
                final result = await Amplify.Auth.confirmSignUp(
                  username: phoneNumber,
                  confirmationCode: _activationCodeController.text,
                );

                if (result.isSignUpComplete) {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text('Your account is created!'),
                              content: const Text(
                                  "Thanks for creating an account, please verify your phone number once again for Logging In"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Log In'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        ((route) => false));
                                  },
                                ),
                              ]));
                } else {
                  //Never executed : it always goes to the Exception
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 7),
                      content: Text(
                          'The activation code is incorrect.\nPlease try again')));
                }
              } on CodeMismatchException catch (e) {
                //Don't pop it(let them try with different codes)
                // Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 5),
                    content: Text(
                        'The activation code is incorrect.\nPlease try again!')));
              } catch (e) {}
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signUpUser(String phoneNumber) async {
    bool USER_ALREADY_VERIFIED = false;
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
    } on UsernameExistsException catch (e) {
      try {
        final String status;
        final userPool = CognitoUserPool(
          'ap-south-1_hRGKTCYWt',
          '7mv457jsqec41g9ts88a75ru4g',
        );

        final cognitoUser = CognitoUser(phoneNumber, userPool);
        status = await cognitoUser.resendConfirmationCode();
      } on CognitoClientException catch (e) {
        print(e);
        if (e.code == 'InvalidParameterException') {
          USER_ALREADY_VERIFIED = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 7),
              content: Text(
                  'You have already created an account using this phone number. \nPlease directly login')));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              ((route) => false));
        }
      } catch (e) {
        print(e);
      }
    } on AuthException catch (e) {
      print(e.message);
    } on Exception catch (e) {
      print(e);
    } finally {
      if (USER_ALREADY_VERIFIED == false) {
        _dialogBuilder(context, phoneNumber);
      }
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('User Sign Up'),
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
          SizedBox(
            height: 10,
          ),
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
                    '+91' + get10DigitPhoneNumber(_phoneNumberController.text);
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 14, letterSpacing: 2.2, color: Colors.white),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    ((route) => false));
              },
              child: Text(
                "Already created a user? Click here to Log In",
                style: TextStyle(
                    fontSize: 15,
                    //letterSpacing: 2.2,
                    color: Colors.orange),
              ))
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
