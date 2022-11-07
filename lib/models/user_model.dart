import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserDetails with ChangeNotifier {
  late String firstName;
  late String lastName;
  late String phoneNo;
  late String gmail;
  late String address;

  UserDetails(
      {required this.firstName,
      this.lastName = "",
      required this.phoneNo,
      this.gmail="",
      this.address=""});
}
