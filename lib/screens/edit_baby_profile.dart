import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/constants.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/widgets/date_of_birth_widget.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';
import 'package:toddlyybeta/widgets/circular_progress.dart';
import 'package:toddlyybeta/assets/icon_class_icons.dart';

class EditBabyProfilePage extends StatefulHookWidget {
  @override
  _EditBabyProfilePageState createState() => _EditBabyProfilePageState();
}

class _EditBabyProfilePageState extends State<EditBabyProfilePage> {
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

  final _babyFormKey = GlobalKey<FormState>();

  final _dateFocusNode = FocusNode();

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
              appBar: AppBar(
                backgroundColor: Colors.orange,
                title: Text('Edit Baby Profile'),
              ),
              body: FutureBuilder(
                  future: userCRUDService.displayBabyProfile(username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<BabyDetails> babyDetails = snapshot.data!;
                      //final babyDetails = snapshot.data;

                      _babyFirstNameController.text =
                          babyDetails[0].babyFirstName;
                      _babyLastNameController.text =
                          babyDetails[0].babyLastName;

                      // _dateOfBirthController.text = babyDetails[0].dob;
                      updatedDateOfBirth = babyDetails[0].dob;
                      _selectedRelation = babyDetails[0].relation;
                      _selectedGender = babyDetails[0].gender;

                      return Container(
                        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                        // child: GestureDetector(
                        //   onTap: () {
                        //     // FocusScope.of(context).unfocus();
                        //   },
                        child: ListView(
                          children: [
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
                                          prefixIcon: Icon(
                                              color: Colors.orange,
                                              IconClass
                                                  .baby_head_with_a_small_heart_outline),
                                          labelText: 'First Name of Baby'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),

                                  TextFormField(
                                      controller: _babyLastNameController,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              color: Colors.orange,
                                              IconClass
                                                  .baby_head_with_a_small_heart_outline),
                                          labelText: 'Last Name of Baby'),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        // FocusScope.of(context).requestFocus(_dateFocusNode);
                                      }),

                                  DropdownButtonFormField(
                                      value: babyDetails[0].gender,
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
                                              IconClass.children),
                                          border: UnderlineInputBorder())),
                                  DropdownButtonFormField(
                                      value: babyDetails[0].relation,
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
                                              IconClass.mother_and_son),
                                          border: UnderlineInputBorder())),
                                  dateOfBirthWidget(
                                    dateOfBirth: babyDetails[0].dob,
                                    callback: (value) {
                                      updatedDateOfBirth = value;
                                    },
                                  ),
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
                                                  currentScreen:
                                                      BABY_PROFILE_PAGE,
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
                                          babyFirstName:
                                              _babyFirstNameController.text,
                                          babyLastName:
                                              _babyLastNameController.text,
                                          dob: updatedDateOfBirth,
                                          relation: _selectedRelation!,
                                          gender: _selectedGender!);

                                      // babyDetails.dob = _dateOfBirthController.text;
                                      // babyDetails.relation = _selectedRelation!;
                                      // babyDetails.babyFirstName = _babyFirstNameController.text;
                                      // babyDetails.babyLastName = _babyLastNameController.text;
                                      // babyDetails.gender = _genderController.text;

                                      String username =
                                          usernameProvider.getUsername();
                                      if (usernameProvider
                                              .getUserCurrentState() &&
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
                                                builder: (context) =>
                                                    CircularIndicator(
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
                                    backgroundColor: Colors.deepOrange,
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
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 0.8,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
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
