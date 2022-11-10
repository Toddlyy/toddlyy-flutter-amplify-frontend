import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toddlyybeta/providers.dart';
import 'package:toddlyybeta/backend_services/user_crud.dart';
import 'package:toddlyybeta/models/baby_model.dart';

class DisplayDaycaresScreen extends StatefulHookWidget {
  const DisplayDaycaresScreen({super.key});

  @override
  State<DisplayDaycaresScreen> createState() =>
      _DisplayDaycaresScreenState();
}

class _DisplayDaycaresScreenState extends State<DisplayDaycaresScreen> {
  var usernameProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usernameProvider = useProvider(UserLoggedInProvider);
    String username = usernameProvider.getUsername();

    if (usernameProvider.getUserCurrentState() && username != "") {
      UserCRUDService userCRUDService = new UserCRUDService();
      return Scaffold(
          appBar: AppBar(
              // title: Text("Toddlyy"),
              ),
          body: FutureBuilder(
              future: userCRUDService.displayBabyProfile(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<BabyDetails> babyDetails = snapshot.data!;
                  //final babyDetails = snapshot.data;
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (ctx, index) {
                        // return Text(babyDetails[0].babyFirstName);
                        // return Card(margin: EdgeInsets.symmetric(horizontal:15, vertical:4),
                        // Padding(padding: EdgeInsets.all(8),
                        // children:[Text(babyDetails[0].babyFirstName),
                        // Text(babyDetails[0].babyLastName)];
                        return Card(
                            elevation: 50,
                            shadowColor: Colors.black,
                            color: Colors.orangeAccent[100],
                            child: SizedBox(
                                width: 300,
                                height: 200,
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ), //SizedBox
                                        Text(
                                          'Name :  ' +
                                              babyDetails[0].babyFirstName +
                                              " " +
                                              babyDetails[0].babyLastName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          //Textstyle
                                        ),
                                        Text(
                                          'Date of Birth :  ' +
                                              babyDetails[0].dob,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          //Textstyle
                                        ),
                                        Text(
                                          'Gender :  ' + babyDetails[0].gender,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          //Textstyle
                                        ),
                                        Text(
                                          'Your relation :  ' +
                                              babyDetails[0].relation,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          //Textstyle
                                        )
                                      ],
                                    ))));
                      });
                } else
                  return CircularProgressIndicator();
              }));
    } else {
      return Scaffold(
          body:
              Text("User doesn't have permissions to view Baby Profile Page"));
    }
  }
}
