import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card-square.dart';
import 'package:teragate/states/widgets/icon.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/states/widgets/button.dart';

class SettingUUID extends StatelessWidget {
  const SettingUUID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardSquare(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconBox(
                icon: Icons.bluetooth,
              ),
              CustomText(
                text: "UUID",
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 14.0, bottom: 10.0),
            child: CustomText(
              text: "현재 설정된 UUID:",
              size: 14.0,
              weight: TeragateFontWeight.regular,
              color: TeragateColors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 14.0),
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            width: 338.0,
            height: 40.0,
            decoration: const BoxDecoration(
              color: TeragateColors.currentUUIDText,
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            alignment: Alignment.center,
            child: CustomText(
              text: "022db29c-d0e2-11e5-bb4c-60f81dca7676",
              size: 16.0,
              weight: TeragateFontWeight.regular,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 14.0,
                    right: 5.0,
                  ),
                  child: CustomButton(
                    text: "초기값 셋팅",
                    textSize: 15.0,
                    height: 52.0,
                    color: TeragateColors.darkGrey,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 14.0,
                  ),
                  child: CustomButton(
                    text: "UUID 가져오기",
                    textSize: 15.0,
                    height: 52.0,
                    color: TeragateColors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
