import 'package:flutter/material.dart';

class OutlinedAutomatedNextFocusableTextFormField extends StatelessWidget {
  const OutlinedAutomatedNextFocusableTextFormField({
    this.padding = const EdgeInsets.all(8),
    this.obscureText = false,
    this.labelText,
    this.controller,
    this.inputType,
    this.decoration,
    this.onTap,
    this.icon,
    this.validator,
    Key? key,
  }) : super(key: key);

  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final EdgeInsets padding;
  final bool obscureText;
  final InputDecoration? decoration;
  final Icon? icon;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            icon: icon),
        onTap: onTap,
      ),
    );
  }
}
