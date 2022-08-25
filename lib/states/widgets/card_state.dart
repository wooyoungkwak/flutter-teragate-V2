import 'package:flutter/material.dart';

import 'package:teragate/config/font-weights.dart';
// import 'package:teragate/config/colors.dart';

import 'package:teragate/states/widgets/card_square.dart';
import 'package:teragate/states/widgets/text.dart';
// import 'package:teragate/states/widgets/network_state.dart';
// import 'package:teragate/config/env.dart';

class CardState extends StatelessWidget {
  String? locationState;
  String? location;
  CardState({this.locationState, this.location, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardSquare(
      widget: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _createHorizonnExpandedTextRow("$locationState"),
            _createHorizonnExpandedTextRow("현재 위치는 $location입니다."),
            _createHorizonnExpandedTextRow("--------------"),
          ],
        ),
      ),
    );
  }
}

Row _createHorizonnExpandedTextRow(String text) {
  return Row(
    children: [
      Expanded(
        child: Center(
          child: CustomText(
            text: text,
            size: 20.0,
            weight: TeragateFontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
