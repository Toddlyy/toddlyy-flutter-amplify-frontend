import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/screens/login_page.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/screens/signup_page.dart';
import 'package:toddlyybeta/user_profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toddlyybeta/widgets/circular_progress.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/screens/display_baby_profile.dart';
import 'package:toddlyybeta/screens/edit_baby_profile.dart';
import 'package:toddlyybeta/screens/edit_user_profile.dart';
import 'package:toddlyybeta/screens/display_user_profile.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';
import 'package:toddlyybeta/constants.dart';

void main() => runApp(ProviderScope(child: MainApp()));

class MainApp extends StatefulHookWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _amplifyConfigured = false;
  bool checkAuthStatus = false;

  var userLoggedIn;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    final auth = AmplifyAuthCognito();
    final s3 = AmplifyStorageS3();

    // Use addPlugins function to add more than one Amplify plugins
    await Amplify.addPlugins([auth, s3]);
    bool ans = userLoggedIn.getUserCurrentState();
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print('Amplify already configured');
    }

    try {
      // signOutUser();
      getUserStatus();
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    userLoggedIn = useProvider(UserLoggedInProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.ora,
          //   title: Text('Toddlyy'),
          // ),
          body: _amplifyConfigured
              ? checkAuthStatus
                  ? userLoggedIn.getUserCurrentState()
                      // ? BottomNavBar(
                      //     currentScreen: 0,
                      //   )
                      ? BottomNavBar(currentScreen: HOME_PAGE)
                      : LoginPage()
                  : SignUpPage()
              : Center(child: CircularProgressIndicator())
        ));
  }

  Future<void> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      userLoggedIn.setUserCurrentState(false);
      userLoggedIn.setUsername("");
      debugPrint("User signed out");
    } on AuthException catch (e) {}
  }

  getUserStatus() {
    handleAuth().then((val) async {
      if (val.isSignedIn) {
        userLoggedIn.setUserCurrentState(val.isSignedIn);
        var currentUser = await Amplify.Auth.getCurrentUser();
        String username = currentUser.userId;
        userLoggedIn.setUsername(username);
        setState(() {
          checkAuthStatus = true;
        });
      }
    });
    return LoginPage();
  }

  handleAuth() async {
    var authStatus = await Amplify.Auth.fetchAuthSession();
    return authStatus;
  }
}
