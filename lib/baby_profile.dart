import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyProfileScreen extends StatefulWidget {
  const BabyProfileScreen({super.key});
  static const routeName = "/fill-baby-profile";

  @override
  State<BabyProfileScreen> createState() => _BabyProfileScreenState();
}

class _BabyProfileScreenState extends State<BabyProfileScreen> {
  TextEditingController _dateOfBirth = TextEditingController();

  final _dateFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Baby Profile')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: ListView(children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(labelText: 'Baby Name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_dateFocusNode);
                    }),
                TextFormField(
                  controller: _dateOfBirth,
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
                        _dateOfBirth.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: _dateFocusNode,
                )
              ]),
            )));
  }
}
