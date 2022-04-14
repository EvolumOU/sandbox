import 'package:flutter/material.dart';
import 'package:sandbox/presentation/step_need/widget/ticket/teared_painting.dart';
import 'package:sandbox/presentation/step_need/widget/ticket/teared_ticket.dart';
import 'package:sandbox/presentation/step_need/widget/ticket/ticket.dart';

class RitualNeedStepDraggable extends StatefulWidget {
  final int index;
  final List<Map<String, String>> needs;
  final bool draggingBeforeLast;
  final double padding;
  final double height;
  final Function(int) onDrag;

  const RitualNeedStepDraggable({
    Key? key,
    required this.index,
    required this.needs,
    required this.draggingBeforeLast,
    required this.padding,
    required this.height,
    required this.onDrag,
  }) : super(key: key);

  @override
  State<RitualNeedStepDraggable> createState() =>
      _RitualNeedStepDraggableState();
}

class _RitualNeedStepDraggableState extends State<RitualNeedStepDraggable> {
  List<String> get extractedNeeds =>
      widget.needs.map((e) => e["need"]!).toList();

  bool get isLast => widget.index == widget.needs.length - 1;

  @override
  Widget build(BuildContext context) {
    const ticketColor = Color(0xFFFFE8CF);
    final width =
        (MediaQuery.of(context).size.width - 2 * widget.padding).ceilToDouble();

    return Draggable<String>(
      maxSimultaneousDrags: 1,
      onDragStarted: () => widget.onDrag(widget.index),
      // Le ticket draggé, qui suit le doigt
      feedback: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width / widget.needs.length,
            height: 20,
            color: Colors.transparent,
            child: const CustomPaint(
              painter: TearedEffectPainter(ticketColor),
            ),
          ),
          RitualNeedStepTicket(
            needs: extractedNeeds,
            index: widget.index,
            width: width,
            height: widget.height - 20,
            disableRotation: true,
          ),
        ],
      ),
      // En dessous du ticket (vertical)
      childWhenDragging: Padding(
        padding: EdgeInsets.only(right: isLast ? widget.padding : 0),
        child: RitualNeedStepTearedTicket(
          width: width / widget.needs.length,
          height: width,
          shift: true,
        ),
      ),
      // Le ticket affiché
      child: RitualNeedStepTicket(
        needs: extractedNeeds,
        index: widget.index,
        width: width,
        height: widget.height,
        disableRotation: widget.draggingBeforeLast,
      ),
    );
  }
}
