import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card_square.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/utils/log_util.dart';
import 'package:teragate/utils/time_util.dart';

class CardCommuting extends StatelessWidget {
  final String? title;
  final bool? isCommuting;

  const CardCommuting({
    Key? key,
    this.title,
    this.isCommuting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardSquare(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomText(
                  text: title!,
                  size: 22.0,
                  weight: TeragateFontWeight.semiBold,
                  color: TeragateColors.cardTitle,
                ),
                isCommuting!
                    ? CustomText(
                        text: getPickerTime(getNow()),
                        size: 28.0,
                        weight: TeragateFontWeight.bold,
                        color: TeragateColors.white,
                      )
                    : CustomText(
                        text: "아직 $title 전입니다.",
                        size: 16.0,
                        weight: TeragateFontWeight.bold,
                        color: TeragateColors.grey,
                      ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isCommuting!
                        ? TeragateColors.blue
                        : TeragateColors.inactiveTextColor,
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size.fromHeight(25),
                  ),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0))),
                  )),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCommuting!) const SizedBox(width: 10.0),
                  CustomText(
                    text: isCommuting! ? "$title 완료" : "$title 하기",
                    weight: TeragateFontWeight.semiBold,
                  ),
                  if (isCommuting!)
                    const Padding(
                      padding: EdgeInsets.only(left: 2.0),
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
