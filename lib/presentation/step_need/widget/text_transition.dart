import 'dart:async';

import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';

class RitualNeedStepTextTransition extends StatefulWidget {
  final bool dropped;
  final String need;
  final Function() onFinish;

  const RitualNeedStepTextTransition({
    Key? key,
    required this.need,
    required this.dropped,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<RitualNeedStepTextTransition> createState() =>
      _RitualNeedStepTextTransitionState();
}

class _RitualNeedStepTextTransitionState
    extends State<RitualNeedStepTextTransition> {
  static const List<Map<String, String>> texts = [
    {"text": "Vous avez demandé de…", "pos": "top"},
    {"text": "La vie s’en charge.", "pos": "bottom"},
    {"text": "Suivez les signes…", "pos": "bottom"},
    {"text": "Et lâchez prise.", "pos": "bottom"},
  ];

  bool get isDark => true;
  bool get hide => !widget.dropped || blank;
  bool get isLast => index == texts.length - 1;

  int index = 0;
  bool blank = false;

  Timer? timer;

  @override
  void didUpdateWidget(covariant RitualNeedStepTextTransition oldWidget) {
    if (!widget.dropped || timer != null) return;

    timer = Timer.periodic(
      const Duration(milliseconds: 2000),
      (timer) async {
        debugPrint("[Got] 2000ms period, index: $index");

        setState(() => blank = true);

        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          if (isLast) {
            timer.cancel();
            widget.onFinish();
            return;
          }

          setState(() {
            blank = false;
            index++;
          });
        });
      },
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.46,
          color: isDark ? kevoBlack : kevoWhite,
        );

    final bodyStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.46,
        );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: texts[index]["pos"] == "top" && !hide ? 1 : 0,
            child: Text(texts[index]["text"]!, style: bodyStyle),
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.7,
              height: 80,
              color: kevoBelge,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.dropped ? 1 : 0,
                child: Text(
                  widget.need,
                  textAlign: TextAlign.center,
                  style: titleStyle.copyWith(color: kevoBlack),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: texts[index]["pos"] == "bottom" && !hide ? 1 : 0,
            child: Text(texts[index]["text"]!, style: bodyStyle),
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
