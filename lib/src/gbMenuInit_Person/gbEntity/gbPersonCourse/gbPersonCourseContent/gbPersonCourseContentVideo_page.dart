import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:goldenbelt/src/_models/gb_tcourse_model.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart';

class gbPersonCourseContentVideoView_page extends StatefulWidget {
  const gbPersonCourseContentVideoView_page(
      { Key? key,
        required this.title,
        required this.content_html,
        required this.tcourse_content_id

      }): super(key: key);

  final String content_html;
  final String title;
  final String tcourse_content_id;

  @override
  State<gbPersonCourseContentVideoView_page> createState() => _gbPersonCourseContentVideoView_pageState();
}

class _gbPersonCourseContentVideoView_pageState extends State<gbPersonCourseContentVideoView_page>
{
  gbCourseProvider _gbCourseProvider = new gbCourseProvider();
  String S3getSignedUrl = "";

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double _currentSliderValue = 0.0;
  bool _isPlaying = false;
  @override
  void initState() {

    super.initState();

    get_gbCourseContentS3SignedUrl();

    _controller = VideoPlayerController.asset('');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      setState(() {
        _currentSliderValue =
            _controller.value.position.inMilliseconds.toDouble();
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void get_gbCourseContentS3SignedUrl() async
  {
    S3getSignedUrl =  await _gbCourseProvider.getCourseContentS3getSignedUrl(widget.tcourse_content_id);

    setState(() {

      _controller = VideoPlayerController.networkUrl(Uri.parse(S3getSignedUrl))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    });

  }

  String formatDuration(Duration duration) {
    // Formatea la duración como minutos:segundos
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  String calculateRemainingTime() {
    Duration remainingTime = _controller.value.duration - _controller.value.position;
    return '${formatDuration(remainingTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        MediaQuery.of(context).orientation.toString() == 'Orientation.landscape'
            ? null
            : AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              MediaQuery.of(context).orientation.toString() == 'Orientation.landscape'
                  ? Container() :
              Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  right: 16.0,
                  child: Row(
              children: [
              Text(
                calculateRemainingTime(),
      style: TextStyle(fontSize: 12.0, color: Colors.white),
    ),
    Expanded(
    child:
    Slider(
                value: _currentSliderValue,
                min: 0,
                max: _controller.value.duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    if (value <= _controller.value.duration.inMilliseconds ) {
                      _currentSliderValue = value;
                      _controller.seekTo(Duration(milliseconds: value.toInt()));
                    }
                  });
                },
              ))])
        )]),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
                SystemChrome.setPreferredOrientations([]);
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              } else {
                SystemChrome.setPreferredOrientations([]);
                //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      );
  }


}
