class PlayerAudio {
  Future<void> init() async {}

  Stream<Duration> get currentPosition => Stream.empty();

  Future<void> play() async {}
  Future<void> pause() async {}

  Future<void> playOrPause() async {}

  Future<void> stop() async {}
  Future<void> seek(Duration to) async {}
}
