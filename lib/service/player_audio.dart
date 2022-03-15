// ignore_for_file: avoid_print
import 'package:just_audio/just_audio.dart';

enum PlayerAudioState {
  loading,
  ready,
  finished,
}

class PlayerAudio {
  AudioPlayer player = AudioPlayer();
  Duration duration = Duration.zero;

  Future<void> init() async {
    try {
      duration =
          await player.setAsset("assets/audio/imperial.mp3") ?? Duration.zero;
    } catch (e) {
      print("[PlayerAudio] init error: $e");
    }
  }

  Stream<Duration> get positionStream =>
      player.positionStream.map((e) => e < duration ? e : duration);
  Stream<bool> get playingStream => player.playingStream;

  Stream<PlayerAudioState> get playerStateStream {
    return player.playerStateStream.map((e) {
      switch (e.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
          return PlayerAudioState.loading;
        case ProcessingState.ready:
          return PlayerAudioState.ready;
        case ProcessingState.completed:
          return PlayerAudioState.finished;
      }
    });
  }

  Future<void> play() async => await player.play();
  Future<void> pause() async => await player.pause();

  Future<void> playOrPause() => player.playing ? pause() : play();

  Future<void> stop() async {
    await player.stop();
    await player.dispose();
  }

  Future<void> seek(Duration to) async => await player.seek(to);
}
