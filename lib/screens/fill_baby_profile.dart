import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/constants.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:intl/intl.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';
import 'package:toddlyybeta/widgets/circular_progress.dart';

class FillBabyProfilePage extends StatefulHookWidget {
  @override
  _FillBabyProfilePageState createState() => _FillBabyProfilePageState();
}

class _FillBabyProfilePageState extends State<FillBabyProfilePage> {
  bool showPassword = false;
  var usernameProvider;

  TextEditingController _babyFirstNameController = TextEditingController();
  TextEditingController _babyLastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  String updatedDateOfBirth = "";
  TextEditingController _relationController = TextEditingController();

  final _relationsList = ["Father", "Mother", "Guardian"];

  final _gendersList = ["Male", "Female"];

  String? _selectedRelation;

  String? _selectedGender;

  TextEditingController _dateOfBirthController = TextEditingController();

  final _babyFormKey = GlobalKey<FormState>();

  final _dateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    String username = usernameProvider.getUsername();
    if (usernameProvider.getUserCurrentState() && username != "") {
      UserCRUDService userCRUDService = new UserCRUDService();
      return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.orange,
                title: Text('Fill Baby Profile'),
              ),
              body: Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                // child: GestureDetector(
                //   onTap: () {
                //     // FocusScope.of(context).unfocus();
                //   },
                child: ListView(
                  children: [
                    Form(
                        key: _babyFormKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                              controller: _babyFirstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter name of the Baby';
                                else
                                  null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'First Name of Baby'),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                // FocusScope.of(context).requestFocus(_dateFocusNode);
                              }),

                          TextFormField(
                              controller: _babyLastNameController,
                              decoration: InputDecoration(
                                  labelText: 'Last Name of Baby'),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                // FocusScope.of(context).requestFocus(_dateFocusNode);
                              }),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please enter Baby\'s Date of Birth';
                              else
                                null;
                            },
                            controller: _dateOfBirthController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today_rounded),
                                labelText: "Date of Birth"),
                            onTap: () async {
                              // Below line stops keyboard from appearing
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              // Show Date Picker Here
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime.now());
                              if (pickedDate != null) {
                                setState(() {
                                  _dateOfBirthController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                });
                              }
                            },
                            textInputAction: TextInputAction.next,
                            focusNode: _dateFocusNode,
                          ),

                          DropdownButtonFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter Baby\'s gender';
                                else
                                  null;
                              },
                              items: _gendersList
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                // setState(() {
                                _selectedGender = val as String;
                                // });
                              },
                              icon: const Icon(
                                  color: Colors.orange,
                                  Icons.arrow_drop_down_circle),
                              dropdownColor: Colors.orangeAccent,
                              decoration: InputDecoration(
                                  labelText: "Gender",
                                  prefixIcon: Icon(
                                      color: Colors.orange,
                                      Icons.accessibility_new_rounded),
                                  border: UnderlineInputBorder())),
                          DropdownButtonFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your relation with Baby';
                                else
                                  null;
                              },
                              items: _relationsList
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                // setState(() {
                                _selectedRelation = val as String;
                                // });
                              },
                              icon: const Icon(
                                  color: Colors.orange,
                                  Icons.arrow_drop_down_circle),
                              dropdownColor: Colors.orangeAccent,
                              decoration: InputDecoration(
                                  labelText: "Relation with child",
                                  prefixIcon: Icon(
                                      color: Colors.orange,
                                      Icons.accessibility_new_rounded),
                                  border: UnderlineInputBorder())),
                          // buildTextField("Last Name", "", false),
                          // buildTextField(
                          //     "Date of Birth", "10/10/2010", true),
                          // buildTextField(
                          //     "Relation with Baby", "Guardian", false),
                        ])),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBar(
                                          currentScreen: HOME_PAGE,
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
                            if (_babyFormKey.currentState!.validate()) {
                              BabyDetails babyDetails = BabyDetails(
                                  babyFirstName: _babyFirstNameController.text,
                                  babyLastName: _babyLastNameController.text,
                                  dob: _dateOfBirthController.text,
                                  relation: _selectedRelation!,
                                  gender: _selectedGender!);

                              // babyDetails.dob = _dateOfBirthController.text;
                              // babyDetails.relation = _selectedRelation!;
                              // babyDetails.babyFirstName = _babyFirstNameController.text;
                              // babyDetails.babyLastName = _babyLastNameController.text;
                              // babyDetails.gender = _genderController.text;

                              String username = usernameProvider.getUsername();
                              if (usernameProvider.getUserCurrentState() &&
                                  username != "") {
                                UserCRUDService userCRUDService =
                                    new UserCRUDService();
                                userCRUDService.createBabyUser(
                                    username,
                                    babyDetails.babyFirstName,
                                    babyDetails.babyLastName,
                                    babyDetails.dob,
                                    babyDetails.relation,
                                    babyDetails.gender);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CircularIndicator(
                                              nextScreenIndex:
                                                  BABY_PROFILE_PAGE,
                                            )));
                              }
                            } else {
                              debugPrint(
                                  "User not logged in still edit Baby Info");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
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
              ))
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
