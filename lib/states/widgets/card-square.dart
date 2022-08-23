import 'package:flutter/material.dart';
import 'package:teragate/config/colors.dart';

class CardSquare extends StatelessWidget {
  final Widget? widget;
  final double? height;

  CardSquare({
    this.widget,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Card(
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        color: TeragateColors.bgColorCard,
        child: widget,
      ),
    );
  }
}
