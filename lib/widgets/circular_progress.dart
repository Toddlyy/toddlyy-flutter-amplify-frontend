import 'package:flutter/material.dart';
import 'package:toddlyybeta/screens/bottom_navbar.dart';

class CircularIndicator extends StatefulWidget {
  final nextScreenIndex;
  const CircularIndicator({Key? key, required this.nextScreenIndex})
      : super(key: key);

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  int load_time = 5;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: load_time), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavBar(currentScreen: widget.nextScreenIndex)));
    });

    return Scaffold(body: CircularProgressIndicator());
  }
}
