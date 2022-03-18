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

class _SandboxAudioPlayerState extends State<SandboxAudioPlayer>
    with WidgetsBindingObserver {
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // when app is back on foreground and audio is finished
    if (state == AppLifecycleState.resumed && player.isFinished) {
      widget.onFinish();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    initPlayerAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: EvoLoading())
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
                  quickSeek: (seconds) => player.quickSeek(seconds),
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
    WidgetsBinding.instance?.removeObserver(this);
    player.stop();
    super.dispose();
  }
}
