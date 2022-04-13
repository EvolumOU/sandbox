import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sandbox/service/storage.dart';

enum PlayerAudioState {
  loading,
  ready,
  finished,
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayer player = AudioPlayer();
  Duration duration = Duration.zero;
  late bool loopMode;
  int cycleCount = 0;
  bool isAudioDone = false;

  bool get isFinished =>
      player.playerState.processingState == ProcessingState.completed;

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

  AudioPlayerHandler() {
    player.playbackEventStream.map(transformEvent).pipe(playbackState);
  }

  Future<void> init({
    required String title,
    String? audioUrl,
    File? audioFile,
    bool loop = false,
    Function(String)? onError,
  }) async {
    assert(audioUrl != null || audioFile != null);

    String? url = audioUrl;
    loopMode = loop;

    try {
      if (url != null && url.startsWith("gs://")) {
        url = await Storage.getDownloadUrl(url);
      }

      final item = MediaItem(
        id: url ?? audioFile!.path,
        title: title,
        album: 'evolum',
        artUri: Uri.parse(
            "https://firebasestorage.googleapis.com/v0/b/evolum-936c6.appspot.com/o/logo%2Fevolum.png?alt=media&token=84a76461-716d-453c-a9d5-ecec85dfbb81"),
      );
      mediaItem.add(item);

      final audioSource = AudioSource.uri(
        url != null ? Uri.parse(url) : Uri.file(audioFile!.path),
      );

      duration = await player.setAudioSource(audioSource) ?? Duration.zero;
      if (loop) player.setLoopMode(LoopMode.all);
      player.positionStream.listen(backgroundEvent);
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  void backgroundEvent(Duration e) {
    final totalSeconds = (cycleCount * duration.inSeconds) + e.inSeconds;

    if (loopMode) {
      if (e >= duration) {
        cycleCount++;
      }
      if (!isAudioDone && totalSeconds >= 120) {
        print("[PlayerAudio] audio done (120 seconds)");
        isAudioDone = true;
      }
    } else {
      if (!isAudioDone && e >= duration * 0.8) {
        print("[PlayerAudio] audio done (80%)");
        isAudioDone = true;
      }
    }
  }

  @override
  Future<void> play() async => await player.play();

  @override
  Future<void> pause() async => await player.pause();

  Future<void> playOrPause() => player.playing ? pause() : play();

  Future<void> quickSeek(int seconds) async {
    Duration to = player.position + Duration(seconds: seconds);

    if (to.isNegative) to = Duration.zero;
    await player.seek(to);
  }

  PlaybackState transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (player.playing) MediaControl.pause else MediaControl.play,
      ],
      systemActions: const {
        // MediaAction.seek,
        // MediaAction.seekForward,
        // MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
