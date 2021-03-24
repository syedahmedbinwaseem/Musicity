import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:musicity/album.dart';
import 'package:musicity/songScreen.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicity/songScreen.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

enum PlayerState { stopped, playing, paused }

class MainScreen extends StatefulWidget {
  bool play;
  List album = [];
  List total = [];
  bool mypermission;
  MainScreen({this.mypermission, this.play, this.total, this.album});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer(playerId: 'myPlayer');
  AudioPlayerState playerState;
  TabController tabController;
  TextEditingController controller = TextEditingController();
  ScrollController scroll;
  AnimationController animated;
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;
  String message;
  String up;
  double conheight = 0;
  int myindex = 0;
  String filter;
  int tabindex;
  String next;
  double myheight = 0;
  double mywidth = 0;
  String songname;
  List myalbumartist = [];
  List myalbum = [];
  List albumplay = [];
  bool backdrop = false;
  String artistname;
  String completedTime = "00:00";
  String currentTime = "00:00";
  bool playing = false;
  bool isPlaying = false;
  bool isPaused = false;
  var top = 0.0;
  bool isSearching = false;
  List filteredsongs = [];
  List yessongs = [];
  int ind = 0;
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

  getalbums() async {
    List albumList = await audioQuery.getAlbums();
    albumList.forEach((element) {
      myalbum.add(element.title);
      myalbumartist.add(element.artist);
    });
  }

  resume() async {
    int result = await audioPlayer.resume();
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  void handleOnPressed() {
    setState(() {
      playing = !playing;
      playing ? animated.forward() : animated.reverse();
    });
  }

  void callsetstate() {
    setState(() {});
  }

  @override
  void initState() {
    getalbums();

    filteredsongs = widget.total;
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        playerState = s;
      });
    });
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          tabindex = tabController.index;
        });
      }
    });
    animated =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    super.initState();
  }

  void filtersongs(value) {
    setState(() {
      print(
          'Filterd Songs; ${widget.total.where((element) => element.title.toLowerCase().contains(value.toLowerCase())).toList().length}');
      filteredsongs = widget.total
          .where((element) =>
              element.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
      print(
          'Filterd Songs; ${widget.total.where((element) => element.title.toLowerCase().contains(value.toLowerCase())).toList().length}');
    });
  }

  @override
  void dispose() {
    super.dispose();
    animated.dispose();
    controller.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool perm = widget.mypermission;
    List allinfo = widget.total;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;
    double height2 = screenHeight - padding.top;
    double status = screenHeight - height2;
    double downsize = screenHeight - 110 - status;
    if (perm == false) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Center(
            child: Text(
              'Music',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Open Sans', fontSize: 18),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Color.fromRGBO(149, 89, 20, 1),
            tabs: [
              Tab(text: 'Songs'),
              Tab(text: 'Albums'),
              Tab(text: 'Playlists'),
            ],
            controller: tabController,
          ),
          actions: <Widget>[
            Icon(Icons.search),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Container(
              color: Color.fromRGBO(61, 1, 1, 1),
              child: Center(
                child: Text(
                  'Storage permission not granted\nPlease restart app and grant permission',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 13,
                      color: Color.fromRGBO(199, 99, 99, 1)),
                ),
              ),
            ),
            Container(
              color: Color.fromRGBO(61, 1, 1, 1),
              child: Center(
                child: Text(
                  'No albums available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 13,
                      color: Color.fromRGBO(199, 99, 99, 1)),
                ),
              ),
            ),
            Container(
              color: Color.fromRGBO(61, 1, 1, 1),
              child: Center(
                child: Text(
                  'No albums available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 13,
                      color: Color.fromRGBO(199, 99, 99, 1)),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      callsetstate();
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: Text(
                        'Music',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w500),
                      ),
                      // ?
                      // : Row(
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () {
                      //           controller.clear();
                      //           filteredsongs = widget.total;
                      //           setState(() {
                      //             isSearching = !isSearching;
                      //             conheight = 70;
                      //           });
                      //         },
                      //         child: Container(
                      //           height: 20,
                      //           width: 20,
                      //           child: Image(
                      //             image:
                      //                 AssetImage('assets/images/back.png'),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(width: 10),
                      //       Expanded(
                      //         child: Container(
                      //           height: 30,
                      //           decoration: BoxDecoration(
                      //               color: Color.fromRGBO(188, 47, 47, 1),
                      //               borderRadius:
                      //                   BorderRadius.circular(15)),
                      //           child: TextField(
                      //             cursorColor: Color.fromRGBO(61, 1, 1, 1),
                      //             keyboardType:
                      //                 TextInputType.visiblePassword,
                      //             style: TextStyle(fontFamily: 'Open Sans'),
                      //             controller: controller,
                      //             decoration: InputDecoration(
                      //                 border: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15)),
                      //                 hintText: 'search your music',
                      //                 hintStyle: TextStyle(
                      //                     fontFamily: 'Open Sans',
                      //                     fontSize: 14),
                      //                 contentPadding: EdgeInsets.only(
                      //                     top: 5, left: 10)),
                      //             onChanged: (value) {
                      //               filtersongs(value);
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(width: 20),
                      //     ],
                      //   ),
                      floating: true,
                      expandedHeight: 110,
                      pinned: true,
                      snap: true,
                      centerTitle: true,
                      flexibleSpace: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          top = constraints.biggest.height;

                          return FlexibleSpaceBar();
                        },
                      ),
                      // leading: isSearching
                      //     ? Container(
                      //         width: 10,
                      //         height: 10,
                      //         color: Colors.yellow,
                      //         child: Icon(Icons.arrow_back_ios))
                      //     : Container(),
                      actions: <Widget>[
                        isSearching
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  Icons.search,
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    myheight = screenHeight;
                                    mywidth = screenWidth;
                                    isSearching = !isSearching;
                                    conheight = 0;
                                  });
                                })
                      ],
                      bottom: TabBar(
                        labelStyle:
                            TextStyle(fontSize: 15, color: Colors.yellow),
                        unselectedLabelStyle:
                            TextStyle(fontSize: 12, color: Colors.pink),
                        indicatorColor: Color.fromRGBO(149, 89, 20, 1),
                        controller: tabController,
                        tabs: <Widget>[
                          Tab(
                            child: Text(
                              'Songs',
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Albums',
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Playlists',
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          color: Color.fromRGBO(61, 1, 1, 1),
                          child: ListView.builder(
                            itemCount: filteredsongs == null
                                ? 0
                                : filteredsongs.length,
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  EdgeInsets.only(left: 30, right: 30, top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  play(filteredsongs[index].filePath);
                                  animated.forward();
                                  controller.clear();
                                  filteredsongs = widget.total;
                                  setState(() {
                                    myheight = 0;
                                    mywidth = 0;
                                    songname = filteredsongs[index].title;
                                    artistname = filteredsongs[index].artist;
                                  });
                                  myindex = index;
                                  isSearching
                                      ? print('asd')
                                      : setState(() {
                                          conheight = 70;
                                        });
                                },
                                child: Container(
                                  height: 60,
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 25,
                                        child: Image(
                                          height: 30,
                                          image: AssetImage(
                                              'assets/images/song.png'),
                                        ),
                                        backgroundColor:
                                            Color.fromRGBO(219, 195, 195, 1),
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      Expanded(
                                        child: Container(
                                          height: 55,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Color.fromRGBO(73, 1, 1, 1),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 30,
                                                width: 300,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, top: 9),
                                                  child: Text(
                                                    filteredsongs[index].title,
                                                    style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 25,
                                                width: 300,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8,
                                                    top: 2,
                                                  ),
                                                  child: Text(
                                                    filteredsongs[index].artist,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Sans Light',
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w100),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(height: 11),
                                          Image(
                                            image: AssetImage(
                                                'assets/images/menu.png'),
                                            height: 13,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            DateFormat.ms().format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    int.parse(
                                                        filteredsongs[index]
                                                            .duration))),
                                            style: TextStyle(
                                                fontFamily: 'Sans Light',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w100,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              for (var i = 0; i < widget.total.length; i++) {
                                if (widget.total[i].title == songname) {
                                  print(widget.total[i]);
                                  setState(() {
                                    ind = i;
                                  });
                                }
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongScreen(
                                    total: allinfo,
                                    index: ind,
                                    mystate: playerState,
                                  ),
                                ),
                              );
                            },
                            onVerticalDragStart: (dragDetails) {
                              startVerticalDragDetails = dragDetails;
                            },
                            onVerticalDragUpdate: (dragDetails) {
                              updateVerticalDragDetails = dragDetails;
                            },
                            onVerticalDragEnd: (endDetails) {
                              double dx = updateVerticalDragDetails
                                      .globalPosition.dx -
                                  startVerticalDragDetails.globalPosition.dx;
                              double dy = updateVerticalDragDetails
                                      .globalPosition.dy -
                                  startVerticalDragDetails.globalPosition.dy;
                              double velocity = endDetails.primaryVelocity;

                              if (dx < 0) dx = -dx;
                              if (dy < 0) dy = -dy;

                              if (velocity < 0) {
                                for (var i = 0; i < widget.total.length; i++) {
                                  if (widget.total[i].title == songname) {
                                    print(widget.total[i]);
                                    setState(() {
                                      ind = i;
                                    });
                                  }
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongScreen(
                                      total: allinfo,
                                      index: ind,
                                      mystate: playerState,
                                    ),
                                  ),
                                );
                              } else {
                                print('Swipe down');
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              color: Color.fromRGBO(103, 4, 4, 1),
                              height: conheight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CircleAvatar(
                                      child: Image(
                                        height: 30,
                                        image: AssetImage(
                                            'assets/images/song.png'),
                                      ),
                                      radius: 30,
                                      backgroundColor:
                                          Color.fromRGBO(219, 195, 195, 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            artistname == null ? "" : songname,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            artistname == null
                                                ? ""
                                                : artistname,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'Sans Light',
                                                color: Colors.white,
                                                fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: IconButton(
                                        icon: AnimatedIcon(
                                            color: Colors.white,
                                            size: 40,
                                            icon: AnimatedIcons.play_pause,
                                            progress: animated),
                                        onPressed: () {
                                          if (playerState ==
                                              AudioPlayerState.PLAYING) {
                                            animated.reverse();
                                            pause();
                                          } else if (playerState ==
                                              AudioPlayerState.PAUSED) {
                                            animated.forward();
                                            resume();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          width: screenWidth,
                          height: screenHeight,
                          color: Color.fromRGBO(61, 1, 1, 1),
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: widget.album.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 40, right: 20, bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        albumplay = [];
                                      });
                                      allinfo.forEach((element) {
                                        if (element.album == e.title &&
                                            element.artist == e.artist) {
                                          albumplay.add(element);
                                        }
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Album(
                                                    image: e.albumArt,
                                                    name: e.title,
                                                    songs: albumplay,
                                                  )));
                                    },
                                    child: Container(
                                      height: (screenWidth / 2),
                                      width: (screenWidth / 2) - 40,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: (screenWidth / 2) - 40,
                                            width: (screenWidth / 2) - 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: e.albumArt == null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      'assets/images/music.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      e.albumArt,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(height: 3),
                                          Container(
                                            height: 22,
                                            width: (screenWidth / 2) - 40,
                                            child: Text(
                                              e.artist,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 15,
                                            width: (screenWidth / 2) - 40,
                                            child: Text(
                                              e.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Sans Light',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          // Text(
                                          //   e.artist,
                                          //   style: TextStyle(
                                          //     fontFamily: 'Open Sans',
                                          //     color: Colors.white,
                                          //     fontWeight: FontWeight.w500,
                                          //   ),
                                          // ),
                                          // Text(
                                          //   e.title,
                                          //   style: TextStyle(
                                          //     fontFamily: 'Sans Light',
                                          //     color: Colors.white,
                                          //     fontWeight: FontWeight.w200,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              for (var i = 0; i < widget.total.length; i++) {
                                if (widget.total[i].title == songname) {
                                  print(widget.total[i]);
                                  setState(() {
                                    ind = i;
                                  });
                                }
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongScreen(
                                    total: allinfo,
                                    index: ind,
                                    mystate: playerState,
                                  ),
                                ),
                              );
                            },
                            onVerticalDragStart: (dragDetails) {
                              startVerticalDragDetails = dragDetails;
                            },
                            onVerticalDragUpdate: (dragDetails) {
                              updateVerticalDragDetails = dragDetails;
                            },
                            onVerticalDragEnd: (endDetails) {
                              double dx = updateVerticalDragDetails
                                      .globalPosition.dx -
                                  startVerticalDragDetails.globalPosition.dx;
                              double dy = updateVerticalDragDetails
                                      .globalPosition.dy -
                                  startVerticalDragDetails.globalPosition.dy;
                              double velocity = endDetails.primaryVelocity;

                              if (dx < 0) dx = -dx;
                              if (dy < 0) dy = -dy;

                              if (velocity < 0) {
                                for (var i = 0; i < widget.total.length; i++) {
                                  if (widget.total[i].title == songname) {
                                    print(widget.total[i]);
                                    setState(() {
                                      ind = i;
                                    });
                                  }
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongScreen(
                                      total: allinfo,
                                      index: ind,
                                      mystate: playerState,
                                    ),
                                  ),
                                );
                              } else {
                                print('Swipe down');
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              color: Color.fromRGBO(103, 4, 4, 1),
                              height: conheight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CircleAvatar(
                                      child: Image(
                                        height: 30,
                                        image: AssetImage(
                                            'assets/images/song.png'),
                                      ),
                                      radius: 30,
                                      backgroundColor:
                                          Color.fromRGBO(219, 195, 195, 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            artistname == null ? "" : songname,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            artistname == null
                                                ? ""
                                                : artistname,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'Sans Light',
                                                color: Colors.white,
                                                fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: IconButton(
                                        icon: AnimatedIcon(
                                            color: Colors.white,
                                            size: 40,
                                            icon: AnimatedIcons.play_pause,
                                            progress: animated),
                                        onPressed: () {
                                          if (playerState ==
                                              AudioPlayerState.PLAYING) {
                                            animated.reverse();
                                            pause();
                                          } else if (playerState ==
                                              AudioPlayerState.PAUSED) {
                                            animated.forward();
                                            resume();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    playerState == AudioPlayerState.STOPPED
                        ? Text('abc')
                        : Stack(
                            children: [
                              Container(
                                color: Color.fromRGBO(61, 1, 1, 1),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    for (var i = 0;
                                        i < widget.total.length;
                                        i++) {
                                      if (widget.total[i].title == songname) {
                                        print(widget.total[i]);
                                        setState(() {
                                          ind = i;
                                        });
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongScreen(
                                          total: allinfo,
                                          index: ind,
                                          mystate: playerState,
                                        ),
                                      ),
                                    );
                                  },
                                  onVerticalDragStart: (dragDetails) {
                                    startVerticalDragDetails = dragDetails;
                                  },
                                  onVerticalDragUpdate: (dragDetails) {
                                    updateVerticalDragDetails = dragDetails;
                                  },
                                  onVerticalDragEnd: (endDetails) {
                                    double dx = updateVerticalDragDetails
                                            .globalPosition.dx -
                                        startVerticalDragDetails
                                            .globalPosition.dx;
                                    double dy = updateVerticalDragDetails
                                            .globalPosition.dy -
                                        startVerticalDragDetails
                                            .globalPosition.dy;
                                    double velocity =
                                        endDetails.primaryVelocity;

                                    if (dx < 0) dx = -dx;
                                    if (dy < 0) dy = -dy;

                                    if (velocity < 0) {
                                      for (var i = 0;
                                          i < widget.total.length;
                                          i++) {
                                        if (widget.total[i].title == songname) {
                                          print(widget.total[i]);
                                          setState(() {
                                            ind = i;
                                          });
                                        }
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SongScreen(
                                            total: allinfo,
                                            index: ind,
                                            mystate: playerState,
                                          ),
                                        ),
                                      );
                                    } else {
                                      print('Swipe down');
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    color: Color.fromRGBO(103, 4, 4, 1),
                                    height: conheight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: CircleAvatar(
                                            child: Image(
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/images/song.png'),
                                            ),
                                            radius: 30,
                                            backgroundColor: Color.fromRGBO(
                                                219, 195, 195, 1),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  artistname == null
                                                      ? ""
                                                      : songname,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: 'Open Sans',
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  artistname == null
                                                      ? ""
                                                      : artistname,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'Sans Light',
                                                      color: Colors.white,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: IconButton(
                                              icon: AnimatedIcon(
                                                  color: Colors.white,
                                                  size: 40,
                                                  icon:
                                                      AnimatedIcons.play_pause,
                                                  progress: animated),
                                              onPressed: () {
                                                if (playerState ==
                                                    AudioPlayerState.PLAYING) {
                                                  animated.reverse();
                                                  pause();
                                                } else if (playerState ==
                                                    AudioPlayerState.PAUSED) {
                                                  animated.forward();
                                                  resume();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              AnimatedContainer(
                height: myheight,
                width: mywidth,
                duration: Duration(milliseconds: 0),
                child: Stack(
                  children: [
                    filter == null
                        ? Container()
                        : filter.length > 0
                            ? Container()
                            : BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0)),
                                ),
                              ),
                    Column(
                      children: [
                        SizedBox(height: status + 10),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                controller.clear();
                                filteredsongs = widget.total;
                                setState(() {
                                  myheight = 0;
                                  mywidth = 0;
                                  isSearching = !isSearching;
                                  conheight = 70;
                                });
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: AssetImage('assets/images/back.png'),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(188, 47, 47, 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextField(
                                  cursorColor: Color.fromRGBO(61, 1, 1, 1),
                                  keyboardType: TextInputType.visiblePassword,
                                  style: TextStyle(fontFamily: 'Open Sans'),
                                  controller: controller,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      hintText: 'search your music',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 14),
                                      contentPadding:
                                          EdgeInsets.only(top: 5, left: 10)),
                                  onChanged: (value) {
                                    filtersongs(value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget searchwidget() {
    return Container(
        height: MediaQuery.of(context).size.height, color: Colors.yellow);
  }
}
