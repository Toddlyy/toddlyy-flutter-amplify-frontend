import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class dateOfBirthWidget extends StatefulWidget {
  final String dateOfBirth;
  final ValueSetter<String> callback;

  const dateOfBirthWidget(
      {Key? key, required this.dateOfBirth, required this.callback})
      : super(key: key);

  @override
  State<dateOfBirthWidget> createState() => _dateOfBirthWidgetState();
}

class _dateOfBirthWidgetState extends State<dateOfBirthWidget> {
  final _dateFocusNode = FocusNode();
  String dobPlaceholder = "";
  @override
  Widget build(BuildContext context) {
    dobPlaceholder =
        (dobPlaceholder == "") ? widget.dateOfBirth : dobPlaceholder;
    TextEditingController _dateOfBirthController =
        TextEditingController(text: dobPlaceholder);
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Please enter Baby\'s Date of Birth';
        else
          null;
      },
      controller: _dateOfBirthController,
      decoration: const InputDecoration(
          icon: Icon(
            Icons.calendar_today_rounded,
            color: Colors.orange,
          ),
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
            dobPlaceholder = DateFormat('dd-MM-yyyy').format(pickedDate);
            _dateOfBirthController.text =
                DateFormat('dd-MM-yyyy').format(pickedDate);
            widget.callback(dobPlaceholder);
          });
        }
      },
      textInputAction: TextInputAction.next,
      focusNode: _dateFocusNode,
    );
  }
}
