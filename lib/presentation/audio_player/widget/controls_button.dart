import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sandbox/service/player_audio.dart';

class SandboxAudioPlayerControlsButton extends StatefulWidget {
  final Stream<PlayerAudioState> playerStateStream;
  final Stream<bool> playingStream;
  final Function() play;
  final Function() pause;
  final Function() onFinish;

  const SandboxAudioPlayerControlsButton({
    Key? key,
    required this.playerStateStream,
    required this.playingStream,
    required this.onFinish,
    required this.play,
    required this.pause,
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
          return isPlaying
              ? IconButton(
                  onPressed: widget.pause,
                  icon: const Icon(Icons.pause),
                )
              : IconButton(
                  onPressed: widget.play,
                  icon: const Icon(Icons.play_arrow),
                );
        },
      ),
    );
  }
}
