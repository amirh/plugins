// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: WebViewExample()));

class WebViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Flutter WebView example'),
            // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
            actions: <Widget>[const SampleMenu()],
        ),
        //     body: const WebView(
        //         initialUrl: 'https://sketch.io/sketchpad/',
        //         javaScriptMode: JavaScriptMode.unrestricted,
        //     ),
        body: Transform(  // Transform widget
            transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(0.4)
            ..rotateY(0.7),
            alignment: FractionalOffset.center,
            child: const WebView(
                initialUrl: 'https://sketch.io/sketchpad/',
                javaScriptMode: JavaScriptMode.unrestricted,
            ),
        ),
    );
  }
}

class SampleMenu extends StatelessWidget {
  const SampleMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('You selected: $value')));
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            const PopupMenuItem<String>(
              value: 'Item 1',
              child: Text('Item 1'),
            ),
            const PopupMenuItem<String>(
              value: 'Item 2',
              child: Text('Item 2'),
            ),
          ],
    );
  }
}
