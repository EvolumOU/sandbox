import 'dart:math';

import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';

class RitualNeedStepTicket extends StatelessWidget {
  final List<String> needs;
  final int index;
  final bool disableRotation;
  final double width;
  final double height;

  const RitualNeedStepTicket({
    Key? key,
    required this.needs,
    required this.index,
    required this.width,
    required this.height,
    this.disableRotation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ticketColor = Color(0xFFFFE8CF);
    final titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.46,
          color: kevoBlack,
        );

    final isFirst = index == 0;
    final isLast = index == needs.length - 1;

    return RotatedBox(
      quarterTurns: 3,
      child: Stack(
        children: [
          isLast && !disableRotation
              ? Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: width / needs.length,
                        width: height / 2,
                        color: ticketColor,
                      ),
                    ),
                    Transform.rotate(
                      angle: -pi / 16,
                      child: Container(
                        height: width / needs.length,
                        width: height,
                        color: ticketColor,
                        child: Center(
                          child: Text(
                            needs[index],
                            style: titleStyle.copyWith(fontSize: 23),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: width / needs.length,
                  width: height,
                  color: ticketColor,
                  child: Center(
                    child: Text(
                      needs[index],
                      style: titleStyle.copyWith(fontSize: 23),
                    ),
                  ),
                ),
          if (!isFirst)
            Divider(thickness: 1, color: kevoBlack.withOpacity(0.5), height: 1),
        ],
      ),
    );
  }
}
