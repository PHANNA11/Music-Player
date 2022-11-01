import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_players/musicData/musics.dart';
import 'package:music_players/play_music_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_audio_player/simple_audio_focus_manager.dart';
import 'package:simple_audio_player/simple_audio_notification_manager.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
import 'dart:developer' as dev;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: musics.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              final musicPlaying = musics[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MusicPlaying(musicModel: musicPlaying),
                  ));
              // Future.microtask(() async {
              //   dev.log(musicPlaying.music.toString());
              //   File file = File(
              //       "${(await getTemporaryDirectory()).path}assets/Music/${musicPlaying.music}");

              //   if (!file.existsSync()) {
              //     file.createSync(recursive: true);
              //     final byteData = await rootBundle.load(
              //         'assets/Music/${musicPlaying.music.toString()}');
              //     await file
              //         .writeAsBytes(byteData.buffer.asUint8List());
              //   }

              //   setState(() {
              //     this.file = file;
              //   });
              // });
            },
            child: Card(
              elevation: 0,
              child: ListTile(
                leading: musics[index].image == ''
                    ? const Icon(
                        Icons.queue_music_outlined,
                        size: 40,
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    musics[index].image.toString()))),
                      ),
                title: Text(musics[index].musicName.toString()),
                subtitle: Text(musics[index].artist.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
