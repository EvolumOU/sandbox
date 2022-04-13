import 'package:flutter/material.dart';
import 'package:sandbox/main.dart';
import 'package:sandbox/service/player_audio.dart';

class SandboxAudioPlayerControlsButton extends StatefulWidget {
  final Stream<PlayerAudioState> playerStateStream;
  final Stream<bool> playingStream;
  final Function() play;
  final Function() pause;
  final Function(int) quickSeek;
  final Function() onFinish;
  final int seconds;

  const SandboxAudioPlayerControlsButton({
    Key? key,
    required this.playerStateStream,
    required this.playingStream,
    required this.onFinish,
    required this.quickSeek,
    required this.play,
    required this.pause,
    this.seconds = 10,
  }) : super(key: key);

  @override
  State<SandboxAudioPlayerControlsButton> createState() =>
      _SandboxAudioPlayerControlsButtonState();
}

class _SandboxAudioPlayerControlsButtonState
    extends State<SandboxAudioPlayerControlsButton> {
  bool isLoading = true;

  @override
  void initState() {
    widget.playerStateStream.listen((e) {
      if (e == PlayerAudioState.ready) {
        setState(() => isLoading = false);
      } else if (e == PlayerAudioState.finished) {
        widget.onFinish();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLoading ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: StreamBuilder<bool>(
        stream: widget.playingStream,
        builder: (context, snapshot) {
          final isPlaying = snapshot.data;

          if (isPlaying == null) return const SizedBox();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => widget.quickSeek(-10),
                icon: const Icon(Icons.history),
              ),
              isPlaying
                  ? IconButton(
                      onPressed: widget.pause,
                      icon: const Icon(Icons.pause),
                    )
                  : IconButton(
                      onPressed: audioHandler.play,
                      icon: const Icon(Icons.play_arrow),
                    ),
              IconButton(
                onPressed: () => widget.quickSeek(10),
                icon: const Icon(Icons.update),
              ),
            ],
          );
        },
      ),
    );
  }
}
