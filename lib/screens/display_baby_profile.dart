import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/screens/fill_baby_profile.dart';
import 'package:toddlyybeta/widgets/date_of_birth_widget.dart';
import 'package:toddlyybeta/assets/icon_class_icons.dart';

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
            backgroundColor: Colors.orange,
            title: Text('Baby Profile'),
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
                    // Future.delayed(Duration.zero, () {
                    //   // Navigator.pushReplacement(
                    //   //     context,
                    //   //     MaterialPageRoute(
                    //   //         builder: (context) => FillBabyProfilePage()));
                    //   FillBabyProfilePage();
                    // });
                    return Scaffold(body: FillBabyProfilePage());
                    // return SizedBox(
                    //   height: MediaQuery.of(context).size.height / 0.8,
                    //   child: Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // );
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
                                    prefixIcon: Icon(
                                        color: Colors.orange,
                                        IconClass
                                            .baby_head_with_a_small_heart_outline),
                                    labelText: 'First Name'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _babyLastNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        color: Colors.orange,
                                        IconClass
                                            .baby_head_with_a_small_heart_outline),
                                    labelText: 'Last Name'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _dobController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        color: Colors.orange,
                                        Icons.calendar_today),
                                    labelText: 'Date of Birth'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _genderController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        color: Colors.orange,
                                        IconClass.children),
                                    labelText: 'Gender'),
                              ),
                              TextField(
                                readOnly: true,
                                controller: _relationController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        color: Colors.orange,
                                        IconClass.mother_and_son),
                                    labelText: 'Your Relation with baby'),
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 0.8,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
              }));
    } else {
      return Scaffold(
          body:
              Text("User doesn't have permissions to view Baby Profile Page"));
    }
  }
}
