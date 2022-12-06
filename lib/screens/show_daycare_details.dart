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

                return SingleChildScrollView(
                  child: Column(
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
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                            Icon(Icons.location_on, size: 20),
                            Text(
                              daycareDetails.address,
                              textAlign: TextAlign.left,
                              softWrap: true,
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
                            Icon(Icons.access_time_filled_outlined, size: 18),
                            Text(
                              daycareDetails.startTime +
                                  " - " +
                                  daycareDetails.endTime,
                              textAlign: TextAlign.center,
                              // softWrap: true,
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
                            Icon(Icons.phone, size: 18),
                            Text(
                              daycareDetails.phoneNo,
                              textAlign: TextAlign.center,
                              // softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        color: Colors.orangeAccent,
                        elevation: 3,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          height: size.height / 2.5 / 2,
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookSlot(
                                        daycareName: daycareDetails.daycareName,
                                        daycareID: daycareDetails.daycareID,
                                        charges: daycareDetails.charges,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          "BOOK SLOT",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
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
            .map((item) => new Text("\u2022  " + item,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left))
            .toList());
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 20.0,
      width: 20.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
