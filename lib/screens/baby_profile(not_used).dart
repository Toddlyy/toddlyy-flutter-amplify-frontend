import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/providers.dart';

class BabyProfileScreen extends StatefulHookWidget {
  const BabyProfileScreen({super.key});
  static const routeName = "/fill-baby-profile";

  @override
  State<BabyProfileScreen> createState() => _BabyProfileScreenState();
}

class _BabyProfileScreenState extends State<BabyProfileScreen> {
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _babyFirstNameController = TextEditingController();
  TextEditingController _babyLastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _relationController = TextEditingController();

  var usernameProvider;

  final _relationsList = ["Father", "Mother", "Guardian"];

  final _gendersList = ["Male", "Female", "Others"];

  String? _selectedRelation;

  String? _selectedGender;

  final _babyFormKey = GlobalKey<FormState>();

  final _dateFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Baby Profile'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _babyFormKey,
              child: ListView(children: <Widget>[
                TextFormField(
                    controller: _babyFirstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter name of the Baby';
                      else
                        null;
                    },
                    decoration:
                        InputDecoration(labelText: 'First Name of Baby'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_dateFocusNode);
                    }),
                TextFormField(
                    controller: _babyLastNameController,
                    decoration: InputDecoration(labelText: 'Last Name of Baby'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_dateFocusNode);
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
                    FocusScope.of(context).requestFocus(new FocusNode());

                    // Show Date Picker Here
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now());
                    if (pickedDate != null) {
                      setState(() {
                        _dateOfBirthController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
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
                        color: Colors.orange, Icons.arrow_drop_down_circle),
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
                      setState(() {
                        _selectedRelation = val as String;
                      });
                    },
                    icon: const Icon(
                        color: Colors.orange, Icons.arrow_drop_down_circle),
                    dropdownColor: Colors.orangeAccent,
                    decoration: InputDecoration(
                        labelText: "Relation with child",
                        prefixIcon: Icon(
                            color: Colors.orange,
                            Icons.accessibility_new_rounded),
                        border: UnderlineInputBorder())),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
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
                        UserCRUDService userCRUDService = new UserCRUDService();
                        userCRUDService.createBabyUser(
                            username,
                            babyDetails.babyFirstName,
                            babyDetails.babyLastName,
                            babyDetails.dob,
                            babyDetails.relation,
                            babyDetails.gender);
                      }
                    } else {
                      debugPrint("User not logged in still edit Baby Info");
                    }
                  },
                  child: Text(
                    "Submit Details".toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                )
              ]),
            )));
  }
}
