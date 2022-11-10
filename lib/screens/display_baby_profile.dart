import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/screens/fill_baby_profile.dart';
import 'package:toddlyybeta/widgets/date_of_birth_widget.dart';

import 'package:toddlyybeta/screens/edit_baby_profile.dart';

class DisplayBabyProfileScreen extends StatefulHookWidget {
  const DisplayBabyProfileScreen({super.key});

  @override
  State<DisplayBabyProfileScreen> createState() =>
      _DisplayBabyProfileScreenState();
}

class _DisplayBabyProfileScreenState extends State<DisplayBabyProfileScreen> {
  var usernameProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    String username = usernameProvider.getUsername();

    TextEditingController _babyFirstNameController = TextEditingController();
    TextEditingController _babyLastNameController = TextEditingController();
    TextEditingController _genderController = TextEditingController();
    TextEditingController _relationController = TextEditingController();
    TextEditingController _dobController = TextEditingController();

    if (usernameProvider.getUserCurrentState() && username != "") {
      UserCRUDService userCRUDService = new UserCRUDService();
      return Scaffold(
          appBar: AppBar(
              // title: Text("Toddlyy"),
              ),
          body: FutureBuilder(
              future: userCRUDService.displayBabyProfile(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<BabyDetails> babyDetails = snapshot.data!;
                  if (babyDetails.length == 0) {
                    _babyFirstNameController.text = "";
                    _babyLastNameController.text = "";
                    _dobController.text = "";
                    _relationController.text = "";
                    _genderController.text = "";
Future.delayed(Duration.zero, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FillBabyProfilePage()));
                            });
                    return CircularProgressIndicator();
                  } else {
                    _babyFirstNameController.text =
                        babyDetails[0].babyFirstName;
                    _babyLastNameController.text = babyDetails[0].babyLastName;

                    // _dateOfBirthController.text = babyDetails[0].dob;
                    _dobController.text = babyDetails[0].dob;
                    _relationController.text = babyDetails[0].relation;
                    _genderController.text = babyDetails[0].gender;

                    return Container(
                        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                        child: ListView(children: [
                          Row(
                            children: [
                              Text(
                                "Baby Profile",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ),
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
                                              EditBabyProfilePage()));
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: <Widget>[
                              TextField(
                                readOnly: true,
                                controller: _babyFirstNameController,
                                decoration: InputDecoration(
                                    labelText: 'First Name of Baby'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _babyLastNameController,
                                decoration: InputDecoration(
                                    labelText: 'Last Name of Baby'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _dobController,
                                decoration:
                                    InputDecoration(labelText: 'Date of Birth'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _genderController,
                                decoration:
                                    InputDecoration(labelText: 'Gender'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _relationController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        color: Colors.orange,
                                        Icons.accessibility_new_rounded),
                                    labelText: 'Relation with child'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),

                          // )
                          // ,
                        ]));
                  }
                } else
                  return CircularProgressIndicator();
              }));
    } else {
      return Scaffold(
          body:
              Text("User doesn't have permissions to view Baby Profile Page"));
    }
  }
}
