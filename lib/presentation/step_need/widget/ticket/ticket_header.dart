import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';

class RitualNeedStepTicketHeader extends StatelessWidget {
  final double height;
  final double padding;

  const RitualNeedStepTicketHeader({
    Key? key,
    required this.padding,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ticketColor = Color(0xFFFFE8CF);
    final titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.46,
          color: kevoBlack,
        );

    return Container(
      height: height,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(right: padding),
      color: ticketColor,
      child: Column(
        children: [
          const Expanded(flex: 2, child: Icon(Icons.favorite, size: 80)),
          Expanded(
            flex: 2,
            child: Text(
              "Prenez ce dont vous avez besoin…",
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
