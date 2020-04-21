import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:bakercalculator/constants.dart';
import 'package:bakercalculator/components/reusable_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bakercalculator/components/bottom_button.dart';
import 'package:intl/intl.dart';
import 'package:bakercalculator/components/baking_step.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  DateTime goalDateTime = DateTime.now();
  int sliderValue = 30;
  String dropdownValue = 'Min';
  List<BakingStep> steps = new List();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColour,
            title: Text(
              'BAKER CALCULATOR',
              style: kAppBarTextStyle,
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: ReusableCard(
                colour: kLightPrimaryColour,
                cardChild: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Goal Time:',
                              style: kCardTitleTextStyle,
                            ),
                          ),
                          Text(
                              DateFormat('dd.MM.yyyy – kk:mm')
                                  .format(goalDateTime),
                              style: kGoalTimeTextStyle)
                        ],
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 30.0,
                      child: RaisedButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              goalDateTime = date;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        color: kAccentColour,
                        child:
                            Icon(FontAwesomeIcons.plus, color: kDarkTextColour),
                        padding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: ReusableCard(
                colour: kAccentColour,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text('Add Step:',
                            style: kAccentCardTitleTextStyle)),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              width: screenWidth * 0.75,
//                              height: 50.0,
                              child: TextField(
                                controller: myController,
                                style: kAccentCardTextStyle,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kPrimaryColour),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kPrimaryColour),
                                    ),
                                    hintText: 'Enter Step Description...'),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Slider(
                                  value: sliderValue.toDouble(),
                                  min: 0.0,
                                  max: 60.0,
                                  activeColor: kPrimaryColour,
                                  inactiveColor: kPrimaryTextColour,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      sliderValue = newValue.toInt();
                                    });
                                  },
                                ),
                                Container(
                                  width: 25.0,
                                  margin: EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    sliderValue.toString(),
                                    style: kAccentCardTextStyle,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                DropdownButton(
                                  value: dropdownValue,
                                  style: kAccentCardTextStyle,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>['Min', 'Hours']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            )
                          ],
                        ),
                        ButtonTheme(
                          minWidth: 30.0,
                          height: 100.0,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                BakingStep newStep = BakingStep(
                                    duration: sliderValue,
                                    durationUnit: dropdownValue,
                                    stepName: myController.text);
                                steps.add(newStep);
                              });
                            },
                            color: kPrimaryColour,
                            child: Icon(FontAwesomeIcons.plus,
                                color: kAccentColour),
                            padding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ReusableCard(
                colour: kLightPrimaryColour,
                cardChild: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder(
                      horizontalInside:
                          BorderSide(width: 1.0, color: kDividerColour),
                    ),
                    columnWidths: <int, TableColumnWidth>{
                      0: FixedColumnWidth(0.0),
                      1: FixedColumnWidth(20.0),
                      3: FixedColumnWidth(30.0),
                      4: FixedColumnWidth(50.0),
                    },
                    children: [
                      for (var i = 0; i < steps.length; i++)
                        TableRow(children: <Widget>[
                          Container(height: 25.0),
                          Text(i.toString(), style: kStepTableTextStyle),
                          Text(steps[i].stepName, style: kStepTableTextStyle),
                          Text(steps[i].duration.toString(),
                              style: kStepTableTextStyle),
                          Text(steps[i].durationUnit,
                              style: kStepTableTextStyle),
                        ]),
                    ]),
              ),
            ),
            BottomButton(buttonTitle: 'CALCULATE', onTap: () {}),
          ],
        ));
  }
}
