import 'package:flutter/material.dart';
import 'package:evolum_package/main.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sandbox/presentation/audio_player/audio_player.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.sandbox',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    notificationColor: kevoOrange,
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
      home: SandboxAudioPlayer(onFinish: () => print("FINISH")),
    );
  }
}
