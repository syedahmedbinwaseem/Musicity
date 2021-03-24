import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused }

class SongScreen extends StatefulWidget {
  int index;
  List total;
  AudioPlayerState mystate;
  SongScreen({this.index, this.mystate, this.total});
  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> with TickerProviderStateMixin {
  AnimationController animate;
  int myindex;
  int currentindex = 0;
  void callsetstate() {
    setState(() {});
  }

  AudioPlayer audioPlayer = AudioPlayer(playerId: 'myPlayer');
  AudioPlayerState playerState;

  String currentTime = '00:00';
  String completedTime = '00:00';
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

  bool yes = false;
  bool con = true;
  bool isPaused = false;

  int yest = 1;
  int best = 0;
  int loop = 0;
  Duration duration;
  Duration position;
  play(String path) async {
    int result = await audioPlayer.play(path);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPaused = true;
      });
    }
  }

  stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  resume() async {
    int result = await audioPlayer.resume();
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  bool isPlaying = false;
  @override
  void initState() {
    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = (duration.toString().split(".")[0]).split(':')[1] +
            ':' +
            (duration.toString().split(".")[0]).split(':')[2];
      });
    });
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completedTime = (duration.toString().split(".")[0]).split(':')[1] +
            ':' +
            (duration.toString().split(".")[0]).split(':')[2];
      });
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        playerState = s;
      });
    });
    super.initState();
    animate =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    if (widget.mystate == AudioPlayerState.PLAYING) {
      animate.forward();
    } else {
      animate.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    animate.dispose();
  }

  // void handleOnPressed() {
  //   setState(() {
  //     isPlaying = !isPlaying;
  //     isPlaying ? animate.forward() : animate.reverse();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    AudioPlayerState initialState = widget.mystate;
    List allinfo = widget.total;
    int index = widget.index;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Now Playing',
          style: TextStyle(fontFamily: 'Open Sans', fontSize: 12),
        ),
        actions: <Widget>[
          Center(
            child: Container(
                height: 27,
                width: 27,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image(
                    image: AssetImage('assets/images/random.png'),
                    color: Colors.white,
                  ),
                )),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onVerticalDragStart: (dragDetails) {
          startVerticalDragDetails = dragDetails;
        },
        onVerticalDragUpdate: (dragDetails) {
          updateVerticalDragDetails = dragDetails;
        },
        onVerticalDragEnd: (endDetails) {
          double dx = updateVerticalDragDetails.globalPosition.dx -
              startVerticalDragDetails.globalPosition.dx;
          double dy = updateVerticalDragDetails.globalPosition.dy -
              startVerticalDragDetails.globalPosition.dy;
          double velocity = endDetails.primaryVelocity;

          if (dx < 0) dx = -dx;
          if (dy < 0) dy = -dy;

          if (velocity < 0) {
            print('Swipe Up');
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          height: screenHeight,
          color: Color.fromRGBO(61, 1, 1, 1),
          child: Column(
            children: <Widget>[
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.5,
                  child: Image.asset(
                    allinfo[index + currentindex].albumArtwork == null
                        ? 'assets/images/issa.jpg'
                        : allinfo[index + currentindex].albumArtwork,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                allinfo[index + currentindex].artist,
                style: TextStyle(color: Colors.white, fontFamily: 'Open San'),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                allinfo[index + currentindex].title,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open San',
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: Text(
                  currentTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Open San',
                      fontSize: 29,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Container(
                height: screenHeight * 0.17,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(73, 1, 1, 1),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 22,
                      child: Image(
                        image: AssetImage('assets/images/repeat.png'),
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('YEs');
                      },
                      child: Container(
                        height: 30,
                        child: Image(
                          image: AssetImage('assets/images/reverse.png'),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: screenHeight * 0.14,
                      color: Colors.white,
                      icon: AnimatedIcon(
                          icon: AnimatedIcons.play_pause, progress: animate),
                      onPressed: () {
                        if (initialState == AudioPlayerState.PLAYING &&
                            playerState == null) {
                          animate.reverse();
                          pause();
                        } else if (initialState == AudioPlayerState.PLAYING &&
                            playerState == AudioPlayerState.PAUSED) {
                          animate.forward();
                          resume();
                        } else if (initialState == AudioPlayerState.PLAYING &&
                            playerState == AudioPlayerState.PLAYING) {
                          animate.reverse();
                          pause();
                        } else if (initialState == AudioPlayerState.PAUSED &&
                            playerState == null) {
                          animate.forward();
                          resume();
                        } else if (initialState == AudioPlayerState.PAUSED &&
                            playerState == AudioPlayerState.PLAYING) {
                          animate.reverse();
                          pause();
                        } else if (initialState == AudioPlayerState.PAUSED &&
                            playerState == AudioPlayerState.PAUSED) {
                          animate.forward();
                          resume();
                        }
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        stop();
                        setState(() {
                          currentindex = currentindex + 1;
                        });
                        animate.forward();
                        play(allinfo[index + currentindex].filePath);
                      },
                      child: Container(
                        height: 30,
                        child: Image(
                          image: AssetImage('assets/images/fast-forward.png'),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.loop, size: 35, color: Colors.white),
                      onPressed: () async {
                        if (loop == 0) {
                          print('loop');
                          await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                          setState(() {
                            loop = 1;
                          });
                        } else {
                          print('Loop stopped');
                          await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
                          setState(() {
                            loop = 1;
                          });
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
