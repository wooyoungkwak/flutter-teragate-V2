import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card_square.dart';
import 'package:teragate/states/widgets/icon.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/states/widgets/button.dart';

class CreateContainerByCardbtn extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? btntext;
  final Function? function;

  //const CreateContainerByCardbtn({Key? key, required this.title}) : super(key: key);

  CreateContainerByCardbtn({
    this.icon,
    this.title,
    this.btntext,
    this.function,
  });

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
                icon: icon,
              ),
              CustomText(
                text: title!,
              ),
            ],
          ),
          Stack(children: [
            GestureDetector(
                onTap: () {
                  function!();
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    color: TeragateColors.blue,
                    child: Center(
                        child: CustomText(
                      text: btntext!,
                      size: 18,
                      weight: TeragateFontWeight.regular,
                      color: TeragateColors.white,
                    ))))
          ])
        ],
      ),
    );
  }
}
