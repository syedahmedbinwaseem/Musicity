import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:intl/intl.dart';

class Album extends StatefulWidget {
  String image;
  String name;
  List songs;
  Album({this.image, this.name, this.songs});
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> with TickerProviderStateMixin {
  String songname;
  String artistname;

  AnimationController animated;

  @override
  void initState() {
    animated =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    animated.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var top = 0.0;
    var padding = MediaQuery.of(context).padding;
    double height2 = screenHeight - padding.top;
    double status = screenHeight - height2;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: Color.fromRGBO(61, 1, 1, 1),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.45,
              width: screenWidth,
              color: Colors.yellow,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: screenWidth,
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        child: Container(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(61, 1, 1, 0.7)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: screenWidth,
                    height: status + 50,
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                margin:
                                    EdgeInsets.only(top: status + 20, left: 20),
                                height: 20,
                                child: Image(
                                    image:
                                        AssetImage('assets/images/back.png'))),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: status + 20, right: 40),
                                child: Text(
                                  'Playing from Album',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircleAvatar(
                      radius: (screenHeight * 0.45) / 3.2,
                      backgroundImage: AssetImage(widget.image),
                    )),
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.06,
              color: Color.fromRGBO(61, 1, 1, 1),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/album.png',
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 26,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 19),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.songs.length == 1
                          ? '${widget.songs.length} Song'
                          : '${widget.songs.length} Songs',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sans Light',
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.49,
              child: Stack(
                children: [
                  Container(
                    color: Color.fromRGBO(61, 1, 1, 1),
                  ),
                  ListView.builder(
                    itemCount: widget.songs == null ? 0 : widget.songs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          // play(widget.songs[index].filePath);
                          // animated.forward();
                          // setState(() {
                          //   songname = widget.songs[index].title;
                          //   artistname = widget.songs[index].artist;
                          // });
                          // myindex = index;
                          // isSearching
                          //     ? print('asd')
                          //     : setState(() {
                          //         conheight = 70;
                          //       });
                        },
                        child: Container(
                          height: 60,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                child: Image(
                                  height: 30,
                                  image: AssetImage('assets/images/song.png'),
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
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromRGBO(73, 1, 1, 1),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 9),
                                          child: Text(
                                            widget.songs[index].title,
                                            style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 25,
                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            top: 2,
                                          ),
                                          child: Text(
                                            widget.songs[index].artist,
                                            style: TextStyle(
                                                fontFamily: 'Sans Light',
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w100),
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
                                    image: AssetImage('assets/images/menu.png'),
                                    height: 13,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    DateFormat.ms().format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                                widget.songs[index].duration))),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// appBar: AppBar(

//   bottom: PreferredSize(
//       child: Container(
//         color: Colors.yellow,
//         height: screenHeight * 0.35,
//         // child: Stack(
//         //   children: [
//     Stack(
//       children: [
//         Container(
//           width: screenWidth,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage(widget.image),
//                 fit: BoxFit.cover),
//           ),
//         ),

//       ],
//     ),
//     Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: Center(
//         child: CircleAvatar(
//           backgroundImage: AssetImage(widget.image),
//           radius: top < 150 ? 0 : ((screenHeight * 0.4) - 20) / 3,
//         ),
//       ),
//     ),
//   ],
// ),
//             ),
//             preferredSize: Size.fromHeight(screenHeight * 0.35)),
//       ),
//     );
//   }
// }
//   body: NestedScrollView(
//       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//         return [
// SliverAppBar(
//   expandedHeight: screenHeight * 0.45,
//   flexibleSpace: LayoutBuilder(builder:
//       (BuildContext context, BoxConstraints constraints) {
//     top = constraints.biggest.height;
//     return Stack(
//       children: [
//         Stack(
//           children: [
//             Container(
//               width: screenWidth,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage(widget.image),
//                     fit: BoxFit.cover),
//               ),
//             ),
//             ClipRRect(
//               child: Container(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Color.fromRGBO(61, 1, 1, 0.7)),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Center(
//             child: CircleAvatar(
//               backgroundImage: AssetImage(widget.image),
//               radius:
//                   top < 150 ? 0 : ((screenHeight * 0.4) - 20) / 3,
//             ),
//           ),
//         ),
//       ],
//     );
//   }),
//   pinned: true,
//   floating: false,
//   backgroundColor: Color.fromRGBO(61, 1, 1, 1),
//   elevation: 0,
//   bottom: PreferredSize(
//     preferredSize: Size.fromHeight(30),

//   ),
//   title: Text(
//     'Playing from Album',
//     style: TextStyle(
//         fontFamily: 'Open Sans',
//         fontWeight: FontWeight.w500,
//         fontSize: 14),
//   ),
//   leading: IconButton(
//     icon: Icon(
//       Icons.arrow_back_ios,
//       size: 25,
//     ),
//     onPressed: () {
//       Navigator.pop(context);
//     },
//   ),
//   centerTitle: true,
//           ),
//           SliverPersistentHeader(delegate: SliverAppBarDelegate(100, 0))
//         ];
//       },

// );
// }
