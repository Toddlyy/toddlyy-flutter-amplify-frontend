import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/constants.dart';
import 'package:toddlyybeta/models/user_model.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/widgets/date_of_birth_widget.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';
import 'package:toddlyybeta/widgets/circular_progress.dart';

class EditUserProfilePage extends StatefulHookWidget {
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  bool showPassword = false;
  var usernameProvider;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _gmailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  final _userFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    String username = usernameProvider.getUsername();
    if (usernameProvider.getUserCurrentState() && username != "") {
      UserCRUDService userCRUDService = new UserCRUDService();
      return Scaffold(
              // appBar: AppBar(
              //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //   elevation: 1,
              //   leading: IconButton(
              //     icon: Icon(
              //       Icons.arrow_back,
              //       color: Colors.green,
              //     ),
              //     onPressed: () {},
              //   ),
              //   actions: [
              //     IconButton(
              //       icon: Icon(
              //         Icons.settings,
              //         color: Colors.green,
              //       ),
              //       onPressed: () {
              //         // Navigator.of(context).push(MaterialPageRoute(
              //         //     builder: (BuildContext context) => SettingsPage()));
              //       },
              //     ),
              //   ],
              // ),
              body: FutureBuilder(
                  future: userCRUDService.displayUserProfile(username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      UserDetails userDetails = snapshot.data!;

                      _firstNameController.text = userDetails.firstName;
                      _lastNameController.text = userDetails.lastName;

                      _phoneNoController.text = userDetails.phoneNo;
                      _gmailController.text = userDetails.gmail;
                      _addressController.text = userDetails.address;

                      return Container(
                        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                        // child: GestureDetector(
                        //   onTap: () {
                        //     // FocusScope.of(context).unfocus();
                        //   },
                        child: ListView(
                          children: [
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // Center(
                            //   child: Stack(
                            //     children: [
                            //       Container(
                            //         width: 130,
                            //         height: 130,
                            //         decoration: BoxDecoration(
                            //             border: Border.all(
                            //                 width: 4,
                            //                 color: Theme.of(context).scaffoldBackgroundColor),
                            //             boxShadow: [
                            //               BoxShadow(
                            //                   spreadRadius: 2,
                            //                   blurRadius: 10,
                            //                   color: Colors.black.withOpacity(0.1),
                            //                   offset: Offset(0, 10))
                            //             ],
                            //             // shape: BoxShape.circle,
                            //             // image: DecorationImage(
                            //             //     fit: BoxFit.cover,
                            //             //     image: NetworkImage(
                            //             //       "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                            //             //     ))
                            //                 ),
                            //       ),
                            //       // Positioned(
                            //       //     bottom: 0,
                            //       //     right: 0,
                            //       //     child: Container(
                            //       //       height: 40,
                            //       //       width: 40,
                            //       //       decoration: BoxDecoration(
                            //       //         shape: BoxShape.circle,
                            //       //         border: Border.all(
                            //       //           width: 4,
                            //       //           color: Theme.of(context).scaffoldBackgroundColor,
                            //       //         ),
                            //       //         color: Colors.green,
                            //       //       ),
                            //       //       child: Icon(
                            //       //         Icons.edit,
                            //       //         color: Colors.white,
                            //       //       ),
                            //       //     )),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 35,
                            // ),
                            Form(
                                key: _userFormKey,
                                child: Column(children: <Widget>[
                                  TextFormField(
                                      controller: _firstNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Please enter your first name';
                                        else
                                          null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'First Name'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),
                                  TextFormField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                          labelText: 'Last Name'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),
                                  TextFormField(
                                      readOnly: true,
                                      controller: _phoneNoController,
                                      decoration: InputDecoration(
                                          labelText: 'Phone No'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),
                                  TextFormField(
                                      controller: _gmailController,
                                      decoration:
                                          InputDecoration(labelText: 'Gmail'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),
                                  TextFormField(
                                      controller: _addressController,
                                      maxLines: 4,
                                      decoration:
                                          InputDecoration(labelText: 'Address'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),
                                ])),
                            SizedBox(
                              height: 35,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BottomNavBar(
                                                  currentScreen: USER_PROFILE_PAGE,
                                                )));
                                  },
                                  child: Text("CANCEL",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2.2,
                                          color: Colors.black)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_userFormKey.currentState!.validate()) {
                                      var updatedDetails =
                                          new Map<String, String>();
                                      if (_firstNameController.text !=
                                          userDetails.firstName)
                                        updatedDetails['firstName'] =
                                            _firstNameController.text;
                                      if (_lastNameController.text !=
                                          userDetails.lastName)
                                        updatedDetails['lastName'] =
                                            _lastNameController.text;
                                      if (_gmailController.text !=
                                          userDetails.gmail)
                                        updatedDetails['gmail'] =
                                            _gmailController.text;
                                      if (_addressController.text !=
                                          userDetails.address)
                                        updatedDetails['address'] =
                                            _addressController.text;

                                      String username =
                                          usernameProvider.getUsername();
                                      if (usernameProvider
                                              .getUserCurrentState() &&
                                          username != "") {
                                        UserCRUDService userCRUDService =
                                            new UserCRUDService();
                                        userCRUDService.editUserProfile(
                                            username, updatedDetails);
                                      }
                                      Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CircularIndicator(nextScreenIndex: USER_PROFILE_PAGE,)));

                                      // Future.delayed(Duration(seconds: 15), () {
                                      //   CircularProgressIndicator();
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               BottomNavBar(
                                      //                   currentScreen: 2)));
                                      // });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             BottomNavBar(
                                      //                 currentScreen: 2)));
                                    } else {
                                      debugPrint(
                                          "User not logged in still edit Baby Info");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  child: Text(
                                    "SAVE",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        // )
                        // ,
                      );
                    } else
                      return CircularProgressIndicator();
                  }))
          // )
          ;
    } else {
      return MaterialApp(
          home: Scaffold(
              body: Text(
                  "User doesn't have permissions to view Edit Baby Profile Page")));
    }
  }
}
