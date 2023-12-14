
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/url.dart';



class ChewiScreen extends StatefulWidget {
  final String video;
  final String title;

  const ChewiScreen({
    super.key,
    required this.video,
    required this.title,
  });

  @override
  State<ChewiScreen> createState() => _ChewieScreenState();
}

class _ChewieScreenState extends State<ChewiScreen> {

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  final double _aspectRatio = 16 / 9;


  @override
  initState() {
    super.initState();

    print("$videoBaseURL${widget.video}");
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse("$videoBaseURL${widget.video}"));
    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _videoPlayerController,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
    );
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          widget.title.toString(),
        ),
      ),
      backgroundColor: kBlack,
      body: SafeArea(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
