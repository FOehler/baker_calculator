import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:bakercalculator/constants.dart';
import 'package:bakercalculator/components/reusable_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bakercalculator/components/bottom_button.dart';
import 'package:intl/intl.dart';
import 'package:bakercalculator/components/baking_step.dart';
import 'package:bakercalculator/screens/schedule_page.dart';
import 'package:bakercalculator/components/step_list.dart';
import 'package:bakercalculator/components/database_helpers.dart';
import 'package:select_dialog/select_dialog.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  DateTime goalDateTime = DateTime.now();
  int sliderValue = 30;
  String dropdownValue = 'Minutes';
  List<BakingStep> steps = new List();
  final myController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  final _textFieldController = TextEditingController();

  void calculateSchedule() {
    DateTime stepStartTime = goalDateTime;
    for (var i = steps.length - 1; i >= 0; i--) {
      if (steps[i].durationUnit == "Minutes") {
        stepStartTime =
            stepStartTime.subtract(new Duration(minutes: steps[i].duration));
      } else if (steps[i].durationUnit == "Hours") {
        stepStartTime =
            stepStartTime.subtract(new Duration(hours: steps[i].duration));
      }
      steps[i].stepStartTime = stepStartTime;
    }
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _displayRecipeNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Save New Recipe'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Recipe Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SAVE'),
                onPressed: () {
                  _insertRecipe(_textFieldController.text);
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _insertRecipe(String recipeName) async {
    // row to insert
    for (var i = 0; i < steps.length; i++) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnRecipe: recipeName,
        DatabaseHelper.columnStepNumber: i,
        DatabaseHelper.columnDescription: steps[i].stepName,
        DatabaseHelper.columnDuration: steps[i].duration,
        DatabaseHelper.columnDurationUnit: steps[i].durationUnit,
      };
      final id = await dbHelper.insert(row);
      print('inserted row id: $id');
    }
  }

  void _loadRecipe() async {
    String ex1 = "No value selected";

    SelectDialog.showModal<String>(
      context,
      label: "Simple Example",
      selectedValue: ex1,
      items: List.generate(50, (index) => "Item $index"),
      onChange: (String selected) {
        setState(() {
          ex1 = selected;
        });
      },
    );

    final recipeRows = await dbHelper.queryRecipeRows('Butterzopf');
    steps.clear();
    for (var i = 0; i < recipeRows.length; i++) {
      BakingStep newStep = BakingStep(
          duration: recipeRows[i]["duration"],
          durationUnit: recipeRows[i]["durationUnit"],
          stepName: recipeRows[i]["description"]);
      steps.add(newStep);
    }
  }

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
        resizeToAvoidBottomInset:
            false, // Prevent resizing window when keyboard appears
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
//                              goalDateTime = date;
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
                            Container(
                              width: screenWidth * 0.75,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Slider(
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
                                    items: <String>['Minutes', 'Hours']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
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
            StepList(steps: steps),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _displayRecipeNameDialog(context);
                        });
                      },
                      color: kAccentColour,
                      child: Text('Save Recipe', style: kAccentCardTextStyle),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _query();
                          _loadRecipe();
                        });
                      },
                      color: kAccentColour,
                      child: Text('Load Recipe', style: kAccentCardTextStyle),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          steps.clear();
                        });
                      },
                      color: kAccentColour,
                      child: Text('Clear Steps', style: kAccentCardTextStyle),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ),
            BottomButton(
                buttonTitle: 'CALCULATE SCHEDULE',
                onTap: () {
                  calculateSchedule();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchedulePage(
                        steps: steps,
                        goalDateTime: goalDateTime,
                      ),
                    ),
                  );
                }),
          ],
        ));
  }
}
