import 'dart:io';

import 'package:evolum_package/model/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sandbox/service/storage.dart';

enum PlayerAudioState {
  loading,
  ready,
  finished,
}

/// PlayerAudio
/// The [audioFile] and [audioUrl] paramenters can't be both null.
class PlayerAudio {
  /// AudioSource audio title
  final String title;

  /// If null, [audioFile] can't be null.
  final String? audioUrl;

  /// If null, [audioUrl] can't be null.
  final File? audioFile;

  /// Wether the audio is repeating itself or not. False by default.
  final bool loop;

  PlayerAudio({
    required this.title,
    this.audioUrl,
    this.audioFile,
    this.loop = true,
  });

  AudioPlayer player = AudioPlayer();
  Duration duration = Duration.zero;

  Future<void> init() async {
    assert(audioUrl != null || audioFile != null);

    String? url = audioUrl;

    try {
      if (url != null && url.startsWith("gs://")) {
        url = await Storage.getDownloadUrl(url);
      }
      final audioSource = AudioSource.uri(
        url != null ? Uri.parse(url) : Uri.file(audioFile!.path),
        tag: MediaItem(
          id: getRandomGeneratedId(),
          title: title,
          album: 'evolum',
          artUri: Uri.parse(
              "https://firebasestorage.googleapis.com/v0/b/evolum-936c6.appspot.com/o/logo%2Fevolum.png?alt=media&token=84a76461-716d-453c-a9d5-ecec85dfbb81"),
        ),
      );
      duration = await player.setAudioSource(audioSource) ?? Duration.zero;
      if (loop) player.setLoopMode(LoopMode.all);
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

  Future<void> quickSeek(int seconds) async {
    Duration to = player.position + Duration(seconds: seconds);

    if (to.isNegative) to = Duration.zero;
    await player.seek(to);
  }
}
