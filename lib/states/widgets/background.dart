import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';

Container initBackgoundImage(Widget widget) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/background.png"),
        fit: BoxFit.fill,
      ),
    ),
    child: widget,
  );
}

Container createContentBox(Widget widget) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    padding:
        const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
    decoration: const BoxDecoration(
      color: TeragateColors.bgColorContent,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
    ),
    child: widget,
  );
}
