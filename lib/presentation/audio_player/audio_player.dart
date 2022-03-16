import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/presentation/audio_player/widget/controls_button.dart';
import 'package:sandbox/presentation/audio_player/widget/slider.dart';
import 'package:sandbox/service/player_audio.dart';

class SandboxAudioPlayer extends StatefulWidget {
  final Function() onFinish;

  const SandboxAudioPlayer({Key? key, required this.onFinish})
      : super(key: key);

  @override
  State<SandboxAudioPlayer> createState() => _SandboxAudioPlayerState();
}

class _SandboxAudioPlayerState extends State<SandboxAudioPlayer> {
  final player = PlayerAudio(
    title: 'The Imperial March',
    audioUrl:
        'https://firebasestorage.googleapis.com/v0/b/evolum-936c6.appspot.com/o/Get_Lucky.mp3?alt=media&token=4b0da820-c4c6-4de5-a395-9be99e8c3197',
  );
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
