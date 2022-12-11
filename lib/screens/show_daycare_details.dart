import 'package:flutter/material.dart';
import 'package:toddlyybeta/backend_services/daycare_crud.dart';
import 'package:toddlyybeta/models/daycare_model.dart';
import 'package:toddlyybeta/screens/book_slot.dart';

class ShowDaycareDetails extends StatefulWidget {
  final String daycareID;
  const ShowDaycareDetails({Key? key, required this.daycareID})
      : super(key: key);

  @override
  State<ShowDaycareDetails> createState() => _ShowDaycareDetailsState();
}

class _ShowDaycareDetailsState extends State<ShowDaycareDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    DaycareCRUDService daycareCRUDService = new DaycareCRUDService();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder(
            future: daycareCRUDService.showDaycareDetails(widget.daycareID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                DaycareDetails daycareDetails = snapshot.data!;

                return Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: Image.network(
                        daycareDetails.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      daycareDetails.daycareName,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Icon(Icons.location_on,
                              size: 20, color: Colors.orange),
                          Text(
                            daycareDetails.address,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Icon(Icons.access_time_filled_outlined,
                              size: 18, color: Colors.orange),
                          Text(
                            daycareDetails.startTime +
                                " - " +
                                daycareDetails.endTime,
                            textAlign: TextAlign.center,
                            // softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Icon(Icons.phone, size: 18, color: Colors.orange),
                          Text(
                            daycareDetails.phoneNo,
                            textAlign: TextAlign.center,
                            // softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      color: Colors.orange,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: size.height / 2.5 / 1.5,
                        width: size.width / 1.1,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "FACILITIES IN DAYCARE",
                              style: TextStyle(
                                // color: Colors.or,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: Container(
                                height: size.height / 12,
                                width: size.width / 1.2,
                                child: Column(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: <Widget>[
                                      getTextWidgets(daycareDetails.features)
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookSlot(
                                      daycareName: daycareDetails.daycareName,
                                      daycareID: daycareDetails.daycareID,
                                      charges: daycareDetails.charges,
                                      startTime: daycareDetails.startTime,
                                      endTime: daycareDetails.endTime)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: EdgeInsets.symmetric(horizontal: 120),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          "Book Slot",
                          style: TextStyle(
                              fontSize: 18,
                              // letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
              } else
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 0.8,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }));
  }

  Widget getTextWidgets(List<dynamic> features) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features
            .map((item) => Row(children: [
                  Icon(Icons.check, size: 18, color: Colors.green),
                  SizedBox(width: 5),
                  Text(item,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left),
                ]))
            .toList());
  }
}
