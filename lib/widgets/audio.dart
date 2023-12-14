import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../Utils/url.dart';
import 'audio_widget.dart';

class MyAudion extends StatefulWidget {
  const MyAudion({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  MyAudionState createState() => MyAudionState();
}

class MyAudionState extends State<MyAudion> with WidgetsBindingObserver {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    if (kDebugMode) {
      print('loading');
    }
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      if (kDebugMode) {
        print('A stream error occurred: $e');
      }
    });
    try {
      String audioUrl = voiceBaseURL + widget.url;
      final file = await DefaultCacheManager().getSingleFile(audioUrl);
      Timer(const Duration(milliseconds: 100), () {
        _player.setAudioSource(AudioSource.uri(Uri.file(file.path)));
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio source: $e");
      }
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ControlButtons(_player),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _player.seek,
            );
          },
        ),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              child: const Icon(Icons.volume_up),
              onTap: () {
                showSliderDialog(
                  context: context,
                  title: "Adjust volume",
                  divisions: 10,
                  min: 0.0,
                  max: 1.0,
                  value: player.volume,
                  stream: player.volumeStream,
                  onChanged: player.setVolume,
                );
              },
            ),
            const SizedBox(width: 10),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (kDebugMode) {
                  print('processing state::::$processingState');
                  print('playing state:::::$playing');
                }


                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.idle ||
                    processingState == ProcessingState.buffering) {
                  return const SizedBox(
                    child: CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return InkWell(
                    onTap: player.play,
                    child: const Icon(
                      Icons.play_arrow,
                      size: 30,
                    ),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return InkWell(
                    onTap: player.pause,
                    child: const Icon(
                      Icons.pause,
                      size: 30,
                    ),
                  );
                } else {
                  return InkWell(
                    child: const Icon(
                      Icons.replay,
                      size: 30,
                    ),
                    onTap: () => player.seek(Duration.zero),
                  );
                }
              },
            ),
            const SizedBox(width: 10),
            StreamBuilder<double>(
              stream: player.speedStream,
              builder: (context, snapshot) => InkWell(
                onTap: () {
                  showSliderDialog(
                    context: context,
                    title: "Adjust speed",
                    divisions: 10,
                    min: 0.5,
                    max: 1.5,
                    value: player.speed,
                    stream: player.speedStream,
                    onChanged: player.setSpeed,
                  );
                },
                child: Text("${snapshot.data?.toStringAsFixed(1)}x",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
