import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/constants.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/backend_services/bookings_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';
import 'package:toddlyybeta/widgets/outlined_next_focusable_textform_field.dart';
import 'package:intl/intl.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';
import 'package:toddlyybeta/widgets/circular_progress.dart';

class BookSlot extends StatefulHookWidget {
  final String daycareID;
  final String daycareName;
  final String startTime;
  final String endTime;
  final List<dynamic> charges;
  const BookSlot(
      {Key? key,
      required this.daycareID,
      required this.daycareName,
      required this.charges,
      required this.startTime,
      required this.endTime})
      : super(key: key);

  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
  var usernameProvider;

  double? charge;
  var totalHoursText = "";
  String chargeText = "";
  String paymentText = "";

  TimeOfDay dropTime = TimeOfDay.now();
  TimeOfDay pickUpTime = TimeOfDay.now();
  DateTime? pickedDate;
  TextEditingController _dateOfBooking = TextEditingController();

  TextEditingController _dropTime = TextEditingController();
  TextEditingController _pickUpTime = TextEditingController();

  void calculateTotalHoursAndCharge(
      TimeOfDay dropTime, TimeOfDay pickUpTime, List<dynamic> charges) {
    if ((_dropTime.text != '') &&
        (_pickUpTime.text != '') &&
        (_dateOfBooking.text != '')) {
      int dropTimeInMinutes = dropTime.hour * 60 + dropTime.minute;
      int pickUpTimeInMinutes = pickUpTime.hour * 60 + pickUpTime.minute;

      if (dropTimeInMinutes >= pickUpTimeInMinutes) {
        setState(() {
          totalHoursText =
              "Drop Time should be before Pick Up Time.\nPlease try again!";
          chargeText = "";
          paymentText = "";
        });
      } else {
        int totalHours =
            ((pickUpTimeInMinutes - dropTimeInMinutes) / 60).ceil();
        if (totalHours > 12) {
          setState(() {
            totalHoursText = "Daycare not available for these timings";
            chargeText = "";
            paymentText = "";
          });
        } else {
          setState(() {
            totalHoursText = totalHours.toString() + " Hours";
            charge = charges[totalHours - 1];
            chargeText = "₹" + charge.toString();
            paymentText =
                "*Payment to be done via cash or UPI at the daycare center";
          });
        }
      }
    }
  }

  String createISO8601String(DateTime? date, TimeOfDay time) {
    if (date != null) {
      date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      return date.toIso8601String();
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    String username = usernameProvider.getUsername();

    int totalHours;

    void _showDropTimePicker() {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      ).then((value) {
        setState(() {
          dropTime = value!;

          _dropTime.text = formatTimeOfDay(value);
        });
        calculateTotalHoursAndCharge(dropTime, pickUpTime, widget.charges);
      });
    }

    void _showPickUpTimePicker() {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      ).then((value) {
        setState(() {
          pickUpTime = value!;
          _pickUpTime.text = formatTimeOfDay(value);
        });
        calculateTotalHoursAndCharge(dropTime, pickUpTime, widget.charges);
      });
    }

    if (usernameProvider.getUserCurrentState() && username != "") {
      UserCRUDService userCRUDService = new UserCRUDService();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Book Slot in " + widget.daycareName),
        ),
        body: FutureBuilder(
            future: userCRUDService.displayBabyProfile(username),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<BabyDetails> babyDetails = snapshot.data!;
                if (babyDetails.length != 0) {
                  // if (true) {
                  return ListView(
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "*You can book any time from " +
                                    widget.startTime +
                                    " - " +
                                    widget.endTime,
                                textAlign: TextAlign.center,
                                // softWrap: true,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        OutlinedAutomatedNextFocusableTextFormField(
                          // TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please select a Date for Booking';
                            else
                              null;
                          },
                          controller: _dateOfBooking,
                          labelText: 'Date',
                          inputType: TextInputType.datetime,
                          icon: Icon(Icons.calendar_today_rounded,
                              color: Colors.orange),
                          onTap: () async {
                            // Below line stops keyboard from appearing
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            // Show Date Picker Here
                            pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 10)));
                            if (pickedDate != null) {
                              setState(() {
                                _dateOfBooking.text = DateFormat('dd-MM-yyyy')
                                    .format(pickedDate!);
                              });
                              calculateTotalHoursAndCharge(
                                  dropTime, pickUpTime, widget.charges);
                            }
                          },
                        ),
                        OutlinedAutomatedNextFocusableTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please select Drop Time';
                              else
                                null;
                            },
                            controller: _dropTime,
                            labelText: 'Drop Time',
                            inputType: TextInputType.datetime,
                            icon: Icon(
                              Icons.access_time_filled_outlined,
                              color: Colors.orange,
                            ),
                            onTap: _showDropTimePicker),
                        OutlinedAutomatedNextFocusableTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please select Pick Up Time';
                              else
                                null;
                            },
                            controller: _pickUpTime,
                            labelText: 'Pick up Time',
                            inputType: TextInputType.datetime,
                            icon: Icon(Icons.access_time_filled_outlined,
                                color: Colors.orange),
                            onTap: _showPickUpTimePicker),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            BookingCRUDService bookingCRUDService =
                                new BookingCRUDService();
                            bookingCRUDService.createBooking(
                                username,
                                babyDetails[0].babyFirstName +
                                    " " +
                                    babyDetails[0].babyLastName,
                                widget.daycareID,
                                widget.daycareName,
                                createISO8601String(pickedDate, dropTime),
                                createISO8601String(pickedDate, pickUpTime),
                                charge!,
                                "Awaiting Confirmation");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 7),
                                content: Text(
                                    'Thanks for booking using Toddlyy.\nWe will be responding to you soon! \nThe booking status will also be updated on the Bookings Tab')));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CircularIndicator(
                                          nextScreenIndex: BOOKINGS_PAGE,
                                        )),
                                ((route) => false));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            "Book Slot",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              totalHoursText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              chargeText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              paymentText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ]);
                } else {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "Please fill your Baby's Profile before making a booking",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                // letterSpacing: 2.2,
                                color: Colors.black)),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBar(
                                          currentScreen: BABY_PROFILE_PAGE,
                                        )),((route) => false));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            "Fill Baby Profile",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 0.8,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }),

        //To shift button to the bottom of screen
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.transparent,
        //   child: ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (context) => BottomNavBar(
        //                                   currentScreen: BABY_PROFILE_PAGE,
        //                                 )));
        //                   },
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: Colors.deepOrange,
        //                     padding: EdgeInsets.symmetric(horizontal: 50),
        //                     elevation: 2,
        //                     shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(20)),
        //                   ),
        //                   child: Text(
        //                     "Fill Baby Profile",
        //                     style: TextStyle(
        //                         fontSize: 14,
        //                         letterSpacing: 2.2,
        //                         color: Colors.white),
        //                   ),
        //                 ),
        //   elevation: 0,
        // ),
      )
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

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); //"6:00 AM"
  return format.format(dt);
}

TimeOfDay stringToTimeOfDay(String time) {
  int hh = 0;
  if (time.endsWith('PM')) hh = 12;
  time = time.split(' ')[0];
  return TimeOfDay(
    hour: hh +
        int.parse(time.split(":")[0]) %
            24, // in case of a bad time format entered manually by the user
    minute: int.parse(time.split(":")[1]) % 60,
  );
}
