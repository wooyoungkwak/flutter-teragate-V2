import 'package:flutter/material.dart';

import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card_square.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/states/widgets/network_state.dart';
import 'package:teragate/config/env.dart';

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
            StateRow(
                widget: CustomText(
              text: "$locationState ",
              size: 20.0,
              weight: TeragateFontWeight.extraBold,
            ),subject: Env.CARD_STATE
            ),
            StateRow(
                widget: CustomText(
              text: "$location ",
              size: 20.0,
              weight: TeragateFontWeight.extraBold,
            ),subject: Env.CARD_STATE_LOCATION
            ),
          ],
        ),
      ),
    );
  }
}
