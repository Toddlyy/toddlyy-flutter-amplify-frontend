import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/login_page.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/signup_page.dart';
import 'package:toddlyybeta/user_profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toddlyybeta/providers.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/baby_profile.dart';

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

    // Use addPlugins function to add more than one Amplify plugins
    await Amplify.addPlugin(auth);
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
            appBar: AppBar(
              title: Text('Toddlyy'),
            ),
            body: _amplifyConfigured
                ? checkAuthStatus
                    ? userLoggedIn.getUserCurrentState()
                        ? BabyProfileScreen()
                        : LoginPage()
                    : SignUpPage()
                : Text('Loading')),
        routes: {
          BabyProfileScreen.routeName: (ctx) => BabyProfileScreen(),
        });
  }

  Future<void> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      userLoggedIn.setUserCurrentState(false);
      debugPrint("User signed out");
    } on AuthException catch (e) {}
  }

  getUserStatus() {
    handleAuth().then((val) {
      if (val.isSignedIn) {
        userLoggedIn.setUserCurrentState(val.isSignedIn);
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
