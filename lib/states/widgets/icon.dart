import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';

class IconBox extends StatelessWidget {
  final IconData? icon;

  IconBox({
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14.0),
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: TeragateColors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Icon(
        icon!,
        color: Colors.white,
      ),
    );
  }
}
