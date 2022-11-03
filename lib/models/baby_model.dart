import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class BabyDetails with ChangeNotifier {
  late String babyFirstName;
  late String babyLastName;
  late String dob;
  late String relation;
  late String gender;

  BabyDetails(
      {required this.babyFirstName,
      this.babyLastName = "",
      required this.dob,
      required this.relation,
      required this.gender});
}
