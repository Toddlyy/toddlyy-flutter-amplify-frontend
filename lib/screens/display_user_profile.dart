import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/models/user_model.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/widgets/date_of_birth_widget.dart';
import 'package:toddlyybeta/screens/edit_user_profile.dart';

class DisplayUserProfilePage extends StatefulHookWidget {
  @override
  _DisplayUserProfilePageState createState() => _DisplayUserProfilePageState();
}

class _DisplayUserProfilePageState extends State<DisplayUserProfilePage> {
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
              appBar: AppBar(
                backgroundColor: Colors.orange,
                title: Text('User Profile'),
              ),
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
                            Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  // padding:EdgeInsets.only(left: 150.0),
                                  iconSize: 30,
                                  color: Colors.deepOrange,

                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditUserProfilePage()));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(children: <Widget>[
                              TextFormField(
                                readOnly: true,
                                controller: _firstNameController,
                                decoration:
                                    InputDecoration(labelText: 'First Name'),
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _lastNameController,
                                decoration:
                                    InputDecoration(labelText: 'Last Name'),
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _phoneNoController,
                                decoration:
                                    InputDecoration(labelText: 'Phone No'),
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _gmailController,
                                decoration: InputDecoration(labelText: 'Gmail'),
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _addressController,
                                decoration:
                                    InputDecoration(labelText: 'Address'),
                                maxLines: 4,
                              ),
                            ]),
                            SizedBox(
                              height: 35,
                            ),
                          ],
                        ),
                        // )
                        // ,
                      );
                    } else
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 0.8,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    ;
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
