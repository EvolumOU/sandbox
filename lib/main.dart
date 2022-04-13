import 'package:audio_service/audio_service.dart';
import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/presentation/step_need/need_step.dart';
import 'package:sandbox/service/player_audio.dart';

late AudioHandler audioHandler;

Future<void> main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.example.sandbox',
  //   androidNotificationChannelName: 'Audio playback',
  // androidNotificationOngoing: true,
  //   notificationColor: kevoOrange,
  // );

  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.evolum.sanbox.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      notificationColor: kevoOrange,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SandboxAudioPlayer(onFinish: () => print("FINISH")),
      home: RitualNeedStep(
        onSelect: (_) {},
        onFinish: () {},
      ),
    );
  }
}
