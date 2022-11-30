import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DaycareDetails with ChangeNotifier {
  late String daycareName;
  late String daycareID;
  late bool accepting;
  late String address;
  late String startTime;
  late String endTime;
  late List<dynamic> features;
  late String image;
  late List<dynamic> timeSlots;
  late bool openOnWeekends;
  late String region;
  late String phoneNo;
  late List<dynamic> charges;

  DaycareDetails(
      {required this.daycareName,
      required this.daycareID,
      this.accepting = true,
      required this.address,
      required this.startTime,
      required this.endTime,
      required this.features,
      required this.image,
      required this.timeSlots,
      this.openOnWeekends = true,
      required this.region,
      required this.phoneNo,
      required this.charges});
}
