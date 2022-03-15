import 'package:flutter/material.dart';
import 'package:sandbox/presentation/audio_player/audio_player.dart';

void main() {
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
