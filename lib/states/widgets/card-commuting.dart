import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card-square.dart';
import 'package:teragate/states/widgets/text.dart';

class CardCommuting extends StatelessWidget {
  final String? title;
  final String? time;
  final String? isCommuting;

  CardCommuting({
    this.title,
    this.time,
    this.isCommuting,
  });

  @override
  Widget build(BuildContext context) {
    return CardSquare(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title!,
            size: 22.0,
            weight: TeragateFontWeight.semiBold,
            color: TeragateColors.cardTitle,
          ),
          CustomText(
            text: time!,
            size: 28.0,
            weight: TeragateFontWeight.bold,
            color: TeragateColors.white,
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  TeragateColors.blue,
                ),
                minimumSize: MaterialStateProperty.all(
                  const Size.fromHeight(50),
                ),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0))),
                )),
            onPressed: () {},
            child: CustomText(
              text: isCommuting!,
              weight: TeragateFontWeight.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
