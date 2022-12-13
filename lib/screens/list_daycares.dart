import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:toddlyybeta/backend_services/daycare_crud.dart';
import 'package:toddlyybeta/screens/show_daycare_details.dart';

class ListDaycares extends StatefulWidget {
  const ListDaycares({super.key});

  @override
  State<ListDaycares> createState() => _ListDaycaresState();
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Help'),
        content: const Text(
            'Please call us on \n+91 8104241955 or email at toddlyytech@gmail.com for any help or feedback.\n\nWe will get back to you as soon as possible!'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _ListDaycaresState extends State<ListDaycares> {
  List<dynamic> daycaresList = [];
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        //signOutCurrentUser();
        ;
        break;
      case 'Help':
        _dialogBuilder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    DaycareCRUDService daycareCRUDService = new DaycareCRUDService();
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Toddlyy'),
          backgroundColor: Colors.orange,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Help'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: daycareCRUDService.displayDaycares(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                daycaresList = snapshot.data!;
                return daycaresListWidget(daycaresList, size);
              } else
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 0.8,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }));
  }

  Widget daycaresListWidget(List<dynamic> daycaresList, Size size) {
    return Container(
      height: size.height,
      width: size.width,
      child: ListView.builder(
          itemCount: daycaresList.length,
          itemBuilder: (context, index) {
            return itemBuilder(daycaresList, size, index, context);
          }),
    );
  }
}

Widget itemBuilder(
    List<dynamic> daycaresList, Size size, int index, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowDaycareDetails(
                      daycareID: daycaresList[index]["daycareID"],
                    )));
      },
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: size.height / 2.5,
          width: size.width / 1.1,
          child: Column(
            children: [
              Container(
                height: size.height / 4,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(daycaresList[index]["image"]!),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: size.height / 12,
                width: size.width / 1.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      daycaresList[index]["name"]!,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Container(
                    //   height: size.height / 25,
                    //   width: size.width / 7,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.green,
                    //   ),
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //     restaurantList[index].rating,
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                width: size.width / 1.2,
                child: Text(
                  daycaresList[index]["region"]!,
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
