import 'package:flutter/material.dart';
import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final double? height;

  CustomText({
    this.text = "text를 확인해주세요",
    this.size = 18.0,
    this.weight = TeragateFontWeight.bold,
    this.color = TeragateColors.white,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        height: height,
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
