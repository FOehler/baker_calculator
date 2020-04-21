import 'package:flutter/material.dart';
import 'package:bakercalculator/components/baking_step.dart';
import 'package:bakercalculator/components/reusable_card.dart';
import 'package:bakercalculator/constants.dart';

class StepList extends StatelessWidget {
  const StepList({
    Key key,
    @required this.steps,
  }) : super(key: key);

  final List<BakingStep> steps;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReusableCard(
        colour: kLightPrimaryColour,
        cardChild: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(
              horizontalInside: BorderSide(width: 1.0, color: kDividerColour),
            ),
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(0.0),
              1: FixedColumnWidth(20.0),
              3: FixedColumnWidth(30.0),
              4: FixedColumnWidth(60.0),
            },
            children: [
              for (var i = 1; i <= steps.length; i++)
                TableRow(children: <Widget>[
                  Container(height: 25.0),
                  Text(i.toString(), style: kStepTableTextStyle),
                  Text(steps[i - 1].stepName, style: kStepTableTextStyle),
                  Text(steps[i - 1].duration.toString(),
                      style: kStepTableTextStyle),
                  Text(steps[i - 1].durationUnit, style: kStepTableTextStyle),
                ]),
            ]),
      ),
    );
  }
}
