import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLayout extends StatefulWidget {

  final File? file;
  final bool? isSelected;

  const VideoLayout({Key? key, this.file, this.isSelected}) : super(key: key);

  @override
  _VideoLayoutState createState() => _VideoLayoutState();
}

class _VideoLayoutState extends State<VideoLayout> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(
        widget.file!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });

        // _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  fileSize() {

    int size = widget.file!.lengthSync();

    if(size < 1000)
    {
      return size.toString() + " B";
    }
    else if(size >= 1000 && size < 1000000)
    {
      size = (size/1000).round();
      return size.toString() + " KB";
    }
    else if(size >= 1000000)
    {
      size = (size/1000000).round();
      return size.toString() + " MB";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            //borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ClipRRect(
            //borderRadius: BorderRadius.circular(20.0),
            child:   _controller!.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ) : Container(),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: widget.isSelected! ? CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.black54,
              child: Center(child: Icon(Icons.check, color: Colors.white,))) : Text(""),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: 40.0,
            color: Colors.black54,
          ),
        ),
        Positioned(
          bottom: 5.0,
          left: 5.0,
          child: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                border: Border.all(
                    color: Colors.white,
                    width: 1.0
                ),
                borderRadius: BorderRadius.circular(30.0)
            ),
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown
                  // setState(() {
                  //   // If the video is playing, pause it.
                  //   if (_controller.value.isPlaying) {
                  //     _controller.pause();
                  //   } else {
                  //     // If the video is paused, play it.
                  //     _controller.play();
                  //   }
                  // });
                },
                // Display the correct icon depending on the state of the player.
                child: Icon(
                  _controller!.value.isPlaying ? Icons.video_collection_outlined : Icons.video_collection_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: Text(fileSize(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        )
      ],
    );
  }

}

