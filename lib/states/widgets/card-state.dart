import 'package:flutter/material.dart';

import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card-square.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/states/widgets/network-state.dart';

class CardState extends StatelessWidget {
  const CardState({Key? key}) : super(key: key);

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
              widget: Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 100,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 252, 223),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  '정상',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 17, 159, 83),
                  ),
                ),
              ),
            ),
            StateRow(
                widget: CustomText(
              text: "192.168.0.2",
              size: 20.0,
              weight: TeragateFontWeight.regular,
            )),
          ],
        ),
      ),
    );
  }
}
