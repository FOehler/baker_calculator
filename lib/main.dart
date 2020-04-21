import 'package:flutter/material.dart';
import 'screens/input_page.dart';
import 'constants.dart';

void main() => runApp(BakerCalculator());

class BakerCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baker Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColour,
        scaffoldBackgroundColor: kPrimaryColour,
      ),
      home: InputPage(),
    );
  }
}
