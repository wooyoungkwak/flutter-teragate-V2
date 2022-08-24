import 'package:flutter/material.dart';

import 'package:teragate/config/font-weights.dart';
import 'package:teragate/config/colors.dart';

import 'package:teragate/states/widgets/card_square.dart';
import 'package:teragate/states/widgets/text.dart';
// import 'package:teragate/states/widgets/network_state.dart';
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
            _createPaddingByState(Env.CARD_STATE, "$locationState"),
            _createPaddingByState(Env.CARD_STATE_LOCATION, "$location"),
          ],
        ),
      ),
    );
  }
}

Padding _createPaddingByState(String title, String state) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: const Icon(
                  Icons.circle,
                  color: Color.fromARGB(255, 49, 76, 248),
                  size: 6,
                ),
              ),
              SizedBox(
                child: CustomText(
                    text: title,
                    size: 20,
                    weight: TeragateFontWeight.regular,
                    color: TeragateColors.white),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(
            child: Icon(
              Icons.horizontal_rule,
              color: Color.fromARGB(255, 98, 100, 113),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomText(
            text: state,
            size: 20.0,
            weight: TeragateFontWeight.extraBold,
          ),
        )
      ],
    ),
  );
}
