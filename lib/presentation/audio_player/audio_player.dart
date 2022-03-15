// ignore_for_file: avoid_print

import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/presentation/audio_player/widget/controls_button.dart';
import 'package:sandbox/presentation/audio_player/widget/slider.dart';
import 'package:sandbox/service/player_audio.dart';

class name extends StatelessWidget {
  const name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SandboxAudioPlayer extends StatefulWidget {
  final Function() onFinish;

  const SandboxAudioPlayer({Key? key, required this.onFinish})
      : super(key: key);

  @override
  State<SandboxAudioPlayer> createState() => _SandboxAudioPlayerState();
}

class _SandboxAudioPlayerState extends State<SandboxAudioPlayer> {
  final player = PlayerAudio();
  bool isLoading = true;

  Future<void> initPlayerAudio() async {
    await player.init();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    initPlayerAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const EvoLoading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("The Imperial March"),
                SandboxAudioPlayerControlsButton(
                  playerStateStream: player.playerStateStream,
                  playingStream: player.playingStream,
                  play: player.play,
                  pause: player.pause,
                  onFinish: () => print("AUDIO IS FINISHED"),
                ),
                if (player.duration != Duration.zero)
                  SandboxAudioPlayerSlider(
                    duration: player.duration,
                    positionStream: player.positionStream,
                    onChanged: (pos) => player.seek(
                      Duration(
                        milliseconds:
                            (pos * player.duration.inMilliseconds).toInt(),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }
}
