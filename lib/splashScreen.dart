import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicity/mainScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:intl/intl.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  List names = [];
  List mysongs = [];
  List myartists = [];
  List myduration = [];
  List mypaths = [];
  List albuminfo = [];
  var number;
  List tot = [];
  String fr;
  int fir;
  bool permission = false;

  void callsetstate() {
    setState(() {});
  }

  void runfirst() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permission = true;
      });
      print('granted');
      if (permission == true) {
        getsongs();
        Timer(Duration(seconds: 2), onClose);
      }

      number = 1;
    } else {
      onClose();
      number = 2;
    }
  }

  void getsongs() async {
    List songs = await audioQuery.getSongs();
    List albumList = await audioQuery.getAlbums();
    albumList.forEach((element) {
      albuminfo.add(element);
    });
    songs.forEach((song) {
      tot.add(song);
      mysongs.add(song.title);
      myartists.add(song.artist);
      mypaths.add(song.filePath);
      DateTime date = new DateTime.fromMicrosecondsSinceEpoch(
          int.parse(song.duration) * 1000);
      String formattedTime = DateFormat.ms().format(date);
      myduration.add(formattedTime);
    });
    callsetstate();
  }

  @override
  void initState() {
    super.initState();
    runfirst();
  }

  void onClose() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (conext) => MainScreen(
              mypermission: permission,
              total: tot,
              album: albuminfo,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(61, 1, 1, 1),
          child: Image(
            image: AssetImage('assets/images/trans.png'),
          ),
        ),
      ),
    );
  }
}
