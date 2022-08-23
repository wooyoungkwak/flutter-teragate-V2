import 'package:flutter/material.dart';

//constant
import 'package:teragate/config/font-weights.dart';

//wigets
import 'package:teragate/states/widgets/text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final double? textSize;
  final Color? color;
  final double? height;

  // ignore: use_key_in_widget_constructors
  const CustomButton({
    this.text,
    this.textSize,
    this.color,
    this.height = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(5.0),
      height: height!,
      decoration: BoxDecoration(
        color: color!,
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextButton(
        onPressed: () {},
        child: CustomText(
          text: text!,
          size: textSize!,
          weight: TeragateFontWeight.semiBold,
        ),
      ),
    );
  }
}
