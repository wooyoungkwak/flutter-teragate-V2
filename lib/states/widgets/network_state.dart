import 'package:flutter/material.dart';

import 'package:teragate/config/colors.dart';
import 'package:teragate/config/font-weights.dart';

import 'package:teragate/states/widgets/text.dart';

class StateRow extends StatelessWidget {
  final Widget? widget;
  final String? subject;
  const StateRow({Key? key, 
    this.widget,
    this.subject
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: const Icon(
                    Icons.circle,
                    color: Color.fromARGB(255, 49, 76, 248),
                    size: 6,
                  ),
                ),
                SizedBox(
                  child: CustomText(
                      text: "$subject ",
                      size: 20,
                      weight: TeragateFontWeight.regular,
                      color: TeragateColors.white),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(
              child: Icon(
                Icons.horizontal_rule,
                color: Color.fromARGB(255, 98, 100, 113),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: widget!,
          )
        ],
      ),
    );
  }
}
