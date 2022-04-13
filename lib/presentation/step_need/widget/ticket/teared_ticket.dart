import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/presentation/step_need/widget/ticket/teared_painting.dart';

class RitualNeedStepTearedTicket extends StatelessWidget {
  final double width;
  final double height;
  final bool shift;

  const RitualNeedStepTearedTicket({
    Key? key,
    required this.width,
    required this.height,
    this.shift = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ticketColor = Color(0xFFFFE8CF);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: 20,
          color: kevoBlack,
          child: RotatedBox(
            quarterTurns: 2,
            child: CustomPaint(
                painter: TearedEffectPainter(ticketColor, shift: shift)),
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            width: width,
            height: height,
            color: kevoBlack,
          ),
        ),
      ],
    );
  }
}
