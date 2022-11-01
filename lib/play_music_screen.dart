import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_players/models/music_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_audio_player/simple_audio_focus_manager.dart';
import 'package:simple_audio_player/simple_audio_notification_manager.dart';
import 'package:simple_audio_player/simple_audio_player.dart';

class MusicPlaying extends StatefulWidget {
  MusicPlaying({super.key, required this.musicModel});
  MusicModel musicModel;

  @override
  State<MusicPlaying> createState() => _MusicPlayingState();
}

class _MusicPlayingState extends State<MusicPlaying> {
  bool play = true;
  double _currentSliderValue = 0.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();

  SimpleAudioPlayer? simpleAudioPlayer;
  //==============
  final focusManager = SimpleAudioFocusManager();
  final notificationManager = SimpleAudioNotificationManager();
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //==================
    Future.microtask(() async {
      File file = File(
          "${(await getTemporaryDirectory()).path}assets/Music/${widget.musicModel.music}");

      if (!file.existsSync()) {
        file.createSync(recursive: true);
        final byteData =
            await rootBundle.load('assets/Music/${widget.musicModel.music}');
        await file.writeAsBytes(byteData.buffer.asUint8List());
      }

      setState(() {
        simpleAudioPlayer!
            .prepare(uri: "file://${file.path}")
            .then((value) => simpleAudioPlayer!.play());

        play = false;
      });
    });
    //=================
    simpleAudioPlayer = SimpleAudioPlayer();

    simpleAudioPlayer!.songStateStream.listen((event) {
      event.data.toString();
      print("song event : $event");
    });
    focusManager.audioFocusStream.listen((event) {
      print("focus event : $event");
    });
    focusManager.becomingNoisyStream.listen((event) {
      print("becoming noisy event : $event");
    });
    notificationManager.notificationStream.listen((event) {
      print("notification event : $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.musicModel.musicName.toString()),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(children: [
        Container(
          height: 300,
          width: double.infinity,
          color: Colors.yellowAccent,
          child: Image(
              fit: BoxFit.cover,
              image: AssetImage(widget.musicModel.image.toString())),
        ),
        Slider(
          value: position.inSeconds.toDouble(),
          min: 0,
          max: position.inSeconds.toDouble(),
          onChanged: (double value) async {
            final position = Duration(seconds: value.toInt());
            await audioPlayer.seek(position);
            await audioPlayer.resume();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.music_note,
                  size: 50,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.skip_previous,
                  size: 50,
                )),
            IconButton(
                onPressed: () {
                  if (!play) {
                    setState(() {
                      simpleAudioPlayer!.pause();
                      play = true;
                    });
                  } else {
                    setState(() {
                      simpleAudioPlayer!.play();
                      play = false;
                    });
                  }
                },
                icon: !play
                    ? const Icon(
                        Icons.pause_circle,
                        size: 50,
                      )
                    : const Icon(
                        Icons.play_circle,
                        size: 50,
                      )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.skip_next,
                  size: 50,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.library_music_outlined,
                  size: 50,
                ))
          ],
        )
      ]),
    );
  }
}
