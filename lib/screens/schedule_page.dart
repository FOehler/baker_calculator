import 'package:flutter/material.dart';
import 'package:bakercalculator/components/baking_step.dart';
import 'package:bakercalculator/constants.dart';
import 'package:bakercalculator/components/reusable_card.dart';
import 'package:intl/intl.dart';
import 'package:bakercalculator/components/bottom_button.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({@required this.steps, @required this.goalDateTime});
  final List<BakingStep> steps;
  final DateTime goalDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColour,
          title: Text(
            'BAKER CALCULATOR',
            style: kAppBarTextStyle,
          )),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ReusableCard(
                colour: kLightPrimaryColour,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Your Schedule:',
                        style: kScheduleTitleTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(width: 1.0, color: kDividerColour),
                        ),
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(0.0),
                          1: FixedColumnWidth(110.0),
//                3: FixedColumnWidth(30.0),
//                4: FixedColumnWidth(60.0),
                        },
                        children: [
                          for (var i = 0; i < steps.length; i++)
                            TableRow(children: <Widget>[
                              Container(height: 25.0),
                              Text(
                                  DateFormat('dd.MM. - kk:mm')
                                      .format(steps[i].stepStartTime),
                                  style: kScheduleDateTextStyle),
                              Text(steps[i].stepName,
                                  style: kStepTableTextStyle),
//                    Text(steps[i].duration.toString(),
//                        style: kStepTableTextStyle),
//                    Text(steps[i].durationUnit, style: kStepTableTextStyle),
                            ]),
                        ]),
                  ],
                ),
              ),
            ),
            BottomButton(
                buttonTitle: 'RE-CALCULATE',
                onTap: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
