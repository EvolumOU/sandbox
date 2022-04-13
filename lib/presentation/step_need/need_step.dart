import 'dart:async';

import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandbox/presentation/step_need/widget/draggable.dart';
import 'package:sandbox/presentation/step_need/widget/ticket/ticket_header.dart';

enum DraggingStep {
  nothing,
  dragging,
  dropped,
}

class RitualNeedStep extends StatefulWidget {
  final Function() onFinish;
  final Function(String) onSelect;

  const RitualNeedStep({
    Key? key,
    required this.onSelect,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<RitualNeedStep> createState() => _RitualNeedStepState();
}

class _RitualNeedStepState extends State<RitualNeedStep> {
  static const List<Map<String, String>> needs = [
    {"article": "La ", "need": "confiance"},
    {"article": "L'", "need": "inspiration"},
    {"article": "La ", "need": "motivation"},
    {"article": "L'", "need": "amour"},
    {"article": "L'", "need": "inspiration"},
  ];

  DraggingStep draggingStep = DraggingStep.nothing;
  bool draggingBeforeLast = false;

  String selectedNeed = '';

  Future<void> dragTicket(int index) async {
    HapticFeedback.lightImpact();

    draggingStep = DraggingStep.dragging;

    if (index == needs.length - 2) {
      setState(() => draggingBeforeLast = true);
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // setState(() =>
    //     selectedNeed = "${needs[index]["article"]!}${needs[index]["need"]!}");
  }

  @override
  Widget build(BuildContext context) {
    final ticketHeaderHeight =
        (MediaQuery.of(context).size.height * 0.35).ceilToDouble();
    final ticketHeight = (ticketHeaderHeight * 0.7).ceilToDouble();
    const double padding = 40;

    return Listener(
      onPointerUp: (_) => setState(() => draggingStep = DraggingStep.dropped),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (draggingStep == DraggingStep.nothing && details.delta.dx < 0) {
            widget.onFinish();
          }
        },
        child: Scaffold(
          backgroundColor: kevoBlack,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: padding),
                  child: Column(
                    children: [
                      RitualNeedStepTicketHeader(
                        padding: padding,
                        height: ticketHeaderHeight,
                      ),
                      SizedBox(
                        height: ticketHeight,
                        child: ListView.builder(
                          itemCount: needs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              RitualNeedStepDraggable(
                            index: index,
                            needs: needs,
                            padding: padding,
                            height: ticketHeight,
                            draggingBeforeLast: draggingBeforeLast,
                            onDrag: dragTicket,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
