import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({Key? key}) : super(key: key);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  late VlcPlayerController _videoPlayerController;
  bool _isInitialized = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VlcPlayerController.network(
        'http://192.168.1.10:81/stream',
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );

      await _videoPlayerController.initialize();
      setState(() {
        _isInitialized = true;
      });

      _videoPlayerController.addListener(() {
        if (!_videoPlayerController.value.isPlaying) {
          print('VLC Player stopped playing');
        }
      });

    } catch (error) {
      print('Failed to initialize VLC Player: $error');
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _isError
            ? Text('Failed to load video stream')
            : _isInitialized
            ? VlcPlayer(
          controller: _videoPlayerController,
          aspectRatio: 16 / 9,
          placeholder: Center(child: CircularProgressIndicator()),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
