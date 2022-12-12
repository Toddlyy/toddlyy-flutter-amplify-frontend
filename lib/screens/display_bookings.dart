import 'package:intl/intl.dart';
import 'package:toddlyybeta/backend_services/bookings_crud.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/screens/show_daycare_details.dart';
import 'package:toddlyybeta/assets/icon_class_icons.dart';
import 'package:toddlyybeta/assets/status_icon_icons.dart';

class DisplayBookings extends StatefulHookWidget {
  const DisplayBookings({super.key});

  @override
  State<DisplayBookings> createState() => _DisplayBookingsState();
}

class _DisplayBookingsState extends State<DisplayBookings> {
  var usernameProvider;
  List<dynamic> bookingsList = [];

  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    String username = usernameProvider.getUsername();
    if (usernameProvider.getUserCurrentState() && username != "") {
      BookingCRUDService bookingCRUDService = new BookingCRUDService();
      final size = MediaQuery.of(context).size;

      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text('Upcoming Bookings'),
          ),
          body: FutureBuilder(
              future: bookingCRUDService.listUpcomingBookings(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  bookingsList = snapshot.data!;
                  if (bookingsList.length != 0) {
                    return SingleChildScrollView(
                      child: Column(children: [
                        bookingsListWidget(bookingsList, size),
                        SizedBox(height: 20),
                      ]),
                    );
                  } else {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("You have no Upcoming Bookings",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  // letterSpacing: 2.2,
                                  color: Colors.black)),
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
              }));
    } else {
      return MaterialApp(
          home: Scaffold(
              body: Text(
                  "User doesn't have permissions to view Upcoming Bookings")));
    }
  }

  Widget bookingsListWidget(List<dynamic> bookingsList, Size size) {
    return Container(
      height: size.height,
      width: size.width,
      child: ListView.builder(
          itemCount: bookingsList.length,
          itemBuilder: (context, index) {
            return itemBuilder(bookingsList, size * 0.9, index, context);
          }),
    );
  }
}

Widget itemBuilder(
    List<dynamic> bookingsList, Size size, int index, BuildContext context) {
  String status = bookingsList[index]["status"]!;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowDaycareDetails(
                      daycareID: bookingsList[index]["daycareID"],
                    )));
      },
      child: Material(
        color: Colors.white,
        elevation: 3,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: size.height / 2.5,
          width: size.width / 1.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.height / 12,
                width: size.width / 1.2,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.deepOrange),
                    Text(
                      bookingsList[index]["daycareName"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 7, 7, 7),
                child: Row(
                  children: [
                    Icon(IconClass.baby_head_with_a_small_heart_outline,
                        size: 30, color: Colors.orange),
                    SizedBox(width: 5),
                    Text(
                      bookingsList[index]["babyName"]!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 7, 7, 7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.calendar_today, size: 25, color: Colors.orange),
                    SizedBox(width: 5),
                    Text(
                      isoToDate(bookingsList[index]["startTime"]!),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 7, 7, 7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.access_time_filled_outlined,
                        size: 25, color: Colors.orange),
                    SizedBox(width: 7),
                    Text(
                      isoTo12HourTime(bookingsList[index]["startTime"]!) +
                          " - " +
                          isoTo12HourTime(bookingsList[index]["endTime"]!),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 7, 7, 7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.currency_rupee_outlined,
                        size: 25, color: Colors.green),
                    SizedBox(width: 7),
                    Text(
                      bookingsList[index]["charge"].toInt().toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 7, 7, 7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(StatusIcon.decision_making,
                        size: 25, color: Colors.orange),
                    SizedBox(width: 7),
                    Text(
                      status,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: status == "In Process"
                            ? Colors.orange
                            : status == "Accepted"
                                ? Colors.green
                                : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String isoTo12HourTime(String iso8601DateTime) {
  DateTime dateTime = DateTime.parse(iso8601DateTime);
  return DateFormat.jm().format(dateTime).toString();
}

String isoToDate(String iso8601DateTime) {
  DateTime dateTime = DateTime.parse(iso8601DateTime);
  return DateFormat('dd-MM-yyyy').format(dateTime);
}
