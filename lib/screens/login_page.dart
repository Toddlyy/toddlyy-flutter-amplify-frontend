import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';
import 'package:toddlyybeta/user_profile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/screens/baby_profile.dart';

class LoginPage extends StatefulHookWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _activationCodeController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  var userSignedIn;

  @override
  void initState() {
    super.initState();
    _activationCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    userSignedIn = useProvider(UserLoggedInProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body:
            // FutureBuilder<void>(
            //     // future: _configureAmplify(),
            //     builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.done) {
            //   return
            ListView(
          children: [
            OutlinedAutomatedNextFocusableTextFormField(
              controller: _firstNameController,
              labelText: 'First Name',
              inputType: TextInputType.name,
            ),
            OutlinedAutomatedNextFocusableTextFormField(
              controller: _lastNameController,
              labelText: 'Last Name',
              inputType: TextInputType.name,
            ),
            OutlinedAutomatedNextFocusableTextFormField(
              controller: _phoneNumberController,
              labelText: 'Phone Number',
              inputType: TextInputType.phone,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final phoneNumber = _phoneNumberController.text;
                  final firstName = _firstNameController.text;
                  final lastName = _lastNameController.text;
                  if (phoneNumber.isEmpty) {
                    debugPrint(
                        'One of the fields is empty. Not ready to submit.');
                  } else if (firstName.isEmpty) {
                    debugPrint('First Name is empty. Not reaady to submit');
                  } else {
                    // if (await _signInUser(phoneNumber)) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => UserProfileScreen()));
                    // }
                    _signInUser(phoneNumber, firstName, lastName, userSignedIn);
                  }
                },
                child: const Text('Sign In'),
              ),
            ),
          ],
        ));
    // }
    // if (snapshot.hasError) {
    //   return Text('Some error happened: ${snapshot.error}');
    // } else {
    //   return const Center(child: CircularProgressIndicator());
    // }
  }
  // )
  //       ,
  // );
  // }

  Future<bool> checkIfUserSignedIn() async {
    final cognitoAuthSession = await Amplify.Auth.fetchAuthSession();

    final result = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    ) as CognitoAuthSession;
    if (result.isSignedIn) {
      print('Already signed in');
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => UserProfileScreen()));
      return true;
    }
    return false;
  }

  Future<void> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      userSignedIn.setUserCurrentState(false);
      userSignedIn.setUsername("");
      debugPrint("User signed out");
    } on AuthException catch (e) {}
  }

  Future<void> _signInUser(String phoneNumber, String firstName,
      String lastName, userSignedIn) async {
    await signOutUser();

    print('Not signed in so sending activation code to sign in');
    final result = await Amplify.Auth.signIn(
      username: phoneNumber,
      password: "admin**ADMIN12",
    );

    if (result.isSignedIn) {
      var currentUser = await Amplify.Auth.getCurrentUser();
      String username = currentUser.userId;
      userSignedIn.setUsername(username);
      userSignedIn.setUserCurrentState(result.isSignedIn);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavBar(
                    currentScreen: 0,
                  )));
    } else {
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
                //Confirms if the sent OTP is correct
                final result = Amplify.Auth.confirmSignIn(
                  confirmationValue: _activationCodeController.text,
                ).then((result) async {
                  if (result.isSignedIn) {
                    var currentUser = await Amplify.Auth.getCurrentUser();
                    String username = currentUser.userId;
                    userSignedIn.setUserCurrentState(result.isSignedIn);
                    userSignedIn.setUsername(username);

                    //push user to DynamoDB
                    UserCRUDService userCRUDService = new UserCRUDService();
                    userCRUDService.createUser(
                        username, phoneNumber, firstName, lastName);
                    Navigator.of(context).pop();
                    // fetchAuthSession();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => UserProfileScreen()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBar(
                                  currentScreen: 0,
                                )));
                  } else {
                    debugPrint("Not signed in");
                  }
                });
              },
            ),
          ],
        ),
      );
    }
  }
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
