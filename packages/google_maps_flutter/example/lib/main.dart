// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'animate_camera.dart';
import 'map_ui.dart';
import 'move_camera.dart';
import 'page.dart';
import 'place_marker.dart';
import 'scrolling_map.dart';

final List<Page> _allPages = <Page>[
  MapUiPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  PlaceMarkerPage(),
  ScrollingMapPage(),
];

class MapsDemo extends StatelessWidget {
  void _pushPage(BuildContext context, Page page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Glitch(),
      // body: ListView.builder(
      //   itemCount: _allPages.length,
      //   itemBuilder: (_, int index) => ListTile(
      //         leading: _allPages[index].leading,
      //         title: Text(_allPages[index].title),
      //         onTap: () => _pushPage(context, _allPages[index]),
      //       ),
      // ),
    );
  }
}

void main() {
  timeDilation = 0.0001;
  runApp(MaterialApp(home: MapsDemo()));
}


class Glitch extends StatefulWidget {
  @override
  State<Glitch> createState() => GlitchState();
}

class GlitchState extends State<Glitch> {
  bool showMap = false;

  @override
  Widget build(BuildContext context) {
   return Column(
     children: <Widget>[
       Text('Hello'),
       Container(
         width: 300,
         height: 300,
         child: showMap ?
         GoogleMap(
           initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
         )
             : null,
       ),
       GestureDetector(
         onTap: () {
           setState(() {
             showMap = !showMap;
           });
         },
         child: Text('TOGGLE SHOW MAP'),
       ),
     ],
   );
  }
}