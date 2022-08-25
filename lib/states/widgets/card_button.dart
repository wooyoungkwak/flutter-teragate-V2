import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/card_square.dart';
import 'package:teragate/states/widgets/text.dart';
import 'package:teragate/states/widgets/icon.dart';

class CardButton extends StatefulWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final Function? function;
  final bool? isSwitch;

  // ignore: use_key_in_widget_constructors
  const CardButton({
    this.icon,
    this.title,
    this.subtitle,
    this.function,
    this.isSwitch = false,
  });

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  bool isSwitched = false;
  bool isNotEmptySubtitle = false;
  String alarmState = "알림꺼짐";

  @override
  void initState() {
    if (widget.subtitle != null) {
      isNotEmptySubtitle = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.function != null) {
          widget.function!(context);
        }
      },
      child: CardSquare(
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconBox(
              icon: widget.icon,
            ),
            Container(
              margin: const EdgeInsets.only(left: 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: widget.title!,
                    weight: TeragateFontWeight.bold,
                    color: TeragateColors.white,
                  ),
                  if (isNotEmptySubtitle)
                    CustomText(
                      text: widget.subtitle!,
                      size: 13,
                      weight: TeragateFontWeight.regular,
                      color: TeragateColors.grey,
                    ),
                ],
              ),
            ),
            if (widget.isSwitch!)
              const Expanded(
                child: Text(""),
              ),
            if (widget.isSwitch!)
              Column(
                children: [
                  Switch(
                    value: isSwitched,
                    onChanged: (value) => {
                      setState(() {
                        isSwitched = value;
                        alarmState = isSwitched ? "알림켜짐" : "알림꺼짐";
                      })
                    },
                    activeColor: TeragateColors.white,
                    activeTrackColor: TeragateColors.activeTrackColor,
                    inactiveTrackColor: TeragateColors.darkGrey,
                  ),
                  CustomText(
                    text: alarmState,
                    size: 12.0,
                    weight: TeragateFontWeight.medium,
                    color: TeragateColors.grey,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
