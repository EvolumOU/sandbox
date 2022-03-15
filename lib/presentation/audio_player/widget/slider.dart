import 'package:flutter/material.dart';

class SandboxAudioPlayerSlider extends StatelessWidget {
  final Stream<Duration> positionStream;
  final Duration duration;
  final Function(double) onChanged;

  const SandboxAudioPlayerSlider({
    Key? key,
    required this.positionStream,
    required this.duration,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data;

        if (position == null) {
          return const SizedBox();
        }

        return Slider(
          value: position.inMilliseconds / duration.inMilliseconds,
          onChanged: (pos) => onChanged(pos),
        );
      },
    );
  }
}
